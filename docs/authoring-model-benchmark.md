# Authoring model benchmark (2026-11-28)

`scripts/author_cycle.rb` asks a model only for content: a Ukrainian gloss and
learner note per English sense, and three graded example sentences with their
Ukrainian translations and hiragana readings. This page compares the models
that can do that job through ACP. It records how reliable, fast and costly
each one is, and how good the Ukrainian and Japanese it writes are.

## Setup

- **Words.** Set A is 20 words already in the corpus, chosen across kinds:
  multi-sense, kana-only, verbs, adjectives. Set B is the next 20 unselected
  words from BCCWJ. Both are listed below.
- **Run.** Each model wrote each set in one call of 20 words, with up to two
  targeted retries:

  ```sh
  ruby scripts/bench_models.rb run --set A --provider P --model M
  ```

  Each run passed `jb check --yanagi --emacs` with no commits.
- **Clients.**
  - Claude: `claude-agent-acp`, with the system prompt overridden and no tools
    or settings.
  - Codex: `codex-acp` 2.12.1 with codex-cli 0.172.0 (system prompt appended).
  - Gemini: the Antigravity ACP server, with Antigravity 2.36.0 (rules
    prepended to the prompt).
- **Cost.**
  - Claude reports its cost itself. The others are estimated from API list
    prices (`lib/authoring/prices.rb`), marked with `~`.
  - Subscription usage is the change in each app's usage meter over a model's
    two runs, read from screenshots. The meters move in whole points.

Set A: 春季 曙光 シラブル 上訴 接ぐ 腹立ち紛れ 番外 ふるい落とす ペナント むず痒い 忽せ 老境
からっきし 黒み 検尿 購読者 システマティック 上帝 添い遂げる 断罪.

Set B: 無欲 迷宮入り 名句 免許皆伝 元払い 門外不出 焼き豚 雇い入れ 矢場 山国 碼 雪あかり 雪女
湯口 宵闇 妖魔 横縞 葦原 夜鷹 呼び入れる.

## Results (sets A and B together, 40 words)

| model | first-try fails | still failing | seconds | output tokens | ≈ $ | subscription usage | quality |
|---|---|---|---|---|---|---|---|
| **Gemini 4 Hydrogen (high)** | 0 | 0 | 184 | 11.4k | ~0.13 | Gemini 5h +2, week +1 | ★★★ |
| Gemini 3.8 Flash (high) | 0 (2 on a first run) | 0 | 356 (685 on a first run) | 10.8k | ~0.07 | Gemini 5h +1, week +0 | ★★ |
| Claude Opus 5.5 | 1 | 0 | 273 | 29.0k | 0.63 | Claude session +5, week +1 | ★★★ |
| Claude Sonnet 5.5 | 1 | 0 | 127 | 13.8k | 0.16 | Claude session about +2 | ★★½ |
| Claude Haiku 5.5 | 20 | 1 | 331 | 72.8k | 0.04 | Claude session +1 | ★ |
| GPT-6.2 Astra | 0 | 0 | 223 | 10.7k | ~0.60 | Codex 5h +10, week +2 | ★★★ |
| GPT-6.2 Sol | 1 | 0 | 282 | 13.7k | ~0.18 | Codex 5h +3 | ★★½ |
| GPT-6 Luna | 5 | 0 | 198 | 10.6k | ~0.01 | Codex 5h +0 | ★ |

The per-run table, with input and cached tokens and reading flags, is in
`tmp/bench/report.md` (`ruby scripts/bench_models.rb report`).

Notes on the numbers:

- Opus spends about 75% of its output on thinking, and Haiku even more: 1,800
  tokens per word for about 650 characters of reply.
- Codex and Antigravity add about 15k input tokens of harness per call. Codex
  serves them from cache; Antigravity does not. Claude adds almost nothing.
- Antigravity's speed varies from run to run: Flash took 685 s with two
  retries the first time and 356 s with none on a rerun with the same prompt.
  The table's Flash figures are from the rerun, whose usage could be read.
- Sonnet's figure is its last set-A run plus set B. Two earlier set-A runs
  exposed the missing-reading bug fixed on this branch, and their usage is
  left out.

## Quality review

Set A was read side by side with the corpus entries
(`ruby scripts/bench_models.rb compare --set A`), and set B on its own. The
review checked:

- glosses that match each JMdict sense;
- notes that add something (collocations, register, the everyday synonym);
- natural, graded Japanese;
- correct readings;
- natural Ukrainian: no calques or non-words, euphony, faithful translation.

- **Gemini 4 Hydrogen (high).**
  - Accurate glosses on every hard multi-sense word: 番外, 上帝, 添い遂げる,
    矢場, 焼き豚.
  - The richest notes. They name the everyday synonym with its reading
    (春 (はる), 夜明け (よあけ)) and give typical collocations.
  - Natural Ukrainian, and no defects found.
  - It writes in the style of the existing corpus, which was written with it.
- **Claude Opus 5.5.** As accurate as Hydrogen, with concise and pointed
  notes and natural Ukrainian. No defects found. It costs five times as much.
- **GPT-6.2 Astra.** Among the most idiomatic Ukrainian of all the runs, with
  well-chosen everyday examples. It had one non-word (відбираковувати) and
  one odd example (一シラブル). Expensive on the Codex meter.
- **Claude Sonnet 5.5.** Good, with slips:
  - two non-words (забрезкотів, позаочерговий);
  - a misreading (東の空 read as とうのそら);
  - a weak gloss for an adjective (свербіти; свербляче).
- **GPT-6.2 Sol.** Good notes, and it catches the theatrical "supernumerary"
  sense of 番外 (статист). Slips:
  - a repeated gloss (відсіювати; відсіювати кандидатів);
  - 今回 translated as "this year's";
  - one misreading (だいしだいに).
- **Gemini 3.8 Flash.** Correct but plainer. Its notes are generic and some
  wording is stiff or overstated: велетенський for "outsize", Крикнув у стані
  гніву.
- **Claude Haiku 5.5.**
  - Its first set-A reply broke the format and ended in English prose.
  - It wrote a Czech letter (позапланový), a gender agreement error
    (несправедливого догани) and a misreading (詩 as うた).
  - One word, むず痒い, never passed.
- **GPT-6 Luna.** Short, thin notes, and a Japanese full stop at the end of
  15 Ukrainian sentences. Several readings skipped part of the sentence.

The new style checks in `lib/authoring/item_check.rb` came out of this review.
They catch Japanese punctuation in Ukrainian text, words mixing Latin and
Cyrillic letters, and spaces in readings, so those words get a retry.

MeCab's reading flags are mostly MeCab's own mistakes: 接ぐ as つぐ, 一審 as
いちしん, 一曲 as いちきょく. Still, they also caught each real misreading
above, so they are worth a glance but are never a reason to retry.

## Recommendation

**Gemini 4 Hydrogen (high) through Antigravity** is the default in
`scripts/author_cycle.rb`:

- It is the only run with no retries on either set at the top quality tier.
- It was the fastest, about 90 seconds per 20 words.
- It cost about $0.13 per 40 words at list prices and about 2 points of the
  Gemini 5-hour window.

At that rate a 500-word cycle takes about 40 minutes of model time. It should
use about 25 points of one Gemini 5-hour window and 12 points of the week,
spread over the windows the run spans.

Fallbacks, if the Gemini quota runs out:

- **Claude Sonnet 5.5** (`--provider claude --model sonnet`) is cheap on the
  Claude meter. Review its reading flags.
- **GPT-6.2 Sol** (`--provider codex --model gpt-6.2-sol`) is the Codex
  choice.
- **Gemini 3.8 Flash** (`--model gemini-3.8-flash`) uses half of Hydrogen's
  Gemini quota. Its content is correct but plainer, and its speed varies.

Opus and Astra are as good as Hydrogen but cost four to five times as much.
Keep them for the occasional hard batch. Haiku and Luna are not good enough
for the corpus.

## Against the old loop

The last agent-run cycle (`n10k-500z`, 500 words) wrote pretty-printed JSON
payloads of 1,036 characters per word, through parallel subagents that also
read dossiers, ran checks and fixed failures in tool calls. Every one of those
steps carried an agent's system prompt and tool round-trips.

The new loop asks for 430–750 characters per word in one call per batch, and
retries only the failing words. Selection, rendering, readings
cross-checking, checks, commits, ledgers and accents run as plain scripts.

## Rerunning

```sh
ruby scripts/bench_models.rb prepare --from tmp/n10k-500z-sources.json --min-rank 81734   # sets A and B
ruby scripts/bench_models.rb run --set A --provider antigravity --model gemini-4-hydrogen --effort high
ruby scripts/bench_models.rb report
ruby scripts/bench_models.rb compare --set A
```
