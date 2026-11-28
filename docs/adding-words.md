# Adding words

Step-by-step instructions for an agent (or a person) running a word cycle.
`README.md` describes the tools; this page says how to use them.

New vocabulary is added in cycles of 500 words (five sets of 100) by
`scripts/author_cycle.rb`. The script does all of it: selection, one model
call per 25 words, checks, retries, one commit per word, the ledgers,
PROGRESS.md and the pitch accents. **Do not write entries or payloads
yourself**; run the script and review what it reports.

## Before you start

- The git-ignored data (`sources/`, `tmp/jmdict_cache.sqlite`,
  `tmp/warodai_cache.sqlite`) lives in the main checkout. In a worktree, pass
  `--data-root <main checkout>`.
- The default model is Gemini 4 Hydrogen (high) through the Antigravity ACP
  server (`~/.local/share/agy-acp-server/agy_acp_server.par` or
  `AGY_ACP_SERVER`); the Antigravity app must be signed in.
- MeCab (`brew install mecab mecab-ipadic`) cross-checks example readings.
- Run Ruby with `LANG=en_US.UTF-8`.

## The cycle

1. Branch from `main`: `feat/add-500-words-sets-<first>-<last>`. The first
   set number is the count of `docs/n10k-next100-*.tsv` ledgers plus one.
2. Run the cycle in the background (about 50 minutes):

   ```sh
   LANG=en_US.UTF-8 ruby scripts/author_cycle.rb --tag <branch-or-date> --next 500
   ```

   `--next 500` continues from the highest BCCWJ rank in the ledgers. Keep
   the same `--tag` to resume: rerunning the same command picks up where it
   stopped.
3. If it stops with words still failing, read
   `tmp/<tag>/failures-NN.json`. Rerun to retry, or fix that word in
   `tmp/<tag>/batch-NN.json` and rerun.
4. Review `tmp/<tag>/reading-flags.jsonl`, where MeCab's reading of an
   example disagrees with the model's. Most flags are MeCab's own errors
   (日本 as にっぽん, 間 as ま, 一本 as いちほん, 二人 as ににん). Fix only real model
   misreadings, in the entry's `READING` line, then run
   `tools/jb/build/bin/jb check --yanagi --emacs <files>` and commit them
   together as `fix: correct example readings in sets <first>-<last>`.
5. Run `bundle exec rake test` and compare with `main`.
6. Open a PR titled `feat: add 500 BCCWJ vocabulary entries (Sets <first>-<last>)`.
   Say in a few lines what the cycle took (time, retries, readings fixed),
   from `tmp/<tag>/usage.tsv`.

## Rules

- Commits are made by the script, in the repository's style. Add no AI
  attribution (no `Co-Authored-By` trailers) to commits or PRs.
- Stage files by name; never `git add -A`.
- Do not change the prompt, checks or default model as part of a cycle; that
  is a separate PR with a benchmark (`docs/authoring-model-benchmark.md`).

## Model and quota

A 500-word cycle uses about 16 points of the Gemini 5-hour window and 5 points
of the week. To read the meters, open Antigravity → Settings → Models and
press the refresh button next to "Models & Usage" first. If the Gemini quota is
out, use a fallback from the benchmark:

```sh
… --provider claude --model sonnet                    # Claude Sonnet 5.5
… --provider codex --model gpt-6.2-sol --home ~/.codex-multi-2
```
