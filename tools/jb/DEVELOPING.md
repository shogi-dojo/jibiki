# Developing jb

`jb` runs the per-batch steps of the word-adding loop in one process. It is plain Ruby with no gems, so the same sources run in two ways:

- under CRuby, as `ruby tools/jb/bin/jb.rb`;
- as a native binary compiled by [Spinel](https://github.com/matz/spinel), matz's ahead-of-time Ruby compiler.

The checks themselves live in `lib/`, in the same files `rake` and `scripts/` use. Nothing in the sources may depend on the compiled build existing.

## Building Spinel

There is no package for it. Build it from source and put its `bin/` on PATH; `make install` is optional.

```sh
git clone https://github.com/matz/spinel ~/projects/spinel
cd ~/projects/spinel && git checkout 719eae49   # the commit jb was verified with
make deps && make
export PATH="$HOME/projects/spinel/bin:$PATH"
```

Homebrew has an unrelated `spin` formula. Make sure `spin --help` mentions Spinel.

## Building, testing, installing

```sh
rake jmdict:index        # once per JMdict archive: the binary reads JMdict only through this index
rake jb:build            # tools/jb/build/bin/jb (~10 s)
rake jb:test             # CRuby checks, then `spin test`: each test compiled and diffed against CRuby
tools/jb/install/install.sh   # native binary to ~/.local/bin/jb, or a CRuby shim without spin
```

`rake jb:build` and the installer delete the old binary first: `spin build` only checks `tools/jb` for changes, so after an edit to `lib/` a plain `spin build jb` reports "up to date" and keeps the stale binary. Rake tasks also refuse a binary older than any source and fall back to CRuby. `rake jb:test` removes compiled test executables before running the parity gate, so changes to shared `lib/` code cannot reuse stale test binaries.

Always build the `jb` target by name. A bare `spin build` also compiles `bin/test.rb`, and a binary called `test` on PATH shadows the shell builtin.

## Keeping lib/ compilable

Spinel compiles the whole program ahead of time, so the files `jb` reaches must stay inside its Ruby subset. These rules came out of porting the validator:

- **Requires.** No gems, no runtime or globbed requires. Every file is a literal `require_relative`. JMdict's REXML parser and the archive scan stay outside: `lib/entry_validator/archive_fallback.rb` registers them for CRuby callers only.
- **Regexps.** No Unicode script properties (`\p{Han}`, `\p{Cyrillic}`): Spinel's engine has the general categories (`\p{L}`) but not scripts. Use the generated classes in `lib/generated/unicode_scripts.rb`.
- **Data files.** No YAML at run time. Yanagi's mora rules are frozen into `lib/generated/romaji_table.rb`; rerun `scripts/gen_yanagi_tables.rb` after a yanagi upgrade.
- **Frozen literals.** Don't call `force_encoding` on a frozen literal. CRuby without the magic comment tolerates it, Spinel raises `FrozenError`.

The binary also bakes in the checkout's absolute path, because `__dir__` is resolved at compile time. It links Homebrew's libraries, so it is a local build, not something to copy to another machine.

## Debugging a compiled failure

A release build has no backtraces. Compile a debug build of a small driver to get file and line frames:

```sh
spinel --debug --strict-require driver.rb -o driver && ./driver
```
