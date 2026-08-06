# Dictionary entry progress

This is the merge ledger for the authored dictionary. It records what exists,
what has actually been reviewed, and what may be described as release-ready.
It must not be used to infer linguistic approval merely because an entry passes
the automated JMdict and Org checks.

Last reconciled with the entry tree: **2026-07-17** at entry commit
`5b32241`.

## Schema flag day (2026-07-17)

All 291 entries were mechanically migrated from schema v1 to schema v2 in
commit `2b8d5cc` (`scripts/migrate_schema_v2.rb`, with a built-in
before/after content-preservation check — zero content loss across all 291
files). Schema v2 (`docs/org-format.md`) adds omit-when-empty list
subsections, file-level provenance defaults (`#+DEFAULT_*`), compact English
gloss / Russian reference syntax, and a sense-level `:LEARNER_PRIORITY:
primary` property with a structural 3-graded-example validator requirement
(`9fd4201`). Total `entries/` line count dropped from 96,518 to 55,334
(~43%); a typical entry is now roughly a third of its former size (e.g.
音楽/ongaku 156→108 lines). The new canonical generator is
`scripts/scaffold_entry.rb` (`rake "entries:scaffold[order,romaji]"`),
replacing the old `scratch/gen_n5_part*.py` one-off scripts. Migration
surfaced 11 entries (the `codex-agent-N` batch) whose `LEARNER_PRIORITY`
sense failed the new example-count gate; all 15 affected senses have since
been brought to three graded examples and the full gate is green. One
defective example was replaced in the process: 開く(あく) sense 3 carried
お腹が空きました read すきました, which belongs to the separate JMdict entry
空く(すく) and taught the wrong reading for あく.

## Snapshot

| Metric | Current |
| --- | ---: |
| Canonical entry files | 658 |
| Canonical N5 entries | 659 |
| N5 queue rows covered | 667 / 667 (100.0%) |
| Extra seed entries | 1 (`日本語`) |
| `new` | 254 |
| `changes-requested` | 0 |
| `reviewed` | 9 |
| `confirmed` | 28 |
| `solid` | 0 |
| Entry metadata still marked `draft` | 264 |
| Learner profile | 291 |
| Enriched profile | 1 |

Queue rows 1–299 are represented without gaps. Eight queue aliases collapse
into existing JMdict entries, which is why 299 queue rows produce 291 canonical
N5 entry files. The seed entry `日本語` is outside the N5 queue.

## Maturity workflow

Maturity and schema breadth answer different questions. The maturity state below
tracks confidence; the profile (`core`, `learner`, `enriched`, or `gold`)
tracks how much detail the entry promises.

- **new** — authored and available, but no documented editorial review.
- **changes-requested** — a review found one or more unresolved findings.
- **reviewed** — an editorial/structural review was completed and its known
  findings were fixed; this is not yet independent bilingual approval.
- **confirmed** — a named reviewer independently checked the Japanese
  meaning/usage and the Ukrainian rendering, and filled the review metadata.
- **solid** — confirmed and release-ready within its declared profile: relevant
  examples and pronunciation data are reviewed, automated checks pass, and
  there are no open findings.

Only `confirmed` and `solid` entries may be presented as linguistically
approved. A successful `rake` run is a separate automated gate and never
upgrades maturity by itself.

Allowed progress normally follows:

`new → changes-requested → reviewed → confirmed → solid`

An entry with no findings may move directly from `new` to `reviewed`.

## Midway merge checkpoint

A midpoint merge is ready when:

- the full `rake` quality gate passes;
- every committed entry has one row in this ledger;
- every `changes-requested` row is either fixed or explicitly accepted as
  draft follow-up work in the PR;
- the PR describes `new` and `reviewed` entries as drafts, not as confirmed
  translations.

Draft entries can merge at the midpoint. Their maturity must remain visible so
later agents do not mistake volume for completed bilingual review.

## Open findings

- None open. Resolved on 2026-07-17 (editorial pass by `claude`):
  - `青い / あおい (1381390)`: sense 2 and sense 4 qualifiers corrected.
  - `上げる / あげる (1352320)`: senses 21–23 and 25 had misaligned/incorrect
    Ukrainian glosses (21 "increase of market price" glossed as *блювати*,
    22 "vomit" as *робити послугу*, 23 aux "for someone else" as *для себе*,
    25 humble aux as *вказує на крайній стан*); all corrected and sense 24
    completive gloss clarified.
  - `明後日 / あさって (1584640)`: sense 2 ("wrong (e.g. direction)") had no
    Ukrainian gloss; added *хибний* (idiomatic あさっての方を向く).
  - `足 / あし (1404630)`: sense 1 (足, foot) was glossed *нога* (leg) and
    sense 2 (脚, leg) was glossed *стопа* (foot) — foot/leg swapped; sense 4
    ("pace") was glossed *опора меблів* (furniture leg). Corrected sense 1 to
    *стопа* (+ *лапа*, *щупальце*), sense 2 to *нога*, sense 4 to *темп ходи*.
  - `熱い / あつい (1467720)`: sense 4 gloss *ентузіастичний* (non-standard
    calque for "enthusiastic") replaced with *запальний*.
  - `浴びる / あびる (1547450)`: sense 2 gloss *засипати похвалою* ("to shower
    someone with praise" — wrong valence; 浴びる is the receiver) replaced with
    *отримувати похвалу*.
  - `余り / あまり (1584930)`: example 1 UK translation *Отримати решту з решти*
    (redundant/unclear) reworded to *Отримати залишок решти*.
  Entries above are at `reviewed` and await independent bilingual confirmation.

## Maintenance rules

- Add a row in the same change that adds an entry. New entries start at
  `new`.
- Change maturity only when the corresponding gate above is satisfied.
- Record unresolved review findings in this file, not only in chat.
- Keep `ENTRY_STATUS` and Ukrainian gloss review properties authoritative for
  publication state; this ledger is the cross-entry planning view.
- Reconcile the counts and queue coverage before each merge checkpoint.

## Entry inventory

| Queue order | Entry | Reading | Romaji | JMdict ID | Profile | Entry state | Maturity | Next gate |
| ---: | --- | --- | --- | ---: | --- | --- | --- | --- |
| 1 | [会う](entries/1198/1198180-au.org) | あう | au | 1198180 | learner | draft | **reviewed** | Independent bilingual confirmation |
| 2 | [青](entries/1381/1381380-ao.org) | あお | ao | 1381380 | learner | draft | **reviewed** | Independent bilingual confirmation |
| 3 | [青い](entries/1381/1381390-aoi.org) | あおい | aoi | 1381390 | learner | draft | **reviewed** | Independent bilingual confirmation |
| 4 | [赤](entries/2013/2013900-aka.org) | あか | aka | 2013900 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 5 | [赤い](entries/1383/1383240-akai.org) | あかい | akai | 1383240 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 6 | [明るい](entries/1532/1532350-akarui.org) | あかるい | akarui | 1532350 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 7 | [秋](entries/1332/1332650-aki.org) | あき | aki | 1332650 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 8–10 | [開く](entries/1586/1586270-aku.org) | あく | aku | 1586270 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 11–12 | [開ける](entries/1202/1202450-akeru.org) | あける | akeru | 1202450 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 13 | [上げる](entries/1352/1352320-ageru.org) | あげる | ageru | 1352320 | learner | draft | **reviewed** | Independent bilingual confirmation |
| 14 | [朝](entries/1428/1428280-asa.org) | あさ | asa | 1428280 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 15 | [朝ご飯](entries/1586/1586330-asagohan.org) | あさごはん | asagohan | 1586330 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 16 | [明後日](entries/1584/1584640-asatte.org) | あさって | asatte | 1584640 | learner | draft | **reviewed** | Independent bilingual confirmation |
| 17 | [足](entries/1404/1404630-ashi.org) | あし | ashi | 1404630 | learner | draft | **reviewed** | Independent bilingual confirmation |
| 18 | [明日](entries/1584/1584660-ashita.org) | あした | ashita | 1584660 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 19 | [彼処](entries/1000/1000320-asoko.org) | あそこ | asoko | 1000320 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 20 | [遊ぶ](entries/1542/1542160-asobu.org) | あそぶ | asobu | 1542160 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 21–22 | [温かい](entries/1586/1586420-atatakai.org) | あたたかい | atatakai | 1586420 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 23 | [頭](entries/1582/1582310-atama.org) | あたま | atama | 1582310 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 24 | [新しい](entries/1361/1361490-atarashii.org) | あたらしい | atarashii | 1361490 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 25 | [彼方](entries/1483/1483185-achira.org) | あちら | achira | 1483185 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 26 | [暑い](entries/1343/1343460-atsui.org) | あつい | atsui | 1343460 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 27 | [熱い](entries/1467/1467720-atsui.org) | あつい | atsui | 1467720 | learner | draft | **reviewed** | Independent bilingual confirmation |
| 28 | [厚い](entries/1275/1275320-atsui.org) | あつい | atsui | 1275320 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 29 | [後](entries/1269/1269320-ato.org) | あと | ato | 1269320 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 30 | [貴方](entries/1223/1223615-anata.org) | あなた | anata | 1223615 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 31 | [兄](entries/1249/1249900-ani.org) | あに | ani | 1249900 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 32 | [姉](entries/1307/1307630-ane.org) | あね | ane | 1307630 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 33–34 | [彼の](entries/1000/1000420-ano.org) | あの | ano | 1000420 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 35 | [アパート](entries/1017/1017760-apaato.org) | アパート | apaato | 1017760 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 36 | [浴びる](entries/1547/1547450-abiru.org) | あびる | abiru | 1547450 | learner | draft | **reviewed** | Independent bilingual confirmation |
| 37 | [危ない](entries/1218/1218380-abunai.org) | あぶない | abunai | 1218380 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 38 | [甘い](entries/1213/1213400-amai.org) | あまい | amai | 1213400 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 39 | [余り](entries/1584/1584930-amari.org) | あまり | amari | 1584930 | learner | draft | **reviewed** | Independent bilingual confirmation |
| 40 | [雨](entries/1171/1171900-ame.org) | あめ | ame | 1171900 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 41 | [飴](entries/1153/1153520-ame.org) | あめ | ame | 1153520 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 42 | [洗う](entries/1390/1390930-arau.org) | あらう | arau | 1390930 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 43 | [有る](entries/1296/1296400-aru.org) | ある | aru | 1296400 | learner | draft | **new** | Editorial review |
| 44 | [歩く](entries/1514/1514320-aruku.org) | あるく | aruku | 1514320 | learner | draft | **new** | Editorial review |
| 45 | [彼](entries/1000/1000580-are.org) | あれ | are | 1000580 | learner | draft | **new** | Editorial review |
| 46 | [いいえ](entries/1583/1583250-iie.org) | いいえ | iie | 1583250 | learner | draft | **new** | Editorial review |
| 47 | [言う](entries/1587/1587040-iu.org) | いう | iu | 1587040 | learner | draft | **new** | Editorial review |
| 48 | [家](entries/1191/1191730-ie.org) | いえ | ie | 1191730 | learner | draft | **new** | Editorial review |
| 49 | [行く](entries/1578/1578850-iku.org) | いく | iku | 1578850 | learner | draft | **new** | Editorial review |
| 50 | [幾つ](entries/1219/1219960-ikutsu.org) | いくつ | ikutsu | 1219960 | learner | draft | **new** | Editorial review |
| 51 | [幾ら](entries/1219/1219980-ikura.org) | いくら | ikura | 1219980 | learner | draft | **new** | Editorial review |
| 52 | [池](entries/1421/1421700-ike.org) | いけ | ike | 1421700 | learner | draft | **new** | Editorial review |
| 53 | [医者](entries/1159/1159980-isha.org) | いしゃ | isha | 1159980 | learner | draft | **new** | Editorial review |
| 54 | [椅子](entries/1157/1157070-isu.org) | いす | isu | 1157070 | learner | draft | **new** | Editorial review |
| 55 | [忙しい](entries/1519/1519290-isogashii.org) | いそがしい | isogashii | 1519290 | learner | draft | **new** | Editorial review |
| 56 | [痛い](entries/1432/1432680-itai.org) | いたい | itai | 1432680 | learner | draft | **new** | Editorial review |
| 57 | [一](entries/1160/1160790-ichi.org) | いち | ichi | 1160790 | learner | draft | **new** | Editorial review |
| 58 | [一日](entries/1576/1576260-ichinichi.org) | いちにち | ichinichi | 1576260 | learner | draft | **new** | Editorial review |
| 59 | [一番](entries/1165/1165970-ichiban.org) | いちばん | ichiban | 1165970 | learner | draft | **new** | Editorial review |
| 60 | [一緒](entries/1163/1163400-issho.org) | いっしょ | issho | 1163400 | learner | draft | **new** | Editorial review |
| 61 | [何時](entries/1188/1188760-itsu.org) | いつ | itsu | 1188760 | learner | draft | **new** | Editorial review |
| 62 | [５日](entries/1268/1268570-itsuka.org) | いつか | itsuka | 1268570 | learner | draft | **new** | Editorial review |
| 63 | [五つ](entries/1268/1268070-itsutsu.org) | いつつ | itsutsu | 1268070 | learner | draft | **new** | Editorial review |
| 64 | [何時も](entries/1188/1188890-itsumo.org) | いつも | itsumo | 1188890 | learner | draft | **new** | Editorial review |
| 65 | [犬](entries/1258/1258330-inu.org) | いぬ | inu | 1258330 | learner | draft | **new** | Editorial review |
| 66 | [今](entries/1288/1288850-ima.org) | いま | ima | 1288850 | learner | draft | **new** | Editorial review |
| 67 | [意味](entries/1156/1156800-imi.org) | いみ | imi | 1156800 | learner | draft | **new** | Editorial review |
| 68 | [妹](entries/1524/1524590-imouto.org) | いもうと | imouto | 1524590 | learner | draft | **new** | Editorial review |
| 69 | [嫌](entries/1587/1587610-iya.org) | いや | iya | 1587610 | learner | draft | **new** | Editorial review |
| 70 | [入り口](entries/1582/1582820-iriguchi.org) | いりぐち | iriguchi | 1582820 | learner | draft | **new** | Editorial review |
| 71 | [居る](entries/1577/1577980-iru.org) | いる | iru | 1577980 | learner | draft | **new** | Editorial review |
| 72 | [要る](entries/1546/1546640-iru.org) | いる | iru | 1546640 | learner | draft | **new** | Editorial review |
| 73 | [入れる](entries/1465/1465610-ireru.org) | いれる | ireru | 1465610 | learner | draft | **new** | Editorial review |
| 74 | [色](entries/1357/1357600-iro.org) | いろ | iro | 1357600 | learner | draft | **new** | Editorial review |
| 75 | [色々](entries/1587/1587850-iroiro.org) | いろいろ | iroiro | 1587850 | learner | draft | **new** | Editorial review |
| 76 | [上](entries/1352/1352130-ue.org) | うえ | ue | 1352130 | learner | draft | **new** | Editorial review |
| 77 | [後ろ](entries/1269/1269410-ushiro.org) | うしろ | ushiro | 1269410 | learner | draft | **new** | Editorial review |
| 78 | [薄い](entries/1475/1475480-usui.org) | うすい | usui | 1475480 | learner | draft | **new** | Editorial review |
| 79 | [歌](entries/1193/1193180-uta.org) | うた | uta | 1193180 | learner | draft | **new** | Editorial review |
| 80 | [歌う](entries/1588/1588120-utau.org) | うたう | utau | 1588120 | learner | draft | **new** | Editorial review |
| 81 | [生まれる](entries/1378/1378690-umareru.org) | うまれる | umareru | 1378690 | learner | draft | **new** | Editorial review |
| 82 | [海](entries/1201/1201190-umi.org) | うみ | umi | 1201190 | learner | draft | **new** | Editorial review |
| 83 | [売る](entries/1473/1473950-uru.org) | うる | uru | 1473950 | learner | draft | **new** | Editorial review |
| 84 | [煩い](entries/1481/1481920-urusai.org) | うるさい | urusai | 1481920 | learner | draft | **new** | Editorial review |
| 85 | [上着](entries/1580/1580340-uwagi.org) | うわぎ | uwagi | 1580340 | learner | draft | **new** | Editorial review |
| 86 | [絵](entries/1202/1202270-e.org) | え | e | 1202270 | learner | draft | **new** | Editorial review |
| 87 | [映画](entries/1173/1173720-eiga.org) | えいが | eiga | 1173720 | learner | draft | **new** | Editorial review |
| 88 | [映画館](entries/1173/1173750-eigakan.org) | えいがかん | eigakan | 1173750 | learner | draft | **new** | Editorial review |
| 89 | [英語](entries/1174/1174420-eigo.org) | えいご | eigo | 1174420 | learner | draft | **new** | Editorial review |
| 90 | [ええ](entries/1001/1001140-ee.org) | ええ | ee | 1001140 | learner | draft | **new** | Editorial review |
| 91 | [駅](entries/1175/1175140-eki.org) | えき | eki | 1175140 | learner | draft | **new** | Editorial review |
| 92 | [エレベーター](entries/1030/1030630-erebeetaa.org) | エレベーター | erebeetaa | 1030630 | learner | draft | **new** | Editorial review |
| 93 | [鉛筆](entries/1178/1178590-enpitsu.org) | えんぴつ | enpitsu | 1178590 | learner | draft | **new** | Editorial review |
| 94 | [美味しい](entries/1486/1486650-oishii.org) | おいしい | oishii | 1486650 | learner | draft | **new** | Editorial review |
| 95 | [多い](entries/1407/1407460-ooi.org) | おおい | ooi | 1407460 | learner | draft | **new** | Editorial review |
| 96 | [大きい](entries/1588/1588880-ookii.org) | おおきい | ookii | 1588880 | learner | draft | **new** | Editorial review |
| 97 | [大きな](entries/1412/1412890-ookina.org) | おおきな | ookina | 1412890 | learner | draft | **new** | Editorial review |
| 98 | [大勢](entries/1414/1414220-oozei.org) | おおぜい | oozei | 1414220 | learner | draft | **new** | Editorial review |
| 99 | [お母さん](entries/1002/1002650-okaasan.org) | おかあさん | okaasan | 1002650 | learner | draft | **new** | Editorial review |
| 100 | [お菓子](entries/1001/1001710-okashi.org) | おかし | okashi | 1001710 | learner | draft | **new** | Editorial review |
| 101 | [お金](entries/1001/1001820-okane.org) | おかね | okane | 1001820 | learner | draft | **new** | Editorial review |
| 102 | [起きる](entries/1223/1223640-okiru.org) | おきる | okiru | 1223640 | learner | draft | **new** | Editorial review |
| 103 | [置く](entries/1421/1421850-oku.org) | おく | oku | 1421850 | learner | draft | **new** | Editorial review |
| 104 | [奥さん](entries/1179/1179330-okusan.org) | おくさん | okusan | 1179330 | learner | draft | **new** | Editorial review |
| 105 | [お酒](entries/1329/1329015-osake.org) | おさけ | osake | 1329015 | learner | draft | **new** | Editorial review |
| 106 | [お皿](entries/1299/1299685-osara.org) | おさら | osara | 1299685 | learner | draft | **new** | Editorial review |
| 107 | [教える](entries/1236/1236900-oshieru.org) | おしえる | oshieru | 1236900 | learner | draft | **new** | Editorial review |
| 108 | [押す](entries/1180/1180470-osu.org) | おす | osu | 1180470 | learner | draft | **new** | Editorial review |
| 109 | [遅い](entries/1421/1421970-osoi.org) | おそい | osoi | 1421970 | learner | draft | **new** | Editorial review |
| 110 | [お茶](entries/1002/1002430-ocha.org) | おちゃ | ocha | 1002430 | learner | draft | **new** | Editorial review |
| 111 | [お手洗い](entries/1002/1002100-otearai.org) | おてあらい | otearai | 1002100 | learner | draft | **new** | Editorial review |
| 112 | [お父さん](entries/1002/1002590-otousan.org) | おとうさん | otousan | 1002590 | learner | draft | **new** | Editorial review |
| 113 | [弟](entries/1581/1581930-otouto.org) | おとうと | otouto | 1581930 | learner | draft | **new** | Editorial review |
| 114 | [男](entries/1419/1419990-otoko.org) | おとこ | otoko | 1419990 | learner | draft | **new** | Editorial review |
| 115 | [男の子](entries/1420/1420010-otokonoko.org) | おとこのこ | otokonoko | 1420010 | learner | draft | **new** | Editorial review |
| 116 | [一昨日](entries/1576/1576050-ototoi.org) | おととい | ototoi | 1576050 | learner | draft | **new** | Editorial review |
| 117 | [一昨年](entries/1576/1576060-ototoshi.org) | おととし | ototoshi | 1576060 | learner | draft | **new** | Editorial review |
| 118 | [大人](entries/1414/1414170-otona.org) | おとな | otona | 1414170 | learner | draft | **new** | Editorial review |
| 119 | [お腹](entries/1002/1002610-onaka.org) | おなか | onaka | 1002610 | learner | draft | **new** | Editorial review |
| 120 | [同じ](entries/1451/1451750-onaji.org) | おなじ | onaji | 1451750 | learner | draft | **new** | Editorial review |
| 121 | [お兄さん](entries/1001/1001830-oniisan.org) | おにいさん | oniisan | 1001830 | learner | draft | **new** | Editorial review |
| 122 | [お姉さん](entries/1001/1001990-oneesan.org) | おねえさん | oneesan | 1001990 | learner | draft | **new** | Editorial review |
| 123 | [お祖母さん](entries/1002/1002330-obaasan.org) | おばあさん | obaasan | 1002330 | learner | draft | **new** | Editorial review |
| 124 | [伯母さん](entries/2261/2261500-obasan.org) | おばさん | obasan | 2261500 | learner | draft | **new** | Editorial review |
| 125 | [お風呂](entries/2220/2220600-ofuro.org) | おふろ | ofuro | 2220600 | learner | draft | **new** | Editorial review |
| 126 | [お弁当](entries/1513/1513065-obentou.org) | おべんとう | obentou | 1513065 | learner | draft | **new** | Editorial review |
| 127 | [覚える](entries/1206/1206050-oboeru.org) | おぼえる | oboeru | 1206050 | learner | draft | **new** | Editorial review |
| 128 | [お巡りさん](entries/1002/1002120-omawarisan.org) | おまわりさん | omawarisan | 1002120 | learner | draft | **new** | Editorial review |
| 129 | [重い](entries/1335/1335750-omoi.org) | おもい | omoi | 1335750 | learner | draft | **new** | Editorial review |
| 130 | [思う](entries/1589/1589350-omou.org) | おもう | omou | 1589350 | learner | draft | **new** | Editorial review |
| 131 | [面白い](entries/1533/1533580-omoshiroi.org) | おもしろい | omoshiroi | 1533580 | learner | draft | **new** | Editorial review |
| 132 | [泳ぐ](entries/1174/1174340-oyogu.org) | およぐ | oyogu | 1174340 | learner | draft | **new** | Editorial review |
| 133–134 | [下りる](entries/1589/1589500-oriru.org) | おりる | oriru | 1589500 | learner | draft | **new** | Editorial review |
| 135 | [終わる](entries/1589/1589600-owaru.org) | おわる | owaru | 1589600 | learner | draft | **new** | Editorial review |
| 136 | [音楽](entries/1183/1183720-ongaku.org) | おんがく | ongaku | 1183720 | learner | draft | **new** | Editorial review |
| 137 | [女](entries/1344/1344930-onna.org) | おんな | onna | 1344930 | learner | draft | **new** | Editorial review |
| 138 | [女の子](entries/1344/1344970-onnanoko.org) | おんなのこ | onnanoko | 1344970 | learner | draft | **new** | Editorial review |
| 139 | [会社](entries/1198/1198550-kaisha.org) | かいしゃ | kaisha | 1198550 | learner | draft | **new** | Editorial review |
| 140 | [階段](entries/1203/1203090-kaidan.org) | かいだん | kaidan | 1203090 | learner | draft | **new** | Editorial review |
| 141 | [買い物](entries/1589/1589730-kaimono.org) | かいもの | kaimono | 1589730 | learner | draft | **new** | Editorial review |
| 142 | [買う](entries/1473/1473740-kau.org) | かう | kau | 1473740 | learner | draft | **new** | Editorial review |
| 143 | [返す](entries/1512/1512130-kaesu.org) | かえす | kaesu | 1512130 | learner | draft | **new** | Editorial review |
| 144 | [帰る](entries/1221/1221270-kaeru.org) | かえる | kaeru | 1221270 | learner | draft | **new** | Editorial review |
| 145 | [掛かる](entries/1207/1207590-kakaru.org) | かかる | kakaru | 1207590 | learner | draft | **new** | Editorial review |
| 146 | [鍵](entries/1260/1260490-kagi.org) | かぎ | kagi | 1260490 | learner | draft | **new** | Editorial review |
| 147 | [書く](entries/1343/1343950-kaku.org) | かく | kaku | 1343950 | learner | draft | **new** | Editorial review |
| 148 | [掛ける](entries/1207/1207610-kakeru.org) | かける | kakeru | 1207610 | learner | draft | **new** | Editorial review |
| 149 | [傘](entries/1301/1301940-kasa.org) | かさ | kasa | 1301940 | learner | draft | **new** | Editorial review |
| 150 | [貸す](entries/1411/1411160-kasu.org) | かす | kasu | 1411160 | learner | draft | **new** | Editorial review |
| 151 | [風](entries/1499/1499720-kaze.org) | かぜ | kaze | 1499720 | learner | draft | **new** | Editorial review |
| 152 | [風邪](entries/1583/1583720-kaze.org) | かぜ | kaze | 1583720 | learner | draft | **new** | Editorial review |
| 153 | [家族](entries/1192/1192150-kazoku.org) | かぞく | kazoku | 1192150 | learner | draft | **new** | Editorial review |
| 154 | [方](entries/1516/1516925-kata.org) | かた | kata | 1516925 | learner | draft | **new** | Editorial review |
| 155 | [カップ](entries/1037/1037670-kappu.org) | カップ | kappu | 1037670 | learner | draft | **new** | Editorial review |
| 156 | [家庭](entries/1192/1192280-katei.org) | かてい | katei | 1192280 | learner | draft | **new** | Editorial review |
| 157 | [角](entries/1206/1206110-kado.org) | かど | kado | 1206110 | learner | draft | **new** | Editorial review |
| 158 | [鞄](entries/1208/1208910-kaban.org) | かばん | kaban | 1208910 | learner | draft | **new** | Editorial review |
| 159 | [花瓶](entries/1194/1194870-kabin.org) | かびん | kabin | 1194870 | learner | draft | **new** | Editorial review |
| 160 | [紙](entries/1311/1311530-kami.org) | かみ | kami | 1311530 | learner | draft | **new** | Editorial review |
| 161 | [カメラ](entries/1038/1038350-kamera.org) | カメラ | kamera | 1038350 | learner | draft | **new** | Editorial review |
| 162 | [火曜日](entries/1194/1194290-kayoubi.org) | かようび | kayoubi | 1194290 | learner | draft | **new** | Editorial review |
| 163 | [辛い](entries/1365/1365850-karai.org) | からい | karai | 1365850 | learner | draft | **new** | Editorial review |
| 164 | [体](entries/1409/1409140-karada.org) | からだ | karada | 1409140 | learner | draft | **new** | Editorial review |
| 165 | [借りる](entries/1323/1323560-kariru.org) | かりる | kariru | 1323560 | learner | draft | **new** | Editorial review |
| 166 | [軽い](entries/1252/1252560-karui.org) | かるい | karui | 1252560 | learner | draft | **new** | Editorial review |
| 167 | [カレンダー](entries/1039/1039220-karendaa.org) | カレンダー | karendaa | 1039220 | learner | draft | **new** | Editorial review |
| 168 | [カレー](entries/1039/1039140-karee.org) | カレー | karee | 1039140 | learner | draft | **new** | Editorial review |
| 169 | [川](entries/1390/1390020-kawa.org) | かわ | kawa | 1390020 | learner | draft | **new** | Editorial review |
| 170 | [可愛い](entries/1577/1577200-kawaii.org) | かわいい | kawaii | 1577200 | learner | draft | **new** | Editorial review |
| 171 | [漢字](entries/1213/1213170-kanji.org) | かんじ | kanji | 1213170 | learner | draft | **new** | Editorial review |
| 172 | [外国](entries/1203/1203620-gaikoku.org) | がいこく | gaikoku | 1203620 | learner | draft | **new** | Editorial review |
| 173 | [外国人](entries/1203/1203650-gaikokujin.org) | がいこくじん | gaikokujin | 1203650 | learner | draft | **new** | Editorial review |
| 174 | [学生](entries/1206/1206900-gakusei.org) | がくせい | gakusei | 1206900 | learner | draft | **new** | Editorial review |
| 175 | [学校](entries/1206/1206730-gakkou.org) | がっこう | gakkou | 1206730 | learner | draft | **new** | Editorial review |
| 176 | [木](entries/1534/1534520-ki.org) | き | ki | 1534520 | learner | draft | **new** | Editorial review |
| 177 | [黄色](entries/1576/1576760-kiiro.org) | きいろ | kiiro | 1576760 | learner | draft | **new** | Editorial review |
| 178 | [黄色い](entries/1182/1182030-kiiroi.org) | きいろい | kiiroi | 1182030 | learner | draft | **new** | Editorial review |
| 179 | [消える](entries/1350/1350040-kieru.org) | きえる | kieru | 1350040 | learner | draft | **new** | Editorial review |
| 180–181 | [聞く](entries/1591/1591110-kiku.org) | きく | kiku | 1591110 | learner | draft | **new** | Editorial review |
| 182 | [北](entries/1520/1520670-kita.org) | きた | kita | 1520670 | learner | draft | **new** | Editorial review |
| 183 | [汚い](entries/1178/1178940-kitanai.org) | きたない | kitanai | 1178940 | learner | draft | **new** | Editorial review |
| 184 | [喫茶店](entries/1226/1226440-kissaten.org) | きっさてん | kissaten | 1226440 | learner | draft | **new** | Editorial review |
| 185 | [切手](entries/1385/1385070-kitte.org) | きって | kitte | 1385070 | learner | draft | **new** | Editorial review |
| 186 | [切符](entries/1385/1385170-kippu.org) | きっぷ | kippu | 1385170 | learner | draft | **new** | Editorial review |
| 187 | [昨日](entries/1579/1579260-kinou.org) | きのう | kinou | 1579260 | learner | draft | **new** | Editorial review |
| 188, 249 | [今日](entries/1579/1579110-kyou.org) | きょう | kyou | 1579110 | learner | draft | **new** | Editorial review |
| 189 | [教室](entries/1237/1237150-kyoushitsu.org) | きょうしつ | kyoushitsu | 1237150 | learner | draft | **new** | Editorial review |
| 190 | [兄弟](entries/1249/1249960-kyoudai.org) | きょうだい | kyoudai | 1249960 | learner | draft | **new** | Editorial review |
| 191 | [去年](entries/1231/1231690-kyonen.org) | きょねん | kyonen | 1231690 | learner | draft | **new** | Editorial review |
| 192 | [嫌い](entries/1257/1257240-kirai.org) | きらい | kirai | 1257240 | learner | draft | **new** | Editorial review |
| 193 | [切る](entries/1384/1384830-kiru.org) | きる | kiru | 1384830 | learner | draft | **new** | Editorial review |
| 194 | [着る](entries/1423/1423000-kiru.org) | きる | kiru | 1423000 | learner | draft | **new** | Editorial review |
| 195 | [綺麗](entries/1591/1591900-kirei.org) | きれい | kirei | 1591900 | learner | draft | **new** | Editorial review |
| 196 | [キロ](entries/1042/1042610-kiro.org) | キロ | kiro | 1042610 | learner | draft | **new** | Editorial review |
| 197 | [瓩](entries/1042/1042620-kiroguramu.org) | キログラム | kiroguramu | 1042620 | learner | draft | **new** | Editorial review |
| 198 | [粁](entries/1042/1042650-kiromeetoru.org) | キロメートル | kiromeetoru | 1042650 | learner | draft | **new** | Editorial review |
| 199 | [金曜日](entries/1243/1243320-kinyoubi.org) | きんようび | kinyoubi | 1243320 | learner | draft | **new** | Editorial review |
| 200 | [ギター](entries/1042/1042820-gitaa.org) | ギター | gitaa | 1042820 | learner | draft | **new** | Editorial review |
| 201 | [牛肉](entries/1231/1231580-gyuuniku.org) | ぎゅうにく | gyuuniku | 1231580 | learner | draft | **new** | Editorial review |
| 202 | [牛乳](entries/1231/1231590-gyuunyuu.org) | ぎゅうにゅう | gyuunyuu | 1231590 | learner | draft | **new** | Editorial review |
| 203 | [銀行](entries/1243/1243490-ginkou.org) | ぎんこう | ginkou | 1243490 | learner | draft | **new** | Editorial review |
| 204 | [薬](entries/1538/1538160-kusuri.org) | くすり | kusuri | 1538160 | learner | draft | **new** | Editorial review |
| 205 | [下さい](entries/1184/1184270-kudasai.org) | ください | kudasai | 1184270 | learner | draft | **new** | Editorial review |
| 206 | [果物](entries/1193/1193060-kudamono.org) | くだもの | kudamono | 1193060 | learner | draft | **new** | Editorial review |
| 207 | [口](entries/1275/1275640-kuchi.org) | くち | kuchi | 1275640 | learner | draft | **new** | Editorial review |
| 208 | [靴](entries/1246/1246700-kutsu.org) | くつ | kutsu | 1246700 | learner | draft | **new** | Editorial review |
| 209 | [靴下](entries/1246/1246740-kutsushita.org) | くつした | kutsushita | 1246740 | learner | draft | **new** | Editorial review |
| 210 | [国](entries/1592/1592250-kuni.org) | くに | kuni | 1592250 | learner | draft | **new** | Editorial review |
| 211 | [曇り](entries/1592/1592340-kumori.org) | くもり | kumori | 1592340 | learner | draft | **new** | Editorial review |
| 212 | [曇る](entries/1457/1457560-kumoru.org) | くもる | kumoru | 1457560 | learner | draft | **new** | Editorial review |
| 213 | [暗い](entries/1154/1154330-kurai.org) | くらい | kurai | 1154330 | learner | draft | **new** | Editorial review |
| 214 | [クラス](entries/1044/1044070-kurasu.org) | クラス | kurasu | 1044070 | learner | draft | **new** | Editorial review |
| 215 | [来る](entries/1547/1547720-kuru.org) | くる | kuru | 1547720 | learner | draft | **new** | Editorial review |
| 216 | [車](entries/1323/1323080-kuruma.org) | くるま | kuruma | 1323080 | learner | draft | **new** | Editorial review |
| 217 | [黒](entries/1287/1287410-kuro.org) | くろ | kuro | 1287410 | learner | draft | **new** | Editorial review |
| 218 | [黒い](entries/1287/1287420-kuroi.org) | くろい | kuroi | 1287420 | learner | draft | **new** | Editorial review |
| 219 | [瓦](entries/1046/1046810-guramu.org) | グラム | guramu | 1046810 | learner | draft | **new** | Editorial review |
| 220 | [警官](entries/1252/1252330-keikan.org) | けいかん | keikan | 1252330 | learner | draft | **new** | Editorial review |
| 221 | [今朝](entries/1579/1579100-kesa.org) | けさ | kesa | 1579100 | learner | draft | **new** | Editorial review |
| 222 | [消す](entries/1350/1350110-kesu.org) | けす | kesu | 1350110 | learner | draft | **new** | Editorial review |
| 223 | [結構](entries/1254/1254760-kekkou.org) | けっこう | kekkou | 1254760 | learner | draft | **new** | Editorial review |
| 224 | [結婚](entries/1254/1254790-kekkon.org) | けっこん | kekkon | 1254790 | learner | draft | **new** | Editorial review |
| 225 | [月曜日](entries/1255/1255890-getsuyoubi.org) | げつようび | getsuyoubi | 1255890 | learner | draft | **new** | Editorial review |
| 226 | [玄関](entries/1263/1263400-genkan.org) | げんかん | genkan | 1263400 | learner | draft | **new** | Editorial review |
| 227 | [元気](entries/1260/1260720-genki.org) | げんき | genki | 1260720 | learner | draft | **new** | Editorial review |
| 228 | [公園](entries/1273/1273270-kouen.org) | こうえん | kouen | 1273270 | learner | draft | **new** | Editorial review |
| 229 | [交差点](entries/1592/1592970-kousaten.org) | こうさてん | kousaten | 1592970 | learner | draft | **new** | Editorial review |
| 230 | [紅茶](entries/1280/1280770-koucha.org) | こうちゃ | koucha | 1280770 | learner | draft | **new** | Editorial review |
| 231 | [交番](entries/1272/1272500-kouban.org) | こうばん | kouban | 1272500 | learner | draft | **new** | Editorial review |
| 232 | [声](entries/1380/1380440-koe.org) | こえ | koe | 1380440 | learner | draft | **new** | Editorial review |
| 233 | [此処](entries/1288/1288810-koko.org) | ここ | koko | 1288810 | learner | draft | **new** | Editorial review |
| 234 | [９日](entries/1243/1243850-kokonoka.org) | ここのか | kokonoka | 1243850 | learner | draft | **new** | Editorial review |
| 235 | [九つ](entries/1243/1243600-kokonotsu.org) | ここのつ | kokonotsu | 1243600 | learner | draft | **new** | Editorial review |
| 236 | [答える](entries/1449/1449540-kotaeru.org) | こたえる | kotaeru | 1449540 | learner | draft | **new** | Editorial review |
| 237 | [此方](entries/1004/1004500-kochira.org) | こちら | kochira | 1004500 | learner | draft | **new** | Editorial review |
| 238 | [洋杯](entries/1050/1050390-koppu.org) | コップ | koppu | 1050390 | learner | draft | **new** | Editorial review |
| 239 | [今年](entries/1579/1579130-kotoshi.org) | ことし | kotoshi | 1579130 | learner | draft | **new** | Editorial review |
| 240 | [言葉](entries/1264/1264540-kotoba.org) | ことば | kotoba | 1264540 | learner | draft | **new** | Editorial review |
| 241 | [子供](entries/1307/1307850-kodomo.org) | こども | kodomo | 1307850 | learner | draft | **new** | Editorial review |
| 242 | [此の](entries/1582/1582920-kono.org) | この | kono | 1582920 | learner | draft | **new** | Editorial review |
| 243 | [コピー](entries/1050/1050590-kopii.org) | コピー | kopii | 1050590 | learner | draft | **new** | Editorial review |
| 244 | [困る](entries/1289/1289590-komaru.org) | こまる | komaru | 1289590 | learner | draft | **new** | Editorial review |
| 245 | [此れ](entries/1628/1628530-kore.org) | これ | kore | 1628530 | learner | draft | **new** | Editorial review |
| 246 | [今月](entries/1289/1289100-kongetsu.org) | こんげつ | kongetsu | 1289100 | learner | draft | **new** | Editorial review |
| 247 | [今週](entries/1289/1289220-konshuu.org) | こんしゅう | konshuu | 1289220 | learner | draft | **new** | Editorial review |
| 248 | [こんな](entries/1004/1004880-konna.org) | こんな | konna | 1004880 | learner | draft | **new** | Editorial review |
| 250 | [今晩](entries/1289/1289470-konban.org) | こんばん | konban | 1289470 | learner | draft | **new** | Editorial review |
| 251 | [コート](entries/1049/1049000-kooto.org) | コート | kooto | 1049000 | learner | draft | **new** | Editorial review |
| 252 | [珈琲](entries/1049/1049180-koohii.org) | コーヒー | koohii | 1049180 | learner | draft | **new** | Editorial review |
| 253 | [五](entries/1268/1268060-go.org) | ご | go | 1268060 | learner | draft | **new** | Editorial review |
| 254 | [午後](entries/1268/1268990-gogo.org) | ごご | gogo | 1268990 | learner | draft | **new** | Editorial review |
| 255 | [午前](entries/1269/1269060-gozen.org) | ごぜん | gozen | 1269060 | learner | draft | **new** | Editorial review |
| 256 | [ご飯](entries/1270/1270590-gohan.org) | ごはん | gohan | 1270590 | learner | draft | **new** | Editorial review |
| 257 | [さあ](entries/1005/1005110-saa.org) | さあ | saa | 1005110 | learner | draft | **new** | Editorial review |
| 258 | [財布](entries/1296/1296970-saifu.org) | さいふ | saifu | 1296970 | learner | draft | **new** | Editorial review |
| 259 | [魚](entries/1578/1578010-sakana.org) | さかな | sakana | 1578010 | learner | draft | **new** | Editorial review |
| 260 | [先](entries/1387/1387210-saki.org) | さき | saki | 1387210 | learner | draft | **new** | Editorial review |
| 261 | [咲く](entries/1297/1297210-saku.org) | さく | saku | 1297210 | learner | draft | **new** | Editorial review |
| 262 | [作文](entries/1297/1297960-sakubun.org) | さくぶん | sakubun | 1297960 | learner | draft | **new** | Editorial review |
| 263 | [差す](entries/1291/1291330-sasu.org) | さす | sasu | 1291330 | learner | draft | **new** | Editorial review |
| 264 | [砂糖](entries/1291/1291600-satou.org) | さとう | satou | 1291600 | learner | draft | **new** | Editorial review |
| 265 | [寒い](entries/1210/1210360-samui.org) | さむい | samui | 1210360 | learner | draft | **new** | Editorial review |
| 266 | [再来年](entries/1293/1293660-sarainen.org) | さらいねん | sarainen | 1293660 | learner | draft | **new** | Editorial review |
| 267 | [三](entries/1579/1579350-san.org) | さん | san | 1579350 | learner | draft | **new** | Editorial review |
| 268 | [散歩](entries/1303/1303620-sanpo.org) | さんぽ | sanpo | 1303620 | learner | draft | **new** | Editorial review |
| 269 | [雑誌](entries/1299/1299400-zasshi.org) | ざっし | zasshi | 1299400 | learner | draft | **new** | Editorial review |
| 270 | [四](entries/1579/1579470-shi.org) | し | shi | 1579470 | learner | draft | **new** | Editorial review |
| 271 | [塩](entries/1576/1576630-shio.org) | しお | shio | 1576630 | learner | draft | **new** | Editorial review |
| 272 | [然し](entries/1505/1505990-shikashi.org) | しかし | shikashi | 1505990 | learner | draft | **new** | Editorial review |
| 273 | [仕事](entries/1304/1304970-shigoto.org) | しごと | shigoto | 1304970 | learner | draft | **new** | Editorial review |
| 274 | [静か](entries/1381/1381820-shizuka.org) | しずか | shizuka | 1381820 | learner | draft | **new** | Editorial review |
| 275 | [下](entries/1184/1184140-shita.org) | した | shita | 1184140 | learner | draft | **new** | Editorial review |
| 276 | [七](entries/1319/1319210-shichi.org) | しち | shichi | 1319210 | learner | draft | **new** | Editorial review |
| 277 | [質問](entries/1320/1320760-shitsumon.org) | しつもん | shitsumon | 1320760 | learner | draft | **new** | Editorial review |
| 278 | [死ぬ](entries/1310/1310730-shinu.org) | しぬ | shinu | 1310730 | learner | draft | **new** | Editorial review |
| 279 | [閉まる](entries/1436/1436560-shimaru.org) | しまる | shimaru | 1436560 | learner | draft | **new** | Editorial review |
| 280 | [締める](entries/1436/1436570-shimeru.org) | しめる | shimeru | 1436570 | learner | draft | **new** | Editorial review |
| 281 | [閉める](entries/1508/1508590-shimeru2.org) | しめる | shimeru2 | 1508590 | learner | draft | **new** | Editorial review |
| 282 | [写真](entries/1321/1321900-shashin.org) | しゃしん | shashin | 1321900 | learner | draft | **new** | Editorial review |
| 283 | [シャツ](entries/1061/1061520-shatsu.org) | シャツ | shatsu | 1061520 | learner | draft | **new** | Editorial review |
| 284 | [シャワー](entries/1061/1061820-shawaa.org) | シャワー | shawaa | 1061820 | learner | draft | **new** | Editorial review |
| 285 | [宿題](entries/1337/1337270-shukudai.org) | しゅくだい | shukudai | 1337270 | learner | draft | **new** | Editorial review |
| 286 | [醤油](entries/1595/1595020-shouyu.org) | しょうゆ | shouyu | 1595020 | learner | draft | **new** | Editorial review |
| 287 | [食堂](entries/1358/1358550-shokudou.org) | しょくどう | shokudou | 1358550 | learner | draft | **new** | Editorial review |
| 288 | [知る](entries/1420/1420470-shiru.org) | しる | shiru | 1420470 | learner | draft | **new** | Editorial review |
| 289 | [白](entries/1474/1474900-shiro.org) | しろ | shiro | 1474900 | learner | draft | **new** | Editorial review |
| 290 | [白い](entries/1474/1474910-shiroi.org) | しろい | shiroi | 1474910 | learner | draft | **new** | Editorial review |
| 291 | [新聞](entries/1362/1362360-shinbun.org) | しんぶん | shinbun | 1362360 | learner | draft | **new** | Editorial review |
| 292 | [時間](entries/1315/1315920-jikan.org) | じかん | jikan | 1315920 | learner | draft | **new** | Editorial review |
| 293 | [辞書](entries/1318/1318970-jisho.org) | じしょ | jisho | 1318970 | learner | draft | **new** | Editorial review |
| 294 | [自転車](entries/1318/1318290-jitensha.org) | じてんしゃ | jitensha | 1318290 | learner | draft | **new** | Editorial review |
| 295 | [自動車](entries/1318/1318400-jidousha.org) | じどうしゃ | jidousha | 1318400 | learner | draft | **new** | Editorial review |
| 296 | [字引](entries/1315/1315140-jibiki.org) | じびき | jibiki | 1315140 | learner | draft | **new** | Editorial review |
| 297 | [自分](entries/1318/1318610-jibun.org) | じぶん | jibun | 1318610 | learner | draft | **new** | Editorial review |
| 298 | [じゃあ](entries/1005/1005900-jaa.org) | じゃあ | jaa | 1005900 | learner | draft | **new** | Editorial review |
| 299 | [十](entries/1579/1579840-juu.org) | じゅう | juu | 1579840 | learner | draft | **new** | Editorial review |
| 300 | [授業](entries/1330/1330290-jugyou.org) | じゅぎょう | jugyou | 1330290 | learner | draft | **new** | Editorial review |
| 301 | [上手](entries/1353/1353320-jouzu.org) | じょうず | jouzu | 1353320 | learner | draft | **new** | Editorial review |
| 302 | [丈夫](entries/1580/1580480-joubu.org) | じょうぶ | joubu | 1580480 | learner | draft | **new** | Editorial review |
| 303 | [水曜日](entries/1372/1372190-suiyoubi.org) | すいようび | suiyoubi | 1372190 | learner | draft | **new** | Editorial review |
| 304 | [吸う](entries/1228/1228260-suu.org) | すう | suu | 1228260 | learner | draft | **new** | Editorial review |
| 305 | [スカート](entries/1067/1067470-sukaato.org) | スカート | sukaato | 1067470 | learner | draft | **new** | Editorial review |
| 306 | [好き](entries/1277/1277450-suki.org) | すき | suki | 1277450 | learner | draft | **new** | Editorial review |
| 307 | [少ない](entries/1348/1348910-sukunai.org) | すくない | sukunai | 1348910 | learner | draft | **new** | Editorial review |
| 308 | [直ぐに](entries/1430/1430620-suguni.org) | すぐに | suguni | 1430620 | learner | draft | **new** | Editorial review |
| 309 | [少し](entries/1348/1348870-sukoshi.org) | すこし | sukoshi | 1348870 | learner | draft | **new** | Editorial review |
| 310 | [涼しい](entries/1554/1554370-suzushii.org) | すずしい | suzushii | 1554370 | learner | draft | **new** | Editorial review |
| 311 | [ストーブ](entries/1070/1070790-sutoobu.org) | ストーブ | sutoobu | 1070790 | learner | draft | **new** | Editorial review |
| 312 | [スプーン](entries/1072/1072590-supuun.org) | スプーン | supuun | 1072590 | learner | draft | **new** | Editorial review |
| 313 | [スポーツ](entries/1073/1073210-supootsu.org) | スポーツ | supootsu | 1073210 | learner | draft | **new** | Editorial review |
| 314 | [住む](entries/1334/1334040-sumu.org) | すむ | sumu | 1334040 | learner | draft | **new** | Editorial review |
| 315 | [スリッパ](entries/1073/1073900-surippa.org) | スリッパ | surippa | 1073900 | learner | draft | **new** | Editorial review |
| 316 | [為る](entries/1157/1157170-suru.org) | する | suru | 1157170 | learner | draft | **new** | Editorial review |
| 317 | [座る](entries/1291/1291800-suwaru.org) | すわる | suwaru | 1291800 | learner | draft | **new** | Editorial review |
| 318 | [洋袴](entries/1074/1074260-zubon.org) | ズボン | zubon | 1074260 | learner | draft | **new** | Editorial review |
| 319 | [背](entries/2147/2147990-se.org) | せ | se | 2147990 | learner | draft | **new** | Editorial review |
| 320 | [生徒](entries/1379/1379380-seito.org) | せいと | seito | 1379380 | learner | draft | **new** | Editorial review |
| 321 | [石鹸](entries/1382/1382590-sekken.org) | せっけん | sekken | 1382590 | learner | draft | **new** | Editorial review |
| 322 | [背広](entries/1472/1472740-sebiro.org) | せびろ | sebiro | 1472740 | learner | draft | **new** | Editorial review |
| 323 | [狭い](entries/1237/1237680-semai.org) | せまい | semai | 1237680 | learner | draft | **new** | Editorial review |
| 324 | [千](entries/1388/1388740-sen.org) | せん | sen | 1388740 | learner | draft | **new** | Editorial review |
| 325 | [先月](entries/1387/1387500-sengetsu.org) | せんげつ | sengetsu | 1387500 | learner | draft | **new** | Editorial review |
| 326 | [先週](entries/1387/1387870-senshuu.org) | せんしゅう | senshuu | 1387870 | learner | draft | **new** | Editorial review |
| 327 | [先生](entries/1387/1387990-sensei.org) | せんせい | sensei | 1387990 | learner | draft | **new** | Editorial review |
| 328 | [洗濯](entries/1390/1390980-sentaku.org) | せんたく | sentaku | 1390980 | learner | draft | **new** | Editorial review |
| 329 | [セーター](entries/1074/1074270-seetaa.org) | セーター | seetaa | 1074270 | learner | draft | **new** | Editorial review |
| 330 | [全部](entries/1396/1396130-zenbu.org) | ぜんぶ | zenbu | 1396130 | learner | draft | **new** | Editorial review |
| 331 | [然うして](entries/1612/1612860-soushite.org) | そうして | soushite | 1612860 | learner | draft | **new** | Editorial review |
| 332 | [掃除](entries/1399/1399790-souji.org) | そうじ | souji | 1399790 | learner | draft | **new** | Editorial review |
| 333 | [其処](entries/1006/1006670-soko.org) | そこ | soko | 1006670 | learner | draft | **new** | Editorial review |
| 334 | [而して](entries/1006/1006730-soshite.org) | そして | soshite | 1006730 | learner | draft | **new** | Editorial review |
| 335 | [其方](entries/1006/1006780-sochira.org) | そちら | sochira | 1006780 | learner | draft | **new** | Editorial review |
| 336 | [外](entries/1203/1203250-soto.org) | そと | soto | 1203250 | learner | draft | **new** | Editorial review |
| 337 | [其の](entries/1006/1006830-sono.org) | その | sono | 1006830 | learner | draft | **new** | Editorial review |
| 338 | [側](entries/1403/1403830-soba.org) | そば | soba | 1403830 | learner | draft | **new** | Editorial review |
| 339 | [空](entries/1245/1245290-sora.org) | そら | sora | 1245290 | learner | draft | **new** | Editorial review |
| 340 | [其れ](entries/1006/1006970-sore.org) | それ | sore | 1006970 | learner | draft | **new** | Editorial review |
| 341 | [それから](entries/1006/1006980-sorekara.org) | それから | sorekara | 1006980 | learner | draft | **new** | Editorial review |
| 342 | [それでは](entries/1406/1406050-soredewa.org) | それでは | soredewa | 1406050 | learner | draft | **new** | Editorial review |
| 343 | [大使館](entries/1413/1413890-taishikan.org) | たいしかん | taishikan | 1413890 | learner | draft | **new** | Editorial review |
| 344 | [大切](entries/1414/1414340-taisetsu.org) | たいせつ | taisetsu | 1414340 | learner | draft | **new** | Editorial review |
| 345 | [大変](entries/1415/1415000-taihen.org) | たいへん | taihen | 1415000 | learner | draft | **new** | Editorial review |
| 346 | [高い](entries/1283/1283190-takai.org) | たかい | takai | 1283190 | learner | draft | **new** | Editorial review |
| 347 | [沢山](entries/1415/1415870-takusan.org) | たくさん | takusan | 1415870 | learner | draft | **new** | Editorial review |
| 348 | [タクシー](entries/1076/1076190-takushii.org) | タクシー | takushii | 1076190 | learner | draft | **new** | Editorial review |
| 349 | [立つ](entries/1597/1597040-tatsu.org) | たつ | tatsu | 1597040 | learner | draft | **new** | Editorial review |
| 350 | [縦](entries/1335/1335640-tate.org) | たて | tate | 1335640 | learner | draft | **new** | Editorial review |
| 351 | [建物](entries/1257/1257540-tatemono.org) | たてもの | tatemono | 1257540 | learner | draft | **new** | Editorial review |
| 352 | [楽しい](entries/1207/1207240-tanoshii.org) | たのしい | tanoshii | 1207240 | learner | draft | **new** | Editorial review |
| 353 | [頼む](entries/1548/1548370-tanomu.org) | たのむ | tanomu | 1548370 | learner | draft | **new** | Editorial review |
| 354 | [煙草](entries/1597/1597150-tabako.org) | タバコ | tabako | 1597150 | learner | draft | **new** | Editorial review |
| 355 | [多分](entries/1407/1407980-tabun.org) | たぶん | tabun | 1407980 | learner | draft | **new** | Editorial review |
| 356 | [食べ物](entries/1358/1358340-tabemono.org) | たべもの | tabemono | 1358340 | learner | draft | **new** | Editorial review |
| 357 | [食べる](entries/1358/1358280-taberu.org) | たべる | taberu | 1358280 | learner | draft | **new** | Editorial review |
| 358 | [卵](entries/1549/1549140-tamago.org) | たまご | tamago | 1549140 | learner | draft | **new** | Editorial review |
| 359 | [誕生日](entries/1419/1419110-tanjoubi.org) | たんじょうび | tanjoubi | 1419110 | learner | draft | **new** | Editorial review |
| 360 | [大学](entries/1413/1413240-daigaku.org) | だいがく | daigaku | 1413240 | learner | draft | **new** | Editorial review |
| 361 | [大丈夫](entries/1414/1414150-daijoubu.org) | だいじょうぶ | daijoubu | 1414150 | learner | draft | **new** | Editorial review |
| 362 | [大好き](entries/1413/1413660-daisuki.org) | だいすき | daisuki | 1413660 | learner | draft | **new** | Editorial review |
| 363 | [台所](entries/1412/1412640-daidokoro.org) | だいどころ | daidokoro | 1412640 | learner | draft | **new** | Editorial review |
| 364 | [出す](entries/1338/1338180-dasu.org) | だす | dasu | 1338180 | learner | draft | **new** | Editorial review |
| 365 | [誰](entries/1416/1416830-dare.org) | だれ | dare | 1416830 | learner | draft | **new** | Editorial review |
| 366 | [誰か](entries/1416/1416840-dareka.org) | だれか | dareka | 1416840 | learner | draft | **new** | Editorial review |
| 367 | [段々](entries/1597/1597350-dandan.org) | だんだん | dandan | 1597350 | learner | draft | **new** | Editorial review |
| 368 | [小さい](entries/1347/1347750-chiisai.org) | ちいさい | chiisai | 1347750 | learner | draft | **new** | Editorial review |
| 369 | [小さな](entries/2136/2136180-chiisana.org) | ちいさな | chiisana | 2136180 | learner | draft | **new** | Editorial review |
| 370 | [近い](entries/1242/1242130-chikai.org) | ちかい | chikai | 1242130 | learner | draft | **new** | Editorial review |
| 371 | [近く](entries/1242/1242160-chikaku.org) | ちかく | chikaku | 1242160 | learner | draft | **new** | Editorial review |
| 372 | [地下鉄](entries/1420/1420900-chikatetsu.org) | ちかてつ | chikatetsu | 1420900 | learner | draft | **new** | Editorial review |
| 373 | [違う](entries/1158/1158880-chigau.org) | ちがう | chigau | 1158880 | learner | draft | **new** | Editorial review |
| 374 | [地図](entries/1421/1421290-chizu.org) | ちず | chizu | 1421290 | learner | draft | **new** | Editorial review |
| 375 | [茶色](entries/1422/1422720-chairo.org) | ちゃいろ | chairo | 1422720 | learner | draft | **new** | Editorial review |
| 376 | [茶碗](entries/1597/1597530-chawan.org) | ちゃわん | chawan | 1597530 | learner | draft | **new** | Editorial review |
| 377 | [丁度](entries/1427/1427340-choudo.org) | ちょうど | choudo | 1427340 | learner | draft | **new** | Editorial review |
| 378 | [一寸](entries/1163/1163940-chotto.org) | ちょっと | chotto | 1163940 | learner | draft | **new** | Editorial review |
| 379 | [１日](entries/2225/2225040-tsuitachi.org) | ついたち | tsuitachi | 2225040 | learner | draft | **new** | Editorial review |
| 380 | [使う](entries/1305/1305990-tsukau.org) | つかう | tsukau | 1305990 | learner | draft | **new** | Editorial review |
| 381 | [疲れる](entries/1483/1483740-tsukareru.org) | つかれる | tsukareru | 1483740 | learner | draft | **new** | Editorial review |
| 382 | [次](entries/1316/1316380-tsugi.org) | つぎ | tsugi | 1316380 | learner | draft | **new** | Editorial review |
| 383 | [着く](entries/1422/1422970-tsuku.org) | つく | tsuku | 1422970 | learner | draft | **new** | Editorial review |
| 384 | [机](entries/1220/1220210-tsukue.org) | つくえ | tsukue | 1220210 | learner | draft | **new** | Editorial review |
| 385 | [作る](entries/1597/1597890-tsukuru.org) | つくる | tsukuru | 1597890 | learner | draft | **new** | Editorial review |
| 386 | [付ける](entries/1495/1495770-tsukeru.org) | つける | tsukeru | 1495770 | learner | draft | **new** | Editorial review |
| 387 | [勤める](entries/1240/1240825-tsutomeru.org) | つとめる | tsutomeru | 1240825 | learner | draft | **new** | Editorial review |
| 388 | [詰らない](entries/1008/1008190-tsumaranai.org) | つまらない | tsumaranai | 1008190 | learner | draft | **new** | Editorial review |
| 389 | [冷たい](entries/1556/1556730-tsumetai.org) | つめたい | tsumetai | 1556730 | learner | draft | **new** | Editorial review |
| 390 | [強い](entries/1236/1236070-tsuyoi.org) | つよい | tsuyoi | 1236070 | learner | draft | **new** | Editorial review |
| 391 | [手](entries/1327/1327190-te.org) | て | te | 1327190 | learner | draft | **new** | Editorial review |
| 392 | [手紙](entries/1327/1327720-tegami.org) | てがみ | tegami | 1327720 | learner | draft | **new** | Editorial review |
| 393 | [テスト](entries/1079/1079760-tesuto.org) | テスト | tesuto | 1079760 | learner | draft | **new** | Editorial review |
| 394 | [テレビ](entries/1080/1080510-terebi.org) | テレビ | terebi | 1080510 | learner | draft | **new** | Editorial review |
| 395 | [天気](entries/1438/1438690-tenki.org) | てんき | tenki | 1438690 | learner | draft | **new** | Editorial review |
| 396 | [テーブル](entries/1078/1078630-teeburu.org) | テーブル | teeburu | 1078630 | learner | draft | **new** | Editorial review |
| 397 | [テープ](entries/1078/1078750-teepu.org) | テープ | teepu | 1078750 | learner | draft | **new** | Editorial review |
| 398 | [テープレコーダー](entries/1078/1078810-teepurekoodaa.org) | テープレコーダー | teepurekoodaa | 1078810 | learner | draft | **new** | Editorial review |
| 399 | [出かける](entries/1598/1598550-dekakeru.org) | でかける | dekakeru | 1598550 | learner | draft | **new** | Editorial review |
| 400 | [出来る](entries/1340/1340450-dekiru.org) | できる | dekiru | 1340450 | learner | draft | **new** | Editorial review |
| 401 | [出口](entries/1338/1338850-deguchi.org) | でぐち | deguchi | 1338850 | learner | draft | **new** | Editorial review |
| 402 | [では](entries/1008/1008450-dewa.org) | では | dewa | 1008450 | learner | draft | **new** | Editorial review |
| 403 | [デパート](entries/1083/1083590-depaato.org) | デパート | depaato | 1083590 | learner | draft | **new** | Editorial review |
| 404 | [でも](entries/1008/1008460-demo.org) | でも | demo | 1008460 | learner | draft | **new** | Editorial review |
| 405 | [出る](entries/1338/1338240-deru.org) | でる | deru | 1338240 | learner | draft | **new** | Editorial review |
| 406 | [電気](entries/1443/1443000-denki.org) | でんき | denki | 1443000 | learner | draft | **new** | Editorial review |
| 407 | [電車](entries/1443/1443530-densha.org) | でんしゃ | densha | 1443530 | learner | draft | **new** | Editorial review |
| 408 | [電話](entries/1443/1443840-denwa.org) | でんわ | denwa | 1443840 | learner | draft | **new** | Editorial review |
| 409 | [戸](entries/1266/1266970-to.org) | と | to | 1266970 | learner | draft | **new** | Editorial review |
| 410 | [トイレ](entries/1084/1084810-toire.org) | トイレ | toire | 1084810 | learner | draft | **new** | Editorial review |
| 411 | [遠い](entries/1177/1177800-tooi.org) | とおい | tooi | 1177800 | learner | draft | **new** | Editorial review |
| 412 | [１０日](entries/1335/1335000-tooka.org) | とおか | tooka | 1335000 | learner | draft | **new** | Editorial review |
| 413 | [時々](entries/1598/1598680-tokidoki.org) | ときどき | tokidoki | 1598680 | learner | draft | **new** | Editorial review |
| 414 | [時計](entries/1316/1316140-tokei.org) | とけい | tokei | 1316140 | learner | draft | **new** | Editorial review |
| 415 | [所](entries/1343/1343100-tokoro.org) | ところ | tokoro | 1343100 | learner | draft | **new** | Editorial review |
| 416 | [年](entries/1468/1468060-toshi.org) | とし | toshi | 1468060 | learner | draft | **new** | Editorial review |
| 417 | [図書館](entries/1370/1370420-toshokan.org) | としょかん | toshokan | 1370420 | learner | draft | **new** | Editorial review |
| 418 | [迚も](entries/1008/1008630-totemo.org) | とても | totemo | 1008630 | learner | draft | **new** | Editorial review |
| 419 | [隣](entries/1555/1555830-tonari.org) | となり | tonari | 1555830 | learner | draft | **new** | Editorial review |
| 420 | [飛ぶ](entries/1429/1429700-tobu.org) | とぶ | tobu | 1429700 | learner | draft | **new** | Editorial review |
| 421 | [止まる](entries/1310/1310620-tomaru.org) | とまる | tomaru | 1310620 | learner | draft | **new** | Editorial review |
| 422 | [友達](entries/1540/1540170-tomodachi.org) | ともだち | tomodachi | 1540170 | learner | draft | **new** | Editorial review |
| 423 | [鳥](entries/1430/1430250-tori.org) | とり | tori | 1430250 | learner | draft | **new** | Editorial review |
| 424 | [取る](entries/1326/1326980-toru.org) | とる | toru | 1326980 | learner | draft | **new** | Editorial review |
| 425 | [撮る](entries/1298/1298790-toru.org) | とる | toru | 1298790 | learner | draft | **new** | Editorial review |
| 426 | [ドア](entries/1087/1087820-doa.org) | ドア | doa | 1087820 | learner | draft | **new** | Editorial review |
| 427 | [如何](entries/1008/1008910-doo.org) | どう | doo | 1008910 | learner | draft | **new** | Editorial review |
| 428 | [如何して](entries/1466/1466940-dōshite.org) | どうして | dōshite | 1466940 | learner | draft | **new** | Editorial review |
| 429 | [どうぞ](entries/1189/1189130-dōzo.org) | どうぞ | dōzo | 1189130 | learner | draft | **new** | Editorial review |
| 430 | [動物](entries/1451/1451470-dōbutsu.org) | どうぶつ | dōbutsu | 1451470 | learner | draft | **new** | Editorial review |
| 431 | [どうも](entries/1009/1009000-doomo.org) | どうも | doomo | 1009000 | learner | draft | **new** | Editorial review |
| 432 | [何処](entries/1577/1577140-doko.org) | どこ | doko | 1577140 | learner | draft | **new** | Editorial review |
| 433 | [何方](entries/1189/1189360-dochira.org) | どちら | dochira | 1189360 | learner | draft | **new** | Editorial review |
| 434 | [何方](entries/1189/1189370-donata.org) | どなた | donata | 1189370 | learner | draft | **new** | Editorial review |
| 435 | [何の](entries/1920/1920240-dono.org) | どの | dono | 1920240 | learner | draft | **new** | Editorial review |
| 436 | [土曜日](entries/1445/1445590-doyōbi.org) | どようび | doyōbi | 1445590 | learner | draft | **new** | Editorial review |
| 437 | [何れ](entries/1009/1009290-dore.org) | どれ | dore | 1009290 | learner | draft | **new** | Editorial review |
| 438 | [ナイフ](entries/1089/1089890-naifu.org) | ナイフ | naifu | 1089890 | learner | draft | **new** | Editorial review |
| 439 | [中](entries/1423/1423310-naka.org) | なか | naka | 1423310 | learner | draft | **new** | Editorial review |
| 440 | [長い](entries/1429/1429750-nagai.org) | ながい | nagai | 1429750 | learner | draft | **new** | Editorial review |
| 441 | [鳴く](entries/1532/1532870-naku.org) | なく | naku | 1532870 | learner | draft | **new** | Editorial review |
| 442 | [無くす](entries/1529/1529530-nakusu.org) | なくす | nakusu | 1529530 | learner | draft | **new** | Editorial review |
| 443 | [何故](entries/1577/1577120-naze.org) | なぜ | naze | 1577120 | learner | draft | **new** | Editorial review |
| 444 | [夏](entries/1191/1191320-natsu.org) | なつ | natsu | 1191320 | learner | draft | **new** | Editorial review |
| 445 | [夏休み](entries/1191/1191420-natsuyasumi.org) | なつやすみ | natsuyasumi | 1191420 | learner | draft | **new** | Editorial review |
| 446 | [等](entries/1582/1582300-nado.org) | など | nado | 1582300 | learner | draft | **new** | Editorial review |
| 447 | [七つ](entries/1319/1319220-nanatsu.org) | ななつ | nanatsu | 1319220 | learner | draft | **new** | Editorial review |
| 448 | [何](entries/1577/1577100-nani.org) | なに | nani | 1577100 | learner | draft | **new** | Editorial review |
| 449 | [７日](entries/1579/1579630-nanoka.org) | なのか | nanoka | 1579630 | learner | draft | **new** | Editorial review |
| 450 | [名前](entries/1531/1531710-namae.org) | なまえ | namae | 1531710 | learner | draft | **new** | Editorial review |
| 451 | [習う](entries/1333/1333070-narau.org) | ならう | narau | 1333070 | learner | draft | **new** | Editorial review |
| 452 | [並ぶ](entries/1508/1508380-narabu.org) | ならぶ | narabu | 1508380 | learner | draft | **new** | Editorial review |
| 453 | [並べる](entries/1508/1508390-naraberu.org) | ならべる | naraberu | 1508390 | learner | draft | **new** | Editorial review |
| 454 | [成る](entries/1375/1375610-naru.org) | なる | naru | 1375610 | learner | draft | **new** | Editorial review |
| 455 | [二](entries/1461/1461140-ni.org) | に | ni | 1461140 | learner | draft | **new** | Editorial review |
| 456 | [賑やか](entries/1463/1463480-nigiyaka.org) | にぎやか | nigiyaka | 1463480 | learner | draft | **new** | Editorial review |
| 457 | [肉](entries/1463/1463520-niku.org) | にく | niku | 1463520 | learner | draft | **new** | Editorial review |
| 458 | [西](entries/1380/1380840-nishi.org) | にし | nishi | 1380840 | learner | draft | **new** | Editorial review |
| 459, 486 | [２０歳](entries/1600/1600790-hatachi.org) | はたち / にじゅうさい | hatachi | 1600790 | learner | draft | **new** | Editorial review |
| 460 | [日曜日](entries/1464/1464900-nichiyoubi.org) | にちようび | nichiyoubi | 1464900 | learner | draft | **new** | Editorial review |
| 461 | [荷物](entries/1195/1195430-nimotsu.org) | にもつ | nimotsu | 1195430 | learner | draft | **new** | Editorial review |
| 462 | [ニュース](entries/1091/1091500-nyuusu.org) | ニュース | nyuusu | 1091500 | learner | draft | **new** | Editorial review |
| 463 | [庭](entries/1436/1436130-niwa.org) | にわ | niwa | 1436130 | learner | draft | **new** | Editorial review |
| 464 | [脱ぐ](entries/1416/1416400-nugu.org) | ぬぐ | nugu | 1416400 | learner | draft | **new** | Editorial review |
| 465 | [温い](entries/1183/1183300-nurui.org) | ぬるい | nurui | 1183300 | learner | draft | **new** | Editorial review |
| 466 | [ネクタイ](entries/1092/1092820-nekutai.org) | ネクタイ | nekutai | 1092820 | learner | draft | **new** | Editorial review |
| 467 | [猫](entries/1467/1467640-neko.org) | ねこ | neko | 1467640 | learner | draft | **new** | Editorial review |
| 468 | [寝る](entries/1360/1360010-neru.org) | ねる | neru | 1360010 | learner | draft | **new** | Editorial review |
| 469 | [上る](entries/1352/1352570-noboru.org) | のぼる | noboru | 1352570 | learner | draft | **new** | Editorial review |
| 470 | [飲み物](entries/1600/1600430-nomimono.org) | のみもの | nomimono | 1600430 | learner | draft | **new** | Editorial review |
| 471 | [飲む](entries/1169/1169870-nomu.org) | のむ | nomu | 1169870 | learner | draft | **new** | Editorial review |
| 472 | [乗る](entries/1355/1355120-noru.org) | のる | noru | 1355120 | learner | draft | **new** | Editorial review |
| 473 | [ノート](entries/1093/1093450-nooto.org) | ノート | nooto | 1093450 | learner | draft | **new** | Editorial review |
| 474 | [歯](entries/1313/1313000-ha.org) | は | ha | 1313000 | learner | draft | **new** | Editorial review |
| 475 | [はい](entries/1010/1010080-hai.org) | はい | hai | 1010080 | learner | draft | **new** | Editorial review |
| 476 | [灰皿](entries/1201/1201940-haizara.org) | はいざら | haizara | 1201940 | learner | draft | **new** | Editorial review |
| 477 | [入る](entries/1465/1465590-hairu.org) | はいる | hairu | 1465590 | learner | draft | **new** | Editorial review |
| 478 | [葉書](entries/1546/1546590-hagaki.org) | はがき | hagaki | 1546590 | learner | draft | **new** | Editorial review |
| 479 | [箱](entries/1585/1585650-hako.org) | はこ | hako | 1585650 | learner | draft | **new** | Editorial review |
| 480 | [橋](entries/1237/1237410-hashi.org) | はし | hashi | 1237410 | learner | draft | **new** | Editorial review |
| 481 | [箸](entries/1476/1476410-hashi.org) | はし | hashi | 1476410 | learner | draft | **new** | Editorial review |
| 482 | [走る](entries/1402/1402540-hashiru.org) | はしる | hashiru | 1402540 | learner | draft | **new** | Editorial review |
| 483 | [始まる](entries/1307/1307500-hajimaru.org) | はじまる | hajimaru | 1307500 | learner | draft | **new** | Editorial review |
| 484 | [始め](entries/1342/1342540-hajime.org) | はじめ | hajime | 1342540 | learner | draft | **new** | Editorial review |
| 485 | [初めて](entries/1342/1342550-hajimete.org) | はじめて | hajimete | 1342550 | learner | draft | **new** | Editorial review |
| 487 | [働く](entries/1451/1451150-hataraku.org) | はたらく | hataraku | 1451150 | learner | draft | **new** | Editorial review |
| 488 | [八](entries/1583/1583090-hachi.org) | はち | hachi | 1583090 | learner | draft | **new** | Editorial review |
| 489 | [２０日](entries/1600/1600850-hatsuka.org) | はつか | hatsuka | 1600850 | learner | draft | **new** | Editorial review |
| 490 | [花](entries/1194/1194500-hana.org) | はな | hana | 1194500 | learner | draft | **new** | Editorial review |
| 491 | [鼻](entries/1486/1486720-hana.org) | はな | hana | 1486720 | learner | draft | **new** | Editorial review |
| 492 | [話](entries/1600/1600900-hanashi.org) | はなし | hanashi | 1600900 | learner | draft | **new** | Editorial review |
| 493 | [話す](entries/1562/1562350-hanasu.org) | はなす | hanasu | 1562350 | learner | draft | **new** | Editorial review |
| 494 | [早い](entries/1404/1404975-hayai.org) | はやい | hayai | 1404975 | learner | draft | **new** | Editorial review |
| 495 | [春](entries/1341/1341000-haru.org) | はる | haru | 1341000 | learner | draft | **new** | Editorial review |
| 496 | [張る](entries/1427/1427900-haru.org) | はる | haru | 1427900 | learner | draft | **new** | Editorial review |
| 497 | [晴れ](entries/1376/1376460-hare.org) | はれ | hare | 1376460 | learner | draft | **new** | Editorial review |
| 498 | [晴れる](entries/1376/1376470-hareru.org) | はれる | hareru | 1376470 | learner | draft | **new** | Editorial review |
| 499 | [半](entries/1478/1478750-han.org) | はん | han | 1478750 | learner | draft | **new** | Editorial review |
| 500 | [ハンカチ](entries/1096/1096420-hankachi.org) | ハンカチ | hankachi | 1096420 | learner | draft | **new** | Editorial review |
| 501 | [半分](entries/1479/1479890-hanbun.org) | はんぶん | hanbun | 1479890 | learner | draft | **new** | Editorial review |
| 502 | [バス](entries/1098/1098390-basu.org) | バス | basu | 1098390 | learner | draft | **new** | Editorial review |
| 503 | [バター](entries/1098/1098620-bataa.org) | バター | bataa | 1098620 | learner | draft | **new** | Editorial review |
| 504 | [晩](entries/1482/1482110-ban.org) | ばん | ban | 1482110 | learner | draft | **new** | Editorial review |
| 505 | [番号](entries/1482/1482290-bangou.org) | ばんごう | bangou | 1482290 | learner | draft | **new** | Editorial review |
| 506 | [晩御飯](entries/1601/1601340-bangohan.org) | ばんごはん | bangohan | 1601340 | learner | draft | **new** | Editorial review |
| 507 | [パン](entries/1103/1103090-pan.org) | パン | pan | 1103090 | learner | draft | **new** | Editorial review |
| 508 | [パーティー](entries/1100/1100760-paatii.org) | パーティー | paatii | 1100760 | learner | draft | **new** | Editorial review |
| 509 | [東](entries/1447/1447440-higashi.org) | ひがし | higashi | 1447440 | learner | draft | **new** | Editorial review |
| 510 | [引く](entries/1169/1169250-hiku.org) | ひく | hiku | 1169250 | learner | draft | **new** | Editorial review |
| 511 | [弾く](entries/1419/1419370-hiku.org) | ひく | hiku | 1419370 | learner | draft | **new** | Editorial review |
| 512 | [低い](entries/1434/1434180-hikui.org) | ひくい | hikui | 1434180 | learner | draft | **new** | Editorial review |
| 513 | [飛行機](entries/1485/1485470-hikouki.org) | ひこうき | hikouki | 1485470 | learner | draft | **new** | Editorial review |
| 514 | [左](entries/1290/1290800-hidari.org) | ひだり | hidari | 1290800 | learner | draft | **new** | Editorial review |
| 515 | [人](entries/1580/1580640-hito.org) | ひと | hito | 1580640 | learner | draft | **new** | Editorial review |
| 516 | [一つ](entries/1160/1160820-hitotsu.org) | ひとつ | hitotsu | 1160820 | learner | draft | **new** | Editorial review |
| 517 | [一月](entries/1162/1162130-hitotsuki.org) | ひとつき | hitotsuki | 1162130 | learner | draft | **new** | Editorial review |
| 518 | [一人](entries/1576/1576150-hitori.org) | ひとり | hitori | 1576150 | learner | draft | **new** | Editorial review |
| 519 | [暇](entries/1577/1577280-hima.org) | ひま | hima | 1577280 | learner | draft | **new** | Editorial review |
| 520 | [百](entries/1488/1488000-hyaku.org) | ひゃく | hyaku | 1488000 | learner | draft | **new** | Editorial review |
| 521 | [昼](entries/1426/1426250-hiru.org) | ひる | hiru | 1426250 | learner | draft | **new** | Editorial review |
| 522 | [昼ご飯](entries/1602/1602340-hirugohan.org) | ひるごはん | hirugohan | 1602340 | learner | draft | **new** | Editorial review |
| 523 | [広い](entries/1278/1278410-hiroi.org) | ひろい | hiroi | 1278410 | learner | draft | **new** | Editorial review |
| 524 | [病院](entries/1490/1490220-byōin.org) | びょういん | byōin | 1490220 | learner | draft | **new** | Editorial review |
| 525 | [病気](entries/1490/1490230-byōki.org) | びょうき | byōki | 1490230 | learner | draft | **new** | Editorial review |
| 526 | [フィルム](entries/1109/1109380-firumu.org) | フィルム | firumu | 1109380 | learner | draft | **new** | Editorial review |
| 527 | [封筒](entries/1499/1499690-fūtō.org) | ふうとう | fūtō | 1499690 | learner | draft | **new** | Editorial review |
| 528 | [フォーク](entries/1110/1110110-fooku.org) | フォーク | fooku | 1110110 | learner | draft | **new** | Editorial review |
| 529 | [服](entries/1500/1500940-fuku.org) | ふく | fuku | 1500940 | learner | draft | **new** | Editorial review |
| 530 | [吹く](entries/1370/1370760-fuku.org) | ふく | fuku | 1370760 | learner | draft | **new** | Editorial review |
| 531 | [二つ](entries/1461/1461160-futatsu.org) | ふたつ | futatsu | 1461160 | learner | draft | **new** | Editorial review |
| 532 | [二人](entries/1582/1582670-futari.org) | ふたり | futari | 1582670 | learner | draft | **new** | Editorial review |
| 533 | [２日](entries/1462/1462900-futsuka.org) | ふつか | futsuka | 1462900 | learner | draft | **new** | Editorial review |
| 534 | [太い](entries/1408/1408180-futoi.org) | ふとい | futoi | 1408180 | learner | draft | **new** | Editorial review |
| 535 | [冬](entries/1446/1446070-fuyu.org) | ふゆ | fuyu | 1446070 | learner | draft | **new** | Editorial review |
| 536 | [降る](entries/1282/1282790-furu.org) | ふる | furu | 1282790 | learner | draft | **new** | Editorial review |
| 537 | [古い](entries/1265/1265070-furui.org) | ふるい | furui | 1265070 | learner | draft | **new** | Editorial review |
| 538 | [風呂](entries/1500/1500100-furo.org) | ふろ | furo | 1500100 | learner | draft | **new** | Editorial review |
| 539 | [豚肉](entries/1457/1457440-butaniku.org) | ぶたにく | butaniku | 1457440 | learner | draft | **new** | Editorial review |
| 540 | [文章](entries/1505/1505470-bunshou.org) | ぶんしょう | bunshou | 1505470 | learner | draft | **new** | Editorial review |
| 541 | [プール](entries/1115/1115150-puuru.org) | プール | puuru | 1115150 | learner | draft | **new** | Editorial review |
| 542 | [下手](entries/1185/1185200-heta.org) | へた | heta | 1185200 | learner | draft | **new** | Editorial review |
| 543 | [部屋](entries/1499/1499320-heya.org) | へや | heya | 1499320 | learner | draft | **new** | Editorial review |
| 544 | [辺](entries/1512/1512070-hen.org) | へん | hen | 1512070 | learner | draft | **new** | Editorial review |
| 545 | [ベッド](entries/1119/1119650-beddo.org) | ベッド | beddo | 1119650 | learner | draft | **new** | Editorial review |
| 546 | [勉強](entries/1512/1512670-benkyou.org) | べんきょう | benkyou | 1512670 | learner | draft | **new** | Editorial review |
| 547 | [便利](entries/1512/1512610-benri.org) | べんり | benri | 1512610 | learner | draft | **new** | Editorial review |
| 548 | [ペット](entries/1120/1120990-petto.org) | ペット | petto | 1120990 | learner | draft | **new** | Editorial review |
| 549 | [ＰＥＴ](entries/2189/2189230-petto.org) | ペット | petto | 2189230 | learner | draft | **new** | Editorial review |
| 550 | [ペン](entries/1121/1121380-pen.org) | ペン | pen | 1121380 | learner | draft | **new** | Editorial review |
| 551 | [頁](entries/1120/1120410-peeji.org) | ページ | peeji | 1120410 | learner | draft | **new** | Editorial review |
| 552 | [他](entries/1203/1203260-hoka.org) | ほか | hoka | 1203260 | learner | draft | **new** | Editorial review |
| 553 | [欲しい](entries/1547/1547330-hoshii.org) | ほしい | hoshii | 1547330 | learner | draft | **new** | Editorial review |
| 554 | [細い](entries/1295/1295510-hosoi.org) | ほそい | hosoi | 1295510 | learner | draft | **new** | Editorial review |
| 555 | [ホテル](entries/1122/1122650-hoteru.org) | ホテル | hoteru | 1122650 | learner | draft | **new** | Editorial review |
| 556 | [本](entries/1522/1522150-hon.org) | ほん | hon | 1522150 | learner | draft | **new** | Editorial review |
| 557 | [本棚](entries/1522/1522980-hondana.org) | ほんだな | hondana | 1522980 | learner | draft | **new** | Editorial review |
| 558 | [本当](entries/1523/1523060-hontou.org) | ほんとう | hontou | 1523060 | learner | draft | **new** | Editorial review |
| 559 | [帽子](entries/1519/1519170-boushi.org) | ぼうし | boushi | 1519170 | learner | draft | **new** | Editorial review |
| 560 | [釦](entries/1123/1123880-botan.org) | ボタン | botan | 1123880 | learner | draft | **new** | Editorial review |
| 561 | [ボールペン](entries/1123/1123590-bo-rupen.org) | ボールペン | rupen | 1123590 | learner | draft | **new** | Editorial review |
| 562 | [ポケット](entries/1124/1124970-poketto.org) | ポケット | poketto | 1124970 | learner | draft | **new** | Editorial review |
| 563 | [ポスト](entries/1125/1125150-posuto.org) | ポスト | posuto | 1125150 | learner | draft | **new** | Editorial review |
| 564 | [毎朝](entries/1524/1524700-maiasa.org) | まいあさ | maiasa | 1524700 | learner | draft | **new** | Editorial review |
| 565 | [毎週](entries/1524/1524690-maishuu.org) | まいしゅう | maishuu | 1524690 | learner | draft | **new** | Editorial review |
| 566 | [毎月](entries/1584/1584350-maitsuki.org) | まいつき | maitsuki | 1584350 | learner | draft | **new** | Editorial review |
| 567 | [毎年](entries/1584/1584360-maitoshi.org) | まいとし | maitoshi | 1584360 | learner | draft | **new** | Editorial review |
| 568 | [毎日](entries/1524/1524720-mainichi.org) | まいにち | mainichi | 1524720 | learner | draft | **new** | Editorial review |
| 569 | [毎晩](entries/1524/1524730-maiban.org) | まいばん | maiban | 1524730 | learner | draft | **new** | Editorial review |
| 570 | [前](entries/1392/1392580-mae.org) | まえ | mae | 1392580 | learner | draft | **new** | Editorial review |
| 571 | [不味い](entries/1495/1495000-mazui.org) | まずい | mazui | 1495000 | learner | draft | **new** | Editorial review |
| 572 | [又](entries/1524/1524930-mata.org) | また | mata | 1524930 | learner | draft | **new** | Editorial review |
| 573 | [未だ](entries/1527/1527110-mada.org) | まだ | mada | 1527110 | learner | draft | **new** | Editorial review |
| 574 | [町](entries/1603/1603990-machi.org) | まち | machi | 1603990 | learner | draft | **new** | Editorial review |
| 575 | [真っ直ぐ](entries/1580/1580600-massugu.org) | まっすぐ | massugu | 1580600 | learner | draft | **new** | Editorial review |
| 576 | [マッチ](entries/2784/2784220-matchi.org) | マッチ | matchi | 2784220 | learner | draft | **new** | Editorial review |
| 577 | [燐寸](entries/1128/1128430-matchi.org) | マッチ | matchi | 1128430 | learner | draft | **new** | Editorial review |
| 578 | [待つ](entries/1410/1410590-matsu.org) | まつ | matsu | 1410590 | learner | draft | **new** | Editorial review |
| 579 | [窓](entries/1401/1401400-mado.org) | まど | mado | 1401400 | learner | draft | **new** | Editorial review |
| 580 | [丸い](entries/1604/1604230-marui.org) | まるい | marui | 1604230 | learner | draft | **new** | Editorial review |
| 581 | [万](entries/1584/1584460-man.org) | まん | man | 1584460 | learner | draft | **new** | Editorial review |
| 582 | [万年筆](entries/1526/1526360-mannenhitsu.org) | まんねんひつ | mannenhitsu | 1526360 | learner | draft | **new** | Editorial review |
| 583 | [磨く](entries/1523/1523940-migaku.org) | みがく | migaku | 1523940 | learner | draft | **new** | Editorial review |
| 584 | [右](entries/1171/1171010-migi.org) | みぎ | migi | 1171010 | learner | draft | **new** | Editorial review |
| 585 | [短い](entries/1418/1418620-mijikai.org) | みじかい | mijikai | 1418620 | learner | draft | **new** | Editorial review |
| 586 | [水](entries/1371/1371260-mizu.org) | みず | mizu | 1371260 | learner | draft | **new** | Editorial review |
| 587 | [店](entries/1582/1582120-mise.org) | みせ | mise | 1582120 | learner | draft | **new** | Editorial review |
| 588 | [見せる](entries/1259/1259210-miseru.org) | みせる | miseru | 1259210 | learner | draft | **new** | Editorial review |
| 589 | [道](entries/1454/1454080-michi.org) | みち | michi | 1454080 | learner | draft | **new** | Editorial review |
| 590 | [３日](entries/1301/1301330-mikka.org) | みっか | mikka | 1301330 | learner | draft | **new** | Editorial review |
| 591 | [三つ](entries/1299/1299740-mittsu.org) | みっつ | mittsu | 1299740 | learner | draft | **new** | Editorial review |
| 592 | [緑](entries/1555/1555300-midori.org) | みどり | midori | 1555300 | learner | draft | **new** | Editorial review |
| 593 | [皆さん](entries/1202/1202170-minasan.org) | みなさん | minasan | 1202170 | learner | draft | **new** | Editorial review |
| 594 | [南](entries/1459/1459870-minami.org) | みなみ | minami | 1459870 | learner | draft | **new** | Editorial review |
| 595 | [耳](entries/1317/1317170-mimi.org) | みみ | mimi | 1317170 | learner | draft | **new** | Editorial review |
| 596 | [見る](entries/1259/1259290-miru.org) | みる | miru | 1259290 | learner | draft | **new** | Editorial review |
| 597 | [皆](entries/1202/1202150-minna.org) | みんな | minna | 1202150 | learner | draft | **new** | Editorial review |
| 598 | [６日](entries/1561/1561470-muika.org) | むいか | muika | 1561470 | learner | draft | **new** | Editorial review |
| 599 | [向こう](entries/1277/1277140-mukō.org) | むこう | mukō | 1277140 | learner | draft | **new** | Editorial review |
| 600 | [難しい](entries/1460/1460850-muzukashii.org) | むずかしい | muzukashii | 1460850 | learner | draft | **new** | Editorial review |
| 601 | [六つ](entries/1585/1585315-muttsu.org) | むっつ | muttsu | 1585315 | learner | draft | **new** | Editorial review |
| 602 | [村](entries/1406/1406820-mura.org) | むら | mura | 1406820 | learner | draft | **new** | Editorial review |
| 603 | [目](entries/1604/1604890-me.org) | め | me | 1604890 | learner | draft | **new** | Editorial review |
| 604 | [眼](entries/1604/1604890-me.org) | め | me | 1604890 | learner | draft | **new** | Editorial review |
| 605 | [メガネ](entries/1577/1577670-megane.org) | メガネ | megane | 1577670 | learner | draft | **new** | Editorial review |
| 606 | [眼鏡](entries/1577/1577670-megane.org) | めがね | megane | 1577670 | learner | draft | **new** | Editorial review |
| 607 | [米](entries/1132/1132570-meetoru.org) | メートル | meetoru | 1132570 | learner | draft | **new** | Editorial review |
| 608 | [もう](entries/1012/1012480-mou.org) | もう | mou | 1012480 | learner | draft | **new** | Editorial review |
| 609 | [もう一度](entries/2005/2005860-mouichido.org) | もういちど | mouichido | 2005860 | learner | draft | **new** | Editorial review |
| 610 | [木曜日](entries/1534/1534890-mokuyoubi.org) | もくようび | mokuyoubi | 1534890 | learner | draft | **new** | Editorial review |
| 611 | [もっと](entries/1012/1012620-motto.org) | もっと | motto | 1012620 | learner | draft | **new** | Editorial review |
| 612 | [持つ](entries/1315/1315720-motsu.org) | もつ | motsu | 1315720 | learner | draft | **new** | Editorial review |
| 613 | [物](entries/1502/1502390-mono.org) | もの | mono | 1502390 | learner | draft | **new** | Editorial review |
| 614 | [門](entries/1584/1584800-mon.org) | もん | mon | 1584800 | learner | draft | **new** | Editorial review |
| 615 | [問題](entries/1536/1536010-mondai.org) | もんだい | mondai | 1536010 | learner | draft | **new** | Editorial review |
| 616 | [八百屋](entries/1476/1476960-yaoya.org) | やおや | yaoya | 1476960 | learner | draft | **new** | Editorial review |
| 617 | [野菜](entries/1537/1537370-yasai.org) | やさい | yasai | 1537370 | learner | draft | **new** | Editorial review |
| 618 | [易しい](entries/1157/1157000-yasashii.org) | やさしい | yasashii | 1157000 | learner | draft | **new** | Editorial review |
| 619 | [安い](entries/1153/1153670-yasui.org) | やすい | yasui | 1153670 | learner | draft | **new** | Editorial review |
| 620 | [休み](entries/1227/1227500-yasumi.org) | やすみ | yasumi | 1227500 | learner | draft | **new** | Editorial review |
| 621 | [休む](entries/1227/1227560-yasumu.org) | やすむ | yasumu | 1227560 | learner | draft | **new** | Editorial review |
| 622 | [八つ](entries/1583/1583095-yattsu.org) | やっつ | yattsu | 1583095 | learner | draft | **new** | Editorial review |
| 623 | [山](entries/1302/1302680-yama.org) | やま | yama | 1302680 | learner | draft | **new** | Editorial review |
| 624 | [夕方](entries/1542/1542790-yuugata.org) | ゆうがた | yuugata | 1542790 | learner | draft | **new** | Editorial review |
| 625 | [夕飯](entries/1584/1584910-yuuhan.org) | ゆうはん | yuuhan | 1584910 | learner | draft | **new** | Editorial review |
| 626 | [郵便局](entries/1542/1542430-yuubinkyoku.org) | ゆうびんきょく | yuubinkyoku | 1542430 | learner | draft | **new** | Editorial review |
| 627 | [昨夜](entries/1542/1542640-yuube.org) | ゆうべ | yuube | 1542640 | learner | draft | **new** | Editorial review |
| 628 | [有名](entries/1541/1541620-yuumei.org) | ゆうめい | yuumei | 1541620 | learner | draft | **new** | Editorial review |
| 629 | [雪](entries/1386/1386500-yuki.org) | ゆき | yuki | 1386500 | learner | draft | **new** | Editorial review |
| 630 | [ゆっくり](entries/1013/1013050-yukkuri.org) | ゆっくり | yukkuri | 1013050 | learner | draft | **new** | Editorial review |
| 631 | [良い](entries/1605/1605820-yoi.org) | よい | yoi | 1605820 | learner | draft | **new** | Editorial review |
| 632 | [８日](entries/1476/1476920-youka.org) | ようか | youka | 1476920 | learner | draft | **new** | Editorial review |
| 633 | [洋服](entries/1546/1546020-youfuku.org) | ようふく | youfuku | 1546020 | learner | draft | **new** | Editorial review |
| 634 | [良く](entries/1605/1605870-yoku.org) | よく | yoku | 1605870 | learner | draft | **new** | Editorial review |
| 635 | [横](entries/1180/1180570-yoko.org) | よこ | yoko | 1180570 | learner | draft | **new** | Editorial review |
| 636 | [４日](entries/1307/1307320-yokka.org) | よっか | yokka | 1307320 | learner | draft | **new** | Editorial review |
| 637 | [四つ](entries/1307/1307040-yottsu.org) | よっつ | yottsu | 1307040 | learner | draft | **new** | Editorial review |
| 638 | [呼ぶ](entries/1266/1266440-yobu.org) | よぶ | yobu | 1266440 | learner | draft | **new** | Editorial review |
| 639 | [読む](entries/1456/1456360-yomu.org) | よむ | yomu | 1456360 | learner | draft | **new** | Editorial review |
| 640 | [より](entries/1013/1013190-yori.org) | より | yori | 1013190 | learner | draft | **new** | Editorial review |
| 641 | [夜](entries/1536/1536350-yoru.org) | よる | yoru | 1536350 | learner | draft | **new** | Editorial review |
| 642 | [弱い](entries/1324/1324520-yowai.org) | よわい | yowai | 1324520 | learner | draft | **new** | Editorial review |
| 643 | [来月](entries/1547/1547900-raigetsu.org) | らいげつ | raigetsu | 1547900 | learner | draft | **new** | Editorial review |
| 644 | [来週](entries/1548/1548010-raishū.org) | らいしゅう | raishū | 1548010 | learner | draft | **new** | Editorial review |
| 645 | [来年](entries/1548/1548220-rainen.org) | らいねん | rainen | 1548220 | learner | draft | **new** | Editorial review |
| 646 | [ラジオ](entries/1138/1138860-rajio.org) | ラジオ | rajio | 1138860 | learner | draft | **new** | Editorial review |
| 647 | [ラジカセ](entries/1138/1138960-rajikase.org) | ラジカセ | rajikase | 1138960 | learner | draft | **new** | Editorial review |
| 648 | [立派](entries/1551/1551790-rippa.org) | りっぱ | rippa | 1551790 | learner | draft | **new** | Editorial review |
| 649 | [留学生](entries/1552/1552750-ryūgakusei.org) | りゅうがくせい | ryūgakusei | 1552750 | learner | draft | **new** | Editorial review |
| 650 | [両親](entries/1602/1602710-ryōshin.org) | りょうしん | ryōshin | 1602710 | learner | draft | **new** | Editorial review |
| 651 | [料理](entries/1554/1554310-ryōri.org) | りょうり | ryōri | 1554310 | learner | draft | **new** | Editorial review |
| 652 | [旅行](entries/1553/1553170-ryokō.org) | りょこう | ryokō | 1553170 | learner | draft | **new** | Editorial review |
| 653 | [零](entries/1557/1557630-rei.org) | れい | rei | 1557630 | learner | draft | **new** | Editorial review |
| 654 | [冷蔵庫](entries/1557/1557110-reizōko.org) | れいぞうこ | reizōko | 1557110 | learner | draft | **new** | Editorial review |
| 655 | [レコード](entries/1144/1144940-rekoodo.org) | レコード | rekoodo | 1144940 | learner | draft | **new** | Editorial review |
| 656 | [レストラン](entries/1145/1145310-resutoran.org) | レストラン | resutoran | 1145310 | learner | draft | **new** | Editorial review |
| 657 | [練習](entries/1559/1559160-renshū.org) | れんしゅう | renshū | 1559160 | learner | draft | **new** | Editorial review |
| 658 | [廊下](entries/1560/1560670-rōka.org) | ろうか | rōka | 1560670 | learner | draft | **new** | Editorial review |
| 659 | [六](entries/1585/1585310-roku.org) | ろく | roku | 1585310 | learner | draft | **new** | Editorial review |
| 660 | [Ｙシャツ](entries/1148/1148640-waishatsu.org) | ワイシャツ | waishatsu | 1148640 | learner | draft | **new** | Editorial review |
| 661 | [若い](entries/1324/1324300-wakai.org) | わかい | wakai | 1324300 | learner | draft | **new** | Editorial review |
| 662 | [分かる](entries/1606/1606560-wakaru.org) | わかる | wakaru | 1606560 | learner | draft | **new** | Editorial review |
| 663 | [忘れる](entries/1519/1519210-wasureru.org) | わすれる | wasureru | 1519210 | learner | draft | **new** | Editorial review |
| 664 | [私](entries/1311/1311110-watashi.org) | わたし | watashi | 1311110 | learner | draft | **new** | Editorial review |
| 665 | [渡す](entries/1444/1444610-watasu.org) | わたす | watasu | 1444610 | learner | draft | **new** | Editorial review |
| 666 | [渡る](entries/1444/1444680-wataru.org) | わたる | wataru | 1444680 | learner | draft | **new** | Editorial review |
| 667 | [悪い](entries/1151/1151260-warui.org) | わるい | warui | 1151260 | learner | draft | **new** | Editorial review |
| seed | [日本語](entries/1464/1464530-nihongo.org) | にほんご | nihongo | 1464530 | enriched | draft | **new** | Editorial review |
