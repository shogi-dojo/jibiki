#!/bin/sh
# Installs the `jb` CLI from this checkout:
#
#   tools/jb/install/install.sh              native binary if Spinel is present, else a CRuby shim
#   tools/jb/install/install.sh --ruby       force the CRuby shim
#   tools/jb/install/install.sh --native     force the Spinel build
#   tools/jb/install/install.sh --uninstall  remove it again
#
# JB_INSTALL_DIR  where to put it (default ~/.local/bin)
set -eu

pkg="$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)"
mode=auto
uninstall=no

while [ $# -gt 0 ]; do
  case "$1" in
    --ruby) mode=ruby ;;
    --native) mode=native ;;
    --uninstall) uninstall=yes ;;
    -h|--help) sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "jb install: unknown option $1" >&2; exit 2 ;;
  esac
  shift
done

fail() { echo "jb install: $*" >&2; exit 1; }

dir="${JB_INSTALL_DIR:-$HOME/.local/bin}"
target="$dir/jb"

if [ "$uninstall" = yes ]; then
  [ -e "$target" ] || fail "nothing installed at $target"
  rm -f "$target"
  echo "Removed $target"
  exit 0
fi

# Refuse to clobber an unrelated `jb`.
if [ -e "$target" ] && ! "$target" --version 2>/dev/null | grep -q '^jb '; then
  fail "$target exists and is not this jb; move it aside first"
fi

if [ "$mode" = auto ]; then
  if command -v spin >/dev/null 2>&1; then mode=native; else mode=ruby; fi
fi

mkdir -p "$dir"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

if [ "$mode" = native ]; then
  command -v spin >/dev/null 2>&1 || fail "spin is not on PATH; see tools/jb/DEVELOPING.md, or use --ruby"
  echo "Building jb with Spinel..."
  # Name the target: a bare build would also compile bin/test.rb, and a binary
  # called `test` on PATH shadows the shell builtin.
  # Always rebuild: spin checks only tools/jb for changes, not the lib/ it compiles.
  rm -f "$pkg/build/bin/jb"
  ( cd "$pkg" && spin build jb ) || fail "spin build failed"
  cp "$pkg/build/bin/jb" "$tmp/jb"
  chmod 755 "$tmp/jb"
  mv "$tmp/jb" "$target"
  echo "Installed jb (native) to $target; rerun after pulling changes to lib/ or tools/jb/"
else
  command -v ruby >/dev/null 2>&1 || fail "neither spin nor ruby is on PATH"
  # The same sources run under CRuby; the shim keeps the checkout authoritative.
  cat > "$tmp/jb" <<SHIM
#!/bin/sh
exec ruby "$pkg/bin/jb.rb" "\$@"
SHIM
  chmod 755 "$tmp/jb"
  mv "$tmp/jb" "$target"
  echo "Installed jb (CRuby shim -> $pkg/bin/jb.rb) to $target"
fi

case ":$PATH:" in
  *":$dir:"*) ;;
  *) echo "Add it to your PATH:  export PATH=\"$dir:\$PATH\"" ;;
esac
