#!/usr/bin/env bash
# Benchmarks the word-adding loop: wall time, user+sys CPU, peak RSS and page
# faults for each step, the median of RUNS runs (/usr/bin/time -l, macOS).
#
#   scripts/bench_loop.sh <label> [step ...]
#
# Results land in build/bench/<label>-<date>.tsv and .md (build/ is ignored).
# The sample is the 10 most recently added entries, i.e. one real batch.
# Git steps replay that batch in a throwaway worktree, never on this checkout.
# Steps that need a tool which is absent (jb, the native binary) are skipped,
# so the same script measures both the baseline and the result.
set -euo pipefail

cd "$(dirname "$0")/.."
ROOT=$PWD
LABEL=${1:?usage: scripts/bench_loop.sh <label> [step ...]}
shift
ONLY="$*"
RUNS=${RUNS:-3}
SLOW_RUNS=${SLOW_RUNS:-1}
OUT_DIR=$ROOT/build/bench
STAMP=$(date +%Y-%m-%d)
TSV=$OUT_DIR/$LABEL-$STAMP.tsv
MD=$OUT_DIR/$LABEL-$STAMP.md
WORK=$(mktemp -d "${TMPDIR:-/tmp}/jibiki-bench.XXXXXX")
mkdir -p "$OUT_DIR"

JB_RUBY=(ruby "$ROOT/tools/jb/bin/jb.rb")
JB_NATIVE=$ROOT/tools/jb/build/bin/jb

SAMPLE=()
while IFS= read -r path; do SAMPLE+=("$path"); done < <(git log --no-merges --diff-filter=A --name-only --format= -n 10 -- entries | sed '/^$/d')
SAMPLE1=("${SAMPLE[0]}")
# The checkpoint replays a 500-word set: everything since the 501st commit back.
CHECKPOINT_BASE=$(git rev-list --no-merges --skip=500 -n1 HEAD)

# Selection rows for the jb checkpoint step: every entry added since the
# checkpoint baseline, in commit order, as the loop's sources file lists them.
git log --reverse --no-merges --diff-filter=A --name-only --format= "$CHECKPOINT_BASE..HEAD" -- entries |
  sed '/^$/d' | ruby -rjson -e 'puts JSON.generate(STDIN.read.split("\n").map { |path| { "path" => path } })' \
  >"$WORK/bench-sources.json"

cleanup() {
  for wt in "$WORK"/wt-*; do
    [ -d "$wt" ] && git worktree remove --force "$wt" >/dev/null 2>&1 || true
  done
  rm -rf "$WORK"
}
trap cleanup EXIT

LINT_EXPR="(progn (require 'org) (let ((failed nil)) (dolist (path command-line-args-left) (with-current-buffer (find-file-noselect path) (let ((issues (org-lint))) (when issues (princ (format \"%s\\n\" path)) (prin1 issues) (setq failed t))))) (kill-emacs (if failed 1 0))))"

# A worktree at the commit before the sample batch, with the batch's files
# copied in untracked: the state just before commit.py ran.
prepare_commit_worktree() {
  local wt=$WORK/wt-$RANDOM
  local first
  first=$(git log --no-merges --diff-filter=A --format=%H -n 10 -- entries | tail -1)
  git worktree add --quiet --detach "$wt" "$first^"
  for path in "${SAMPLE[@]}"; do
    mkdir -p "$wt/$(dirname "$path")"
    cp "$path" "$wt/$path"
  done
  echo "$wt"
}

# Mirrors tmp/n10k-*-commit.py: six git processes per word.
legacy_commit() {
  local wt=$1
  cd "$wt"
  git diff --cached --name-only >/dev/null
  for path in "${SAMPLE[@]}"; do
    git status --short >/dev/null
    git add -- "$path"
    git diff --cached --name-only >/dev/null
    git -c commit.gpgsign=false commit --quiet --no-verify -m "feat: add bench vocabulary entry" >/dev/null
    git status --short >/dev/null
    git rev-parse --short HEAD >/dev/null
  done
}

# Mirrors tmp/n10k-*-checkpoint.py: one diff-tree per commit since the baseline.
legacy_checkpoint() {
  local sha
  for sha in $(git rev-list --reverse "$CHECKPOINT_BASE..HEAD"); do
    git diff-tree --no-commit-id --name-only -r --diff-filter=A "$sha" -- entries >/dev/null
  done
}

# name|runs|availability check|command (evaluated)
STEPS=(
  "ruby_boot|$RUNS|true|ruby -e0"
  "bundle_ruby_boot|$RUNS|true|bundle exec ruby -e0"
  "validate_1|$RUNS|true|bundle exec ruby scripts/validate_entry.rb \"\${SAMPLE1[@]}\""
  "validate_10|$RUNS|true|bundle exec ruby scripts/validate_entry.rb \"\${SAMPLE[@]}\""
  "doctor_10|$RUNS|true|bundle exec ruby scripts/doctor.rb --json \"\${SAMPLE[@]}\""
  "yanagi_10|$RUNS|true|bundle exec ruby -r yanagi -e 'exit(Yanagi.audit(ARGV, tier2: false).empty? ? 0 : 1)' \"\${SAMPLE[@]}\""
  "org_lint_10|$RUNS|true|emacs --batch --eval \"\$LINT_EXPR\" \"\${SAMPLE[@]}\""
  "commit_10_legacy|$RUNS|true|legacy_commit \"\$WT\""
  "checkpoint_500_legacy|$RUNS|true|legacy_checkpoint"
  "jb_ruby_check_10|$RUNS|[ -f tools/jb/bin/jb.rb ]|\"\${JB_RUBY[@]}\" check \"\${SAMPLE[@]}\""
  "jb_native_check_10|$RUNS|[ -x \"\$JB_NATIVE\" ]|\"\$JB_NATIVE\" check \"\${SAMPLE[@]}\""
  "jb_native_validate_1|$RUNS|[ -x \"\$JB_NATIVE\" ]|\"\$JB_NATIVE\" validate \"\${SAMPLE1[@]}\""
  "jb_native_doctor_10|$RUNS|[ -x \"\$JB_NATIVE\" ]|\"\$JB_NATIVE\" doctor --json \"\${SAMPLE[@]}\""
  "jb_commit_10|$RUNS|[ -f tools/jb/bin/jb.rb ]|(cd \"\$WT\" && \"\$(jb_cmd)\" commit \"\${SAMPLE[@]}\")"
  "jb_checkpoint_500|$RUNS|[ -f tools/jb/bin/jb.rb ]|\"\$(jb_cmd)\" checkpoint --dry-run --sources \"\$WORK/bench-sources.json\" --baseline \"\$CHECKPOINT_BASE\" --ledger /dev/null --set-size 500"
  "test_fast|$SLOW_RUNS|grep -q 'test:fast' Rakefile 2>/dev/null|bundle exec rake test:fast"
  "test_full|$SLOW_RUNS|true|bundle exec rake test"
)

# The binary when it is built, otherwise a ruby shim; used by the git steps.
jb_cmd() {
  if [ -x "$JB_NATIVE" ]; then
    echo "$JB_NATIVE"
  else
    local shim=$WORK/jb
    printf '#!/bin/sh\nexec ruby %q "$@"\n' "$ROOT/tools/jb/bin/jb.rb" >"$shim"
    chmod +x "$shim"
    echo "$shim"
  fi
}

wanted() {
  [ -z "$ONLY" ] && return 0
  case " $ONLY " in *" $1 "*) return 0 ;; esac
  return 1
}

# Prints "wall user sys rss_mb faults status" for one run of the command.
measure() {
  local cmd=$1 log=$WORK/time.log status=0
  WT=
  case "$cmd" in *'$WT'*) WT=$(prepare_commit_worktree) ;; esac
  (cd "$ROOT" && /usr/bin/time -l bash -c "$(declare -f legacy_commit legacy_checkpoint prepare_commit_worktree jb_cmd); $(declare -p SAMPLE SAMPLE1 WORK ROOT CHECKPOINT_BASE LINT_EXPR JB_RUBY JB_NATIVE WT); $cmd" >"$WORK/out.log" 2>"$log") || status=$?
  awk -v status="$status" '
    /real/ && /user/ { wall=$1; user=$3; sys=$5 }
    /maximum resident set size/ { rss=$1 / 1048576 }
    /page faults/ && !/reclaims/ { faults=$1 }
    END { printf "%.2f %.2f %.2f %.1f %d %d\n", wall, user, sys, rss, faults, status }
  ' "$log"
  if [ -n "$WT" ]; then git worktree remove --force "$WT" >/dev/null 2>&1 || true; fi
}

median() { sort -n | awk '{ v[NR]=$1 } END { print v[int((NR + 1) / 2)] }'; }

printf 'step\truns\twall_s\tcpu_s\tuser_s\tsys_s\tpeak_rss_mb\tpage_faults\texit\n' >"$TSV"
for spec in "${STEPS[@]}"; do
  IFS='|' read -r name runs check cmd <<<"$spec"
  wanted "$name" || continue
  if ! (cd "$ROOT" && eval "$check"); then
    echo "skip  $name (not available)"
    continue
  fi
  : >"$WORK/runs"
  for _ in $(seq "$runs"); do measure "$cmd" >>"$WORK/runs"; done
  wall=$(awk '{print $1}' "$WORK/runs" | median)
  user=$(awk '{print $2}' "$WORK/runs" | median)
  sys=$(awk '{print $3}' "$WORK/runs" | median)
  rss=$(awk '{print $4}' "$WORK/runs" | median)
  faults=$(awk '{print $5}' "$WORK/runs" | median)
  status=$(awk '{print $6}' "$WORK/runs" | sort -n | tail -1)
  cpu=$(awk -v u="$user" -v s="$sys" 'BEGIN { printf "%.2f", u + s }')
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$name" "$runs" "$wall" "$cpu" "$user" "$sys" "$rss" "$faults" "$status" >>"$TSV"
  printf '%-24s wall %6ss  cpu %6ss  rss %7s MB  exit %s\n' "$name" "$wall" "$cpu" "$rss" "$status"
done

{
  echo "# Loop benchmark: $LABEL ($STAMP)"
  echo
  echo "Commit \`$(git rev-parse --short HEAD)\`, $(sysctl -n machdep.cpu.brand_string 2>/dev/null || uname -m), sample of ${#SAMPLE[@]} entries, median of runs."
  echo
  echo "| step | runs | wall s | CPU s | peak RSS MB | page faults | exit |"
  echo "|---|---:|---:|---:|---:|---:|---:|"
  tail -n +2 "$TSV" | awk -F'\t' '{ printf "| %s | %s | %s | %s | %s | %s | %s |\n", $1, $2, $3, $4, $7, $8, $9 }'
} >"$MD"
echo "wrote $TSV and $MD"
