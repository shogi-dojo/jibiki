# Dictionary entry progress

This is the merge ledger for the authored dictionary. It records what exists,
what has actually been reviewed, and what may be described as release-ready.
It must not be used to infer linguistic approval merely because an entry passes
the automated JMdict and Org checks.

Last reconciled with the entry tree: **2026-08-16** on the PR #6 cleanup
branch.

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
`scripts/scaffold_entry.rb` (`rake "entries:scaffold[order,romaji,level]"`),
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
| Canonical entry files | 1947 |
| Canonical N5 entries | 656 |
| N5 queue rows covered | 667 / 667 (100.0%) |
| Canonical N4 entries | 712 |
| N4 queue rows covered | 724 / 724 (100.0%) |
| Canonical N3 entries | 578 |
| N3 queue rows covered | 604 / 1677 (36.0%) |
| Extra seed entries | 1 (`日本語`) |
| `new` | 1910 |
| `changes-requested` | 0 |
| `reviewed` | 9 |
| `confirmed` | 28 |
| `solid` | 0 |
| Entry metadata still marked `draft` | 1937 |
| Core profile | 163 |
| Learner profile | 1783 |
| Enriched profile | 1 |

All 667 N5 queue rows and all 724 N4 queue rows are represented. JLPT N3 queue has 604 rows covered (578 distinct files) out of 1677.
Canonical N4 queue rows produce 712 canonical N4 entry files due to aliases and shared JMdict entries.
The seed entry `日本語` is outside the N5/N4/N3 queues.

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
| 428 | [如何して](entries/1466/1466940-dooshite.org) | どうして | dōshite | 1466940 | learner | draft | **new** | Editorial review |
| 429 | [どうぞ](entries/1189/1189130-doozo.org) | どうぞ | dōzo | 1189130 | learner | draft | **new** | Editorial review |
| 430 | [動物](entries/1451/1451470-doobutsu.org) | どうぶつ | dōbutsu | 1451470 | learner | draft | **new** | Editorial review |
| 431 | [どうも](entries/1009/1009000-doomo.org) | どうも | doomo | 1009000 | learner | draft | **new** | Editorial review |
| 432 | [何処](entries/1577/1577140-doko.org) | どこ | doko | 1577140 | learner | draft | **new** | Editorial review |
| 433 | [何方](entries/1189/1189360-dochira.org) | どちら | dochira | 1189360 | learner | draft | **new** | Editorial review |
| 434 | [何方](entries/1189/1189370-donata.org) | どなた | donata | 1189370 | learner | draft | **new** | Editorial review |
| 435 | [何の](entries/1920/1920240-dono.org) | どの | dono | 1920240 | learner | draft | **new** | Editorial review |
| 436 | [土曜日](entries/1445/1445590-doyoobi.org) | どようび | doyōbi | 1445590 | learner | draft | **new** | Editorial review |
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
| 524 | [病院](entries/1490/1490220-byooin.org) | びょういん | byōin | 1490220 | learner | draft | **new** | Editorial review |
| 525 | [病気](entries/1490/1490230-byooki.org) | びょうき | byōki | 1490230 | learner | draft | **new** | Editorial review |
| 526 | [フィルム](entries/1109/1109380-firumu.org) | フィルム | firumu | 1109380 | learner | draft | **new** | Editorial review |
| 527 | [封筒](entries/1499/1499690-fuutoo.org) | ふうとう | fūtō | 1499690 | learner | draft | **new** | Editorial review |
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
| 599 | [向こう](entries/1277/1277140-mukoo.org) | むこう | mukō | 1277140 | learner | draft | **new** | Editorial review |
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
| 644 | [来週](entries/1548/1548010-raishuu.org) | らいしゅう | raishū | 1548010 | learner | draft | **new** | Editorial review |
| 645 | [来年](entries/1548/1548220-rainen.org) | らいねん | rainen | 1548220 | learner | draft | **new** | Editorial review |
| 646 | [ラジオ](entries/1138/1138860-rajio.org) | ラジオ | rajio | 1138860 | learner | draft | **new** | Editorial review |
| 647 | [ラジカセ](entries/1138/1138960-rajikase.org) | ラジカセ | rajikase | 1138960 | learner | draft | **new** | Editorial review |
| 648 | [立派](entries/1551/1551790-rippa.org) | りっぱ | rippa | 1551790 | learner | draft | **new** | Editorial review |
| 649 | [留学生](entries/1552/1552750-ryuugakusei.org) | りゅうがくせい | ryūgakusei | 1552750 | learner | draft | **new** | Editorial review |
| 650 | [両親](entries/1602/1602710-ryooshin.org) | りょうしん | ryōshin | 1602710 | learner | draft | **new** | Editorial review |
| 651 | [料理](entries/1554/1554310-ryoori.org) | りょうり | ryōri | 1554310 | learner | draft | **new** | Editorial review |
| 652 | [旅行](entries/1553/1553170-ryokoo.org) | りょこう | ryokō | 1553170 | learner | draft | **new** | Editorial review |
| 653 | [零](entries/1557/1557630-rei.org) | れい | rei | 1557630 | learner | draft | **new** | Editorial review |
| 654 | [冷蔵庫](entries/1557/1557110-reizooko.org) | れいぞうこ | reizōko | 1557110 | learner | draft | **new** | Editorial review |
| 655 | [レコード](entries/1144/1144940-rekoodo.org) | レコード | rekoodo | 1144940 | learner | draft | **new** | Editorial review |
| 656 | [レストラン](entries/1145/1145310-resutoran.org) | レストラン | resutoran | 1145310 | learner | draft | **new** | Editorial review |
| 657 | [練習](entries/1559/1559160-renshuu.org) | れんしゅう | renshū | 1559160 | learner | draft | **new** | Editorial review |
| 658 | [廊下](entries/1560/1560670-rooka.org) | ろうか | rōka | 1560670 | learner | draft | **new** | Editorial review |
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

### N4 entry inventory

Queue orders 72–91 were excluded from this checkpoint because they remained
un-authored scaffolds. The retained N4 entries below contain authored learner
content and remain at `new` until editorial review.

| Queue order | Entry | Reading | Romaji | JMdict ID | Profile | Entry state | Maturity | Next gate |
| ---: | --- | --- | --- | ---: | --- | --- | --- | --- |
| N4-001 | [間](entries/1215/1215230-aida.org) | あいだ | aida | 1215230 | learner | draft | **new** | Editorial review |
| N4-002 | [合う](entries/1284/1284430-au.org) | あう | au | 1284430 | learner | draft | **new** | Editorial review |
| N4-003 | [赤ちゃん](entries/1383/1383260-akachan.org) | あかちゃん | akachan | 1383260 | learner | draft | **new** | Editorial review |
| N4-004 | [赤ん坊](entries/1383/1383310-akanbou.org) | あかんぼう | akanbou | 1383310 | learner | draft | **new** | Editorial review |
| N4-005 | [上がる](entries/1352/1352290-agaru.org) | あがる | agaru | 1352290 | learner | draft | **new** | Editorial review |
| N4-006 | [浅い](entries/1390/1390800-asai.org) | あさい | asai | 1390800 | learner | draft | **new** | Editorial review |
| N4-007 | [味](entries/1526/1526960-aji.org) | あじ | aji | 1526960 | learner | draft | **new** | Editorial review |
| N4-008 | [遊び](entries/1542/1542070-asobi.org) | あそび | asobi | 1542070 | learner | draft | **new** | Editorial review |
| N4-009 | [集まる](entries/1333/1333550-atsumaru.org) | あつまる | atsumaru | 1333550 | learner | draft | **new** | Editorial review |
| N4-010 | [集める](entries/1333/1333560-atsumeru.org) | あつめる | atsumeru | 1333560 | learner | draft | **new** | Editorial review |
| N4-011 | [謝る](entries/1323/1323010-ayamaru.org) | あやまる | ayamaru | 1323010 | learner | draft | **new** | Editorial review |
| N4-012 | [安心](entries/1153/1153890-anshin.org) | あんしん | anshin | 1153890 | learner | draft | **new** | Editorial review |
| N4-013 | [安全](entries/1153/1153930-anzen.org) | あんぜん | anzen | 1153930 | learner | draft | **new** | Editorial review |
| N4-014 | [以下](entries/1155/1155060-ika.org) | いか | ika | 1155060 | learner | draft | **new** | Editorial review |
| N4-015 | [以外](entries/1155/1155090-igai.org) | いがい | igai | 1155090 | learner | draft | **new** | Editorial review |
| N4-016 | [医学](entries/1159/1159810-igaku.org) | いがく | igaku | 1159810 | learner | draft | **new** | Editorial review |
| N4-017 | [生きる](entries/1378/1378520-ikiru.org) | いきる | ikiru | 1378520 | learner | draft | **new** | Editorial review |
| N4-018 | [意見](entries/1156/1156530-iken.org) | いけん | iken | 1156530 | learner | draft | **new** | Editorial review |
| N4-019 | [石](entries/1382/1382440-ishi.org) | いし | ishi | 1382440 | learner | draft | **new** | Editorial review |
| N4-020 | [苛める](entries/1195/1195140-ijimeru.org) | いじめる | ijimeru | 1195140 | learner | draft | **new** | Editorial review |
| N4-021 | [以上](entries/1155/1155120-ijou.org) | いじょう | ijou | 1155120 | learner | draft | **new** | Editorial review |
| N4-022 | [急ぐ](entries/1228/1228650-isogu.org) | いそぐ | isogu | 1228650 | learner | draft | **new** | Editorial review |
| N4-023 | [致す](entries/1421/1421900-itasu.org) | いたす | itasu | 1421900 | learner | draft | **new** | Editorial review |
| N4-024 | [一度](entries/1576/1576250-ichido.org) | いちど | ichido | 1576250 | learner | draft | **new** | Editorial review |
| N4-025 | [一生懸命](entries/1164/1164010-isshoukenmei.org) | いっしょうけんめい | isshoukenmei | 1164010 | learner | draft | **new** | Editorial review |
| N4-026 | [糸](entries/1311/1311450-ito.org) | いと | ito | 1311450 | learner | draft | **new** | Editorial review |
| N4-027 | [以内](entries/1155/1155180-inai.org) | いない | inai | 1155180 | learner | draft | **new** | Editorial review |
| N4-028 | [田舎](entries/1442/1442750-inaka.org) | いなか | inaka | 1442750 | learner | draft | **new** | Editorial review |
| N4-029 | [祈る](entries/1222/1222770-inoru.org) | いのる | inoru | 1222770 | learner | draft | **new** | Editorial review |
| N4-030 | [植える](entries/1357/1357250-ueru.org) | うえる | ueru | 1357250 | learner | draft | **new** | Editorial review |
| N4-031 | [受付](entries/1588/1588060-uketsuke.org) | うけつけ | uketsuke | 1588060 | learner | draft | **new** | Editorial review |
| N4-032 | [受ける](entries/1329/1329590-ukeru.org) | うける | ukeru | 1329590 | learner | draft | **new** | Editorial review |
| N4-033 | [動く](entries/1451/1451210-ugoku.org) | うごく | ugoku | 1451210 | learner | draft | **new** | Editorial review |
| N4-034 | [内](entries/1457/1457730-uchi.org) | うち | uchi | 1457730 | learner | draft | **new** | Editorial review |
| N4-035 | [打つ](entries/1408/1408810-utsu.org) | うつ | utsu | 1408810 | learner | draft | **new** | Editorial review |
| N4-036 | [美しい](entries/1486/1486360-utsukushii.org) | うつくしい | utsukushii | 1486360 | learner | draft | **new** | Editorial review |
| N4-037 | [写す](entries/1588/1588320-utsusu.org) | うつす | utsusu | 1588320 | learner | draft | **new** | Editorial review |
| N4-038 | [移る](entries/1158/1158210-utsuru.org) | うつる | utsuru | 1158210 | learner | draft | **new** | Editorial review |
| N4-039 | [腕](entries/1562/1562850-ude.org) | うで | ude | 1562850 | learner | draft | **new** | Editorial review |
| N4-040 | [売り場](entries/1588/1588550-uriba.org) | うりば | uriba | 1588550 | learner | draft | **new** | Editorial review |
| N4-041 | [運転手](entries/1172/1172870-untenshu.org) | うんてんしゅ | untenshu | 1172870 | learner | draft | **new** | Editorial review |
| N4-042 | [枝](entries/1310/1310530-eda.org) | えだ | eda | 1310530 | learner | draft | **new** | Editorial review |
| N4-043 | [選ぶ](entries/1588/1588730-erabu.org) | えらぶ | erabu | 1588730 | learner | draft | **new** | Editorial review |
| N4-044 | [遠慮](entries/1178/1178450-enryo.org) | えんりょ | enryo | 1178450 | learner | draft | **new** | Editorial review |
| N4-045 | [お出でになる](entries/1001/1001180-oideninaru.org) | おいでになる | oideninaru | 1001180 | learner | draft | **new** | Editorial review |
| N4-046 | [お祝い](entries/1612/1612770-oiwai.org) | おいわい | oiwai | 1612770 | learner | draft | **new** | Editorial review |
| N4-047 | [お陰](entries/1001/1001640-okage.org) | おかげ | okage | 1001640 | learner | draft | **new** | Editorial review |
| N4-048 | [可笑しい](entries/1190/1190860-okashii.org) | おかしい | okashii | 1190860 | learner | draft | **new** | Editorial review |
| N4-049 | [億](entries/1182/1182620-oku.org) | おく | oku | 1182620 | learner | draft | **new** | Editorial review |
| N4-050 | [屋上](entries/1182/1182710-okujou.org) | おくじょう | okujou | 1182710 | learner | draft | **new** | Editorial review |
| N4-051 | [送る](entries/1402/1402730-okuru.org) | おくる | okuru | 1402730 | learner | draft | **new** | Editorial review |
| N4-052 | [遅れる](entries/1589/1589040-okureru.org) | おくれる | okureru | 1589040 | learner | draft | **new** | Editorial review |
| N4-053 | [起こす](entries/1223/1223660-okosu.org) | おこす | okosu | 1223660 | learner | draft | **new** | Editorial review |
| N4-054 | [行う](entries/1589/1589060-okonau.org) | おこなう | okonau | 1589060 | learner | draft | **new** | Editorial review |
| N4-055 | [怒る](entries/1445/1445690-okoru.org) | おこる | okoru | 1445690 | learner | draft | **new** | Editorial review |
| N4-056 | [押入れ](entries/1589/1589110-oshiire.org) | おしいれ | oshiire | 1589110 | learner | draft | **new** | Editorial review |
| N4-057 | [お嬢さん](entries/1002/1002170-ojousan.org) | おじょうさん | ojousan | 1002170 | learner | draft | **new** | Editorial review |
| N4-058 | [お宅](entries/1002/1002400-otaku.org) | おたく | otaku | 1002400 | learner | draft | **new** | Editorial review |
| N4-059 | [落ちる](entries/1548/1548550-ochiru.org) | おちる | ochiru | 1548550 | learner | draft | **new** | Editorial review |
| N4-060 | [仰る](entries/1238/1238840-ossharu.org) | おっしゃる | ossharu | 1238840 | learner | draft | **new** | Editorial review |
| N4-061 | [夫](entries/1496/1496480-otto.org) | おっと | otto | 1496480 | learner | draft | **new** | Editorial review |
| N4-062 | [お釣り](entries/1270/1270550-otsuri.org) | おつり | otsuri | 1270550 | learner | draft | **new** | Editorial review |
| N4-063 | [音](entries/1576/1576900-oto.org) | おと | oto | 1576900 | learner | draft | **new** | Editorial review |
| N4-064 | [落とす](entries/1589/1589260-otosu.org) | おとす | otosu | 1589260 | learner | draft | **new** | Editorial review |
| N4-065 | [踊り](entries/1546/1546880-odori.org) | おどり | odori | 1546880 | learner | draft | **new** | Editorial review |
| N4-066 | [踊る](entries/1538/1538440-odoru.org) | おどる | odoru | 1538440 | learner | draft | **new** | Editorial review |
| N4-067 | [驚く](entries/1238/1238680-odoroku.org) | おどろく | odoroku | 1238680 | learner | draft | **new** | Editorial review |
| N4-068 | [お祭り](entries/1604/1604135-omatsuri.org) | おまつり | omatsuri | 1604135 | learner | draft | **new** | Editorial review |
| N4-069 | [お見舞い](entries/1001/1001870-omimai.org) | おみまい | omimai | 1001870 | learner | draft | **new** | Editorial review |
| N4-070 | [お土産](entries/1002/1002500-omiyage.org) | おみやげ | omiyage | 1002500 | learner | draft | **new** | Editorial review |
| N4-071 | [思い出す](entries/1309/1309260-omoidasu.org) | おもいだす | omoidasu | 1309260 | learner | draft | **new** | Editorial review |
| N4-088 | [鏡](entries/1238/1238550-kagami.org) | かがみ | kagami | 1238550 | learner | draft | **new** | Editorial review |
| N4-092 | [形](entries/1250/1250220-katachi.org) | かたち | katachi | 1250220 | learner | draft | **new** | Editorial review |
| N4-093 | [片付ける](entries/1511/1511790-katazukeru.org) | かたづける | katazukeru | 1511790 | learner | draft | **new** | Editorial review |
| N4-094 | [課長](entries/1195/1195840-kachou.org) | かちょう | kachou | 1195840 | learner | draft | **new** | Editorial review |
| N4-095 | [勝つ](entries/1346/1346150-katsu.org) | かつ | katsu | 1346150 | learner | draft | **new** | Editorial review |
| N4-096 | [家内](entries/1192/1192420-kanai.org) | かない | kanai | 1192420 | learner | draft | **new** | Editorial review |
| N4-097 | [悲しい](entries/1483/1483190-kanashii.org) | かなしい | kanashii | 1483190 | learner | draft | **new** | Editorial review |
| N4-098 | [必ず](entries/1487/1487400-kanarazu.org) | かならず | kanarazu | 1487400 | learner | draft | **new** | Editorial review |
| N4-099 | [彼女](entries/1483/1483150-kanojo.org) | かのじょ | kanojo | 1483150 | learner | draft | **new** | Editorial review |
| N4-100 | [壁](entries/1509/1509290-kabe.org) | かべ | kabe | 1509290 | learner | draft | **new** | Editorial review |
| N4-101 | [髪](entries/1477/1477950-kami.org) | かみ | kami | 1477950 | learner | draft | **new** | Editorial review |
| N4-102 | [噛む](entries/1209/1209240-kamu.org) | かむ | kamu | 1209240 | learner | draft | **new** | Editorial review |
| N4-103 | [通う](entries/1432/1432850-kayou.org) | かよう | kayou | 1432850 | learner | draft | **new** | Editorial review |
| N4-104 | [乾く](entries/1209/1209650-kawaku.org) | かわく | kawaku | 1209650 | learner | draft | **new** | Editorial review |
| N4-105 | [代わり](entries/1590/1590770-kawari.org) | かわり | kawari | 1590770 | learner | draft | **new** | Editorial review |
| N4-106 | [変わる](entries/1510/1510790-kawaru.org) | かわる | kawaru | 1510790 | learner | draft | **new** | Editorial review |
| N4-107 | [考える](entries/1281/1281020-kangaeru.org) | かんがえる | kangaeru | 1281020 | learner | draft | **new** | Editorial review |
| N4-108 | [関係](entries/1215/1215810-kankei.org) | かんけい | kankei | 1215810 | learner | draft | **new** | Editorial review |
| N4-109 | [簡単](entries/1214/1214330-kantan.org) | かんたん | kantan | 1214330 | learner | draft | **new** | Editorial review |
| N4-110 | [気](entries/1221/1221520-ki.org) | き | ki | 1221520 | learner | draft | **new** | Editorial review |
| N4-111 | [機会](entries/1220/1220800-kikai.org) | きかい | kikai | 1220800 | learner | draft | **new** | Editorial review |
| N4-305 | [妻](entries/1294/1294330-tsuma.org) | つま | tsuma | 1294330 | learner | draft | **new** | Editorial review |
| N4-413 | [参る](entries/1302/1302070-mairu.org) | まいる | mairu | 1302070 | learner | draft | **new** | Editorial review |
| N4-414 | [負ける](entries/1497/1497980-makeru.org) | まける | makeru | 1497980 | learner | draft | **new** | Editorial review |
| N4-415 | [又は](entries/1524/1524990-mataha.org) | または | mataha | 1524990 | learner | draft | **new** | Editorial review |
| N4-416 | [間違える](entries/1215/1215330-machigaeru.org) | まちがえる | machigaeru | 1215330 | learner | draft | **new** | Editorial review |
| N4-417 | [間に合う](entries/1215/1215260-maniau.org) | まにあう | maniau | 1215260 | learner | draft | **new** | Editorial review |
| N4-418 | [周り](entries/1604/1604290-mawari.org) | まわり | mawari | 1604290 | learner | draft | **new** | Editorial review |
| N4-419 | [漫画](entries/1526/1526920-manga.org) | まんが | manga | 1526920 | learner | draft | **new** | Editorial review |
| N4-420 | [見える](entries/1259/1259140-mieru.org) | みえる | mieru | 1259140 | learner | draft | **new** | Editorial review |
| N4-421 | [湖](entries/1267/1267280-mizuumi.org) | みずうみ | mizuumi | 1267280 | learner | draft | **new** | Editorial review |
| N4-422 | [味噌](entries/1527/1527040-miso.org) | みそ | miso | 1527040 | learner | draft | **new** | Editorial review |
| N4-423 | [見つかる](entries/1604/1604550-mitsukaru.org) | みつかる | mitsukaru | 1604550 | learner | draft | **new** | Editorial review |
| N4-424 | [見つける](entries/1604/1604570-mitsukeru.org) | みつける | mitsukeru | 1604570 | learner | draft | **new** | Editorial review |
| N4-425 | [港](entries/1279/1279990-minato.org) | みなと | minato | 1279990 | learner | draft | **new** | Editorial review |
| N4-426 | [向かう](entries/1604/1604800-mukau.org) | むかう | mukau | 1604800 | learner | draft | **new** | Editorial review |
| N4-427 | [迎える](entries/1253/1253190-mukaeru.org) | むかえる | mukaeru | 1253190 | learner | draft | **new** | Editorial review |
| N4-428 | [昔](entries/1382/1382370-mukashi.org) | むかし | mukashi | 1382370 | learner | draft | **new** | Editorial review |
| N4-429 | [虫](entries/1426/1426680-mushi.org) | むし | mushi | 1426680 | learner | draft | **new** | Editorial review |
| N4-430 | [息子](entries/1404/1404390-musuko.org) | むすこ | musuko | 1404390 | learner | draft | **new** | Editorial review |
| N4-431 | [無理](entries/1530/1530970-muri.org) | むり | muri | 1530970 | learner | draft | **new** | Editorial review |
| N4-432 | [召し上がる](entries/1346/1346370-meshiagaru.org) | めしあがる | meshiagaru | 1346370 | learner | draft | **new** | Editorial review |
| N4-433 | [珍しい](entries/1431/1431850-mezurashii.org) | めずらしい | mezurashii | 1431850 | learner | draft | **new** | Editorial review |
| N4-434 | [申し上げる](entries/1362/1362950-moushiageru.org) | もうしあげる | moushiageru | 1362950 | learner | draft | **new** | Editorial review |
| N4-435 | [申す](entries/1363/1363090-mousu.org) | もうす | mousu | 1363090 | learner | draft | **new** | Editorial review |
| N4-436 | [もう直ぐ](entries/2015/2015610-mousugu.org) | もうすぐ | mousugu | 2015610 | learner | draft | **new** | Editorial review |
| N4-437 | [若し](entries/1012/1012500-moshi.org) | もし | moshi | 1012500 | learner | draft | **new** | Editorial review |
| N4-438 | [戻る](entries/1535/1535880-modoru.org) | もどる | modoru | 1535880 | learner | draft | **new** | Editorial review |
| N4-439 | [木綿](entries/1534/1534870-momen.org) | もめん | momen | 1534870 | learner | draft | **new** | Editorial review |
| N4-440 | [森](entries/1362/1362490-mori.org) | もり | mori | 1362490 | learner | draft | **new** | Editorial review |
| N4-441 | [焼く](entries/1350/1350600-yaku.org) | やく | yaku | 1350600 | learner | draft | **new** | Editorial review |
| N4-442 | [約束](entries/1538/1538130-yakusoku.org) | やくそく | yakusoku | 1538130 | learner | draft | **new** | Editorial review |
| N4-443 | [役に立つ](entries/1537/1537980-yakunitatsu.org) | やくにたつ | yakunitatsu | 1537980 | learner | draft | **new** | Editorial review |
| N4-444 | [焼ける](entries/1350/1350610-yakeru.org) | やける | yakeru | 1350610 | learner | draft | **new** | Editorial review |
| N4-445 | [優しい](entries/1539/1539040-yasashii.org) | やさしい | yasashii | 1539040 | learner | draft | **new** | Editorial review |
| N4-446 | [痩せる](entries/1605/1605510-yaseru.org) | やせる | yaseru | 1605510 | learner | draft | **new** | Editorial review |
| N4-447 | [漸と](entries/1012/1012800-yatto.org) | やっと | yatto | 1012800 | learner | draft | **new** | Editorial review |
| N4-448 | [止む](entries/1310/1310640-yamu.org) | やむ | yamu | 1310640 | learner | draft | **new** | Editorial review |
| N4-449 | [柔らかい](entries/1605/1605630-yawarakai.org) | やわらかい | yawarakai | 1605630 | learner | draft | **new** | Editorial review |
| N4-450 | [湯](entries/1448/1448580-yu.org) | ゆ | yu | 1448580 | learner | draft | **new** | Editorial review |
| N4-451 | [指](entries/1309/1309650-yubi.org) | ゆび | yubi | 1309650 | learner | draft | **new** | Editorial review |
| N4-452 | [指輪](entries/1310/1310050-yubiwa.org) | ゆびわ | yubiwa | 1310050 | learner | draft | **new** | Editorial review |
| N4-453 | [夢](entries/1529/1529410-yume.org) | ゆめ | yume | 1529410 | learner | draft | **new** | Editorial review |
| N4-454 | [揺れる](entries/1545/1545710-yureru.org) | ゆれる | yureru | 1545710 | learner | draft | **new** | Editorial review |
| N4-455 | [用](entries/1546/1546200-you.org) | よう | you | 1546200 | learner | draft | **new** | Editorial review |
| N4-456 | [用意](entries/1546/1546220-youi.org) | ようい | youi | 1546220 | learner | draft | **new** | Editorial review |
| N4-457 | [用事](entries/1546/1546300-youji.org) | ようじ | youji | 1546300 | learner | draft | **new** | Editorial review |
| N4-458 | [予習](entries/1543/1543070-yoshuu.org) | よしゅう | yoshuu | 1543070 | learner | draft | **new** | Editorial review |
| N4-459 | [予定](entries/1543/1543240-yotei.org) | よてい | yotei | 1543240 | learner | draft | **new** | Editorial review |
| N4-460 | [予約](entries/1543/1543750-yoyaku.org) | よやく | yoyaku | 1543750 | learner | draft | **new** | Editorial review |
| N4-461 | [寄る](entries/1219/1219680-yoru.org) | よる | yoru | 1219680 | learner | draft | **new** | Editorial review |
| N4-462 | [喜ぶ](entries/1218/1218760-yorokobu.org) | よろこぶ | yorokobu | 1218760 | learner | draft | **new** | Editorial review |
| N4-463 | [理由](entries/1550/1550140-riyuu.org) | りゆう | riyuu | 1550140 | learner | draft | **new** | Editorial review |
| N4-464 | [両方](entries/1554/1554010-ryouhou.org) | りょうほう | ryouhou | 1554010 | learner | draft | **new** | Editorial review |
| N4-465 | [旅館](entries/1553/1553130-ryokan.org) | りょかん | ryokan | 1553130 | learner | draft | **new** | Editorial review |
| N4-466 | [利用](entries/1549/1549660-riyou.org) | りよう | riyou | 1549660 | learner | draft | **new** | Editorial review |
| N4-467 | [留守](entries/1552/1552760-rusu.org) | るす | rusu | 1552760 | learner | draft | **new** | Editorial review |
| N4-468 | [冷房](entries/1557/1557290-reibou.org) | れいぼう | reibou | 1557290 | learner | draft | **new** | Editorial review |
| N4-469 | [歴史](entries/1558/1558050-rekishi.org) | れきし | rekishi | 1558050 | learner | draft | **new** | Editorial review |
| N4-470 | [連絡](entries/1559/1559900-renraku.org) | れんらく | renraku | 1559900 | learner | draft | **new** | Editorial review |
| N4-471 | [沸かす](entries/1501/1501660-wakasu.org) | わかす | wakasu | 1501660 | learner | draft | **new** | Editorial review |
| N4-472 | [別れる](entries/1606/1606590-wakareru.org) | わかれる | wakareru | 1606590 | learner | draft | **new** | Editorial review |
| N4-473 | [沸く](entries/1606/1606680-waku.org) | わく | waku | 1606680 | learner | draft | **new** | Editorial review |
| N4-474 | [訳](entries/1538/1538330-wake.org) | わけ | wake | 1538330 | learner | draft | **new** | Editorial review |
| N4-475 | [忘れ物](entries/1519/1519230-wasuremono.org) | わすれもの | wasuremono | 1519230 | learner | draft | **new** | Editorial review |
| N4-476 | [笑う](entries/1351/1351360-warau.org) | わらう | warau | 1351360 | learner | draft | **new** | Editorial review |
| N4-477 | [割合](entries/1606/1606810-wariai.org) | わりあい | wariai | 1606810 | learner | draft | **new** | Editorial review |
| N4-478 | [割れる](entries/1208/1208020-wareru.org) | われる | wareru | 1208020 | learner | draft | **new** | Editorial review |
| N4-479 | [亜細亜](entries/1015/1015840-ajia.org) | アジア | ajia | 1015840 | learner | draft | **new** | Editorial review |
| N4-480 | [阿弗利加](entries/1929/1929050-afurika.org) | アフリカ | afurika | 1929050 | learner | draft | **new** | Editorial review |
| N4-481 | [亜米利加](entries/1149/1149830-amerika.org) | アメリカ | amerika | 1149830 | learner | draft | **new** | Editorial review |
| N4-482 | [瓦斯](entries/1040/1040060-gasu.org) | ガス | gasu | 1040060 | learner | draft | **new** | Editorial review |
| N4-483 | [硝子](entries/1040/1040380-garasu.org) | ガラス | garasu | 1040380 | learner | draft | **new** | Editorial review |
| N4-484 | [ＦＡＸ](entries/1108/1108180-fakkusu.org) | ファックス | fakkusu | 1108180 | learner | draft | **new** | Editorial review |
| N4-485 | [あんな](entries/1000/1000590-anna.org) | あんな | anna | 1000590 | learner | draft | **new** | Editorial review |
| N4-486 | [一杯](entries/1165/1165670-ippai.org) | いっぱい | ippai | 1165670 | learner | draft | **new** | Editorial review |
| N4-487 | [居らっしゃる](entries/1000/1000940-irassharu.org) | いらっしゃる | irassharu | 1000940 | learner | draft | **new** | Editorial review |
| N4-488 | [裏](entries/1550/1550190-ura.org) | うら | ura | 1550190 | learner | draft | **new** | Editorial review |
| N4-489 | [うん](entries/1001/1001090-un.org) | うん | un | 1001090 | learner | draft | **new** | Editorial review |
| N4-490 | [贈り物](entries/1589/1589030-okurimono.org) | おくりもの | okurimono | 1589030 | learner | draft | **new** | Editorial review |
| N4-491 | [彼](entries/1483/1483070-kare.org) | かれ | kare | 1483070 | learner | draft | **new** | Editorial review |
| N4-492 | [君](entries/1247/1247260-kun.org) | くん | kun | 1247260 | learner | draft | **new** | Editorial review |
| N4-493 | [米](entries/1508/1508750-kome.org) | こめ | kome | 1508750 | learner | draft | **new** | Editorial review |
| N4-494 | [市](entries/1308/1308090-shi.org) | し | shi | 1308090 | learner | draft | **new** | Editorial review |
| N4-495 | [字](entries/1315/1315130-ji.org) | じ | ji | 1315130 | learner | draft | **new** | Editorial review |
| N4-496 | [十分](entries/1335/1335080-juubun.org) | じゅうぶん | juubun | 1335080 | learner | draft | **new** | Editorial review |
| N4-497 | [すっかり](entries/1006/1006110-sukkari.org) | すっかり | sukkari | 1006110 | learner | draft | **new** | Editorial review |
| N4-498 | [すっと](entries/1006/1006140-sutto.org) | すっと | sutto | 1006140 | learner | draft | **new** | Editorial review |
| N4-499 | [すると](entries/1006/1006280-suruto.org) | すると | suruto | 1006280 | learner | draft | **new** | Editorial review |
| N4-500 | [そろそろ](entries/1345/1345605-sorosoro.org) | そろそろ | sorosoro | 1345605 | learner | draft | **new** | Editorial review |
| N4-501 | [そんな](entries/1007/1007130-sonna.org) | そんな | sonna | 1007130 | learner | draft | **new** | Editorial review |
| N4-502 | [そんなに](entries/2008/2008740-sonnani.org) | そんなに | sonnani | 2008740 | learner | draft | **new** | Editorial review |
| N4-503 | [畳](entries/1356/1356750-tatami.org) | たたみ | tatami | 1356750 | learner | draft | **new** | Editorial review |
| N4-504 | [だから](entries/1007/1007310-dakara.org) | だから | dakara | 1007310 | learner | draft | **new** | Editorial review |
| N4-505 | [ちゃん](entries/1007/1007660-chan.org) | ちゃん | chan | 1007660 | learner | draft | **new** | Editorial review |
| N4-506 | [点](entries/1441/1441390-ten.org) | てん | ten | 1441390 | learner | draft | **new** | Editorial review |
| N4-507 | [都](entries/1621/1621470-to.org) | と | to | 1621470 | learner | draft | **new** | Editorial review |
| N4-508 | [到頭](entries/1449/1449890-toutou.org) | とうとう | toutou | 1449890 | learner | draft | **new** | Editorial review |
| N4-509 | [どんどん](entries/1009/1009320-dondon.org) | どんどん | dondon | 1009320 | learner | draft | **new** | Editorial review |
| N4-510 | [直す](entries/1599/1599390-naosu.org) | なおす | naosu | 1599390 | learner | draft | **new** | Editorial review |
| N4-511 | [はっきり](entries/1010/1010150-hakkiri.org) | はっきり | hakkiri | 1010150 | learner | draft | **new** | Editorial review |
| N4-512 | [火](entries/1193/1193610-hi.org) | ひ | hi | 1193610 | learner | draft | **new** | Editorial review |
| N4-513 | [日](entries/1463/1463770-hi.org) | ひ | hi | 1463770 | learner | draft | **new** | Editorial review |
| N4-514 | [酷い](entries/1602/1602060-hidoi.org) | ひどい | hidoi | 1602060 | learner | draft | **new** | Editorial review |
| N4-515 | [僕](entries/1521/1521400-boku.org) | ぼく | boku | 1521400 | learner | draft | **new** | Editorial review |
| N4-516 | [回る](entries/1604/1604300-mawaru.org) | まわる | mawaru | 1604300 | learner | draft | **new** | Editorial review |
| N4-517 | [娘](entries/1531/1531190-musume.org) | むすめ | musume | 1531190 | learner | draft | **new** | Editorial review |
| N4-518 | [止める](entries/1310/1310680-yameru.org) | やめる | yameru | 1310680 | learner | draft | **new** | Editorial review |
| N4-519 | [汚れる](entries/1179/1179005-yogoreru.org) | よごれる | yogoreru | 1179005 | learner | draft | **new** | Editorial review |
| N4-520 | [アクセサリー](entries/1015/1015220-akusesarii.org) | アクセサリー | akusesarii | 1015220 | learner | draft | **new** | Editorial review |
| N4-521 | [アナウンサー](entries/1017/1017330-anaunsaa.org) | アナウンサー | anaunsaa | 1017330 | learner | draft | **new** | Editorial review |
| N4-522 | [アルコール](entries/1019/1019280-arukooru.org) | アルコール | arukooru | 1019280 | learner | draft | **new** | Editorial review |
| N4-523 | [アルバイト](entries/1019/1019420-arubaito.org) | アルバイト | arubaito | 1019420 | learner | draft | **new** | Editorial review |
| N4-524 | [エスカレーター](entries/1028/1028580-esukareetaa.org) | エスカレーター | esukareetaa | 1028580 | learner | draft | **new** | Editorial review |
| N4-525 | [オートバイ](entries/1032/1032030-ootobai.org) | オートバイ | ootobai | 1032030 | learner | draft | **new** | Editorial review |
| N4-526 | [カーテン](entries/1036/1036290-kaaten.org) | カーテン | kaaten | 1036290 | learner | draft | **new** | Editorial review |
| N4-527 | [ガソリン](entries/1040/1040250-gasorin.org) | ガソリン | gasorin | 1040250 | learner | draft | **new** | Editorial review |
| N4-528 | [ガソリンスタンド](entries/1040/1040260-gasorinsutando.org) | ガソリンスタンド | gasorinsutando | 1040260 | learner | draft | **new** | Editorial review |
| N4-529 | [ケーキ](entries/1047/1047860-keeki.org) | ケーキ | keeki | 1047860 | learner | draft | **new** | Editorial review |
| N4-530 | [コンサート](entries/1051/1051970-konsaato.org) | コンサート | konsaato | 1051970 | learner | draft | **new** | Editorial review |
| N4-531 | [コンピュータ](entries/1053/1053350-konpyuuta.org) | コンピュータ | konpyuuta | 1053350 | learner | draft | **new** | Editorial review |
| N4-532 | [サラダ](entries/1057/1057850-sarada.org) | サラダ | sarada | 1057850 | learner | draft | **new** | Editorial review |
| N4-533 | [サンダル](entries/1058/1058480-sandaru.org) | サンダル | sandaru | 1058480 | learner | draft | **new** | Editorial review |
| N4-534 | [サンドイッチ](entries/1058/1058580-sandoitchi.org) | サンドイッチ | sandoitchi | 1058580 | learner | draft | **new** | Editorial review |
| N4-535 | [ジャム](entries/1065/1065680-jamu.org) | ジャム | jamu | 1065680 | learner | draft | **new** | Editorial review |
| N4-536 | [スクリーン](entries/1068/1068550-sukuriin.org) | スクリーン | sukuriin | 1068550 | learner | draft | **new** | Editorial review |
| N4-537 | [ステレオ](entries/1070/1070650-sutereo.org) | ステレオ | sutereo | 1070650 | learner | draft | **new** | Editorial review |
| N4-538 | [ステーキ](entries/1070/1070280-suteeki.org) | ステーキ | suteeki | 1070280 | learner | draft | **new** | Editorial review |
| N4-539 | [スーツ](entries/1066/1066680-suutsu.org) | スーツ | suutsu | 1066680 | learner | draft | **new** | Editorial review |
| N4-540 | [スーツケース](entries/1066/1066690-suutsukeesu.org) | スーツケース | suutsukeesu | 1066690 | learner | draft | **new** | Editorial review |
| N4-541 | [ソフト](entries/1075/1075500-sofuto.org) | ソフト | sofuto | 1075500 | learner | draft | **new** | Editorial review |
| N4-542 | [タイプ](entries/1075/1075940-taipu.org) | タイプ | taipu | 1075940 | learner | draft | **new** | Editorial review |
| N4-543 | [チェック](entries/1077/1077550-chekku.org) | チェック | chekku | 1077550 | learner | draft | **new** | Editorial review |
| N4-544 | [テキスト](entries/1079/1079290-tekisuto.org) | テキスト | tekisuto | 1079290 | learner | draft | **new** | Editorial review |
| N4-545 | [テニス](entries/1080/1080000-tenisu.org) | テニス | tenisu | 1080000 | learner | draft | **new** | Editorial review |
| N4-546 | [パソコン](entries/1101/1101570-pasokon.org) | パソコン | pasokon | 1101570 | learner | draft | **new** | Editorial review |
| N4-547 | [パート](entries/1100/1100810-paato.org) | パート | paato | 1100810 | learner | draft | **new** | Editorial review |
| N4-548 | [ビル](entries/1106/1106010-biru.org) | ビル | biru | 1106010 | learner | draft | **new** | Editorial review |
| N4-549 | [ピアノ](entries/1106/1106400-piano.org) | ピアノ | piano | 1106400 | learner | draft | **new** | Editorial review |
| N4-550 | [プレゼント](entries/1116/1116840-purezento.org) | プレゼント | purezento | 1116840 | learner | draft | **new** | Editorial review |
| N4-551 | [ベル](entries/1120/1120010-beru.org) | ベル | beru | 1120010 | learner | draft | **new** | Editorial review |
| N4-552 | [レジ](entries/1145/1145130-reji.org) | レジ | reji | 1145130 | learner | draft | **new** | Editorial review |
| N4-553 | [レポート](entries/1145/1145990-repooto.org) | レポート | repooto | 1145990 | learner | draft | **new** | Editorial review |
| N4-554 | [ワープロ](entries/1148/1148520-waapuro.org) | ワープロ | waapuro | 1148520 | learner | draft | **new** | Editorial review |
| N4-555 | [挨拶](entries/1151/1151120-aisatsu.org) | 挨拶 | aisatsu | 1151120 | learner | draft | **new** | Editorial review |
| N4-559 | [案内](entries/1154/1154860-annai.org) | 案内 | annai | 1154860 | learner | draft | **new** | Editorial review |
| N4-560 | [頂く](entries/1587/1587290-itadaku.org) | 頂く | itadaku | 1587290 | learner | draft | **new** | Editorial review |
| N4-561 | [員](entries/1168/1168610-in.org) | いん | in | 1168610 | learner | draft | **new** | Editorial review |
| N4-562 | [伺う](entries/1305/1305700-ukagau.org) | うかがう | ukagau | 1305700 | learner | draft | **new** | Editorial review |
| N4-563 | [嘘](entries/1172/1172400-uso.org) | うそ | uso | 1172400 | learner | draft | **new** | Editorial review |
| N4-564 | [上手い](entries/1310/1310460-umai.org) | うまい | umai | 1310460 | learner | draft | **new** | Editorial review |
| N4-565 | [嬉しい](entries/1219/1219510-ureshii.org) | うれしい | ureshii | 1219510 | learner | draft | **new** | Editorial review |
| N4-566 | [運転](entries/1172/1172830-unten.org) | うんてん | unten | 1172830 | learner | draft | **new** | Editorial review |
| N4-567 | [運動](entries/1172/1172910-undou.org) | うんどう | undou | 1172910 | learner | draft | **new** | Editorial review |
| N4-568 | [お子さん](entries/1002/1002000-okosan.org) | おこさん | okosan | 1002000 | learner | draft | **new** | Editorial review |
| N4-569 | [泳ぎ方](entries/2005/2005990-oyogikata.org) | およぎかた | oyogikata | 2005990 | learner | draft | **new** | Editorial review |
| N4-571 | [家](entries/2220/2220280-ka.org) | か | ka | 2220280 | learner | draft | **new** | Editorial review |
| N4-572 | [会](entries/1198/1198170-kai.org) | かい | kai | 1198170 | learner | draft | **new** | Editorial review |
| N4-573 | [構う](entries/1279/1279680-kamau.org) | かまう | kamau | 1279680 | learner | draft | **new** | Editorial review |
| N4-574 | [彼ら](entries/1483/1483090-karera.org) | かれら | karera | 1483090 | learner | draft | **new** | Editorial review |
| N4-575 | [看護師](entries/1928/1928100-kangoshi.org) | かんごし | kangoshi | 1928100 | learner | draft | **new** | Editorial review |
| N4-576 | [看護婦](entries/1213/1213870-kangofu.org) | かんごふ | kangofu | 1213870 | learner | draft | **new** | Editorial review |
| N4-577 | [学部](entries/1207/1207080-gakubu.org) | がくぶ | gakubu | 1207080 | learner | draft | **new** | Editorial review |
| N4-578 | [頑張る](entries/1217/1217700-ganbaru.org) | がんばる | ganbaru | 1217700 | learner | draft | **new** | Editorial review |
| N4-579 | [規則](entries/1223/1223021-kisoku.org) | きそく | kisoku | 1223021 | learner | draft | **new** | Editorial review |
| N4-580 | [区](entries/1244/1244080-ku.org) | く | ku | 1244080 | learner | draft | **new** | Editorial review |
| N4-581 | [下さる](entries/1184/1184280-kudasaru.org) | くださる | kudasaru | 1184280 | learner | draft | **new** | Editorial review |
| N4-582 | [計画](entries/1252/1252090-keikaku.org) | けいかく | keikaku | 1252090 | learner | draft | **new** | Editorial review |
| N4-583 | [経験](entries/1251/1251270-keiken.org) | けいけん | keiken | 1251270 | learner | draft | **new** | Editorial review |
| N4-584 | [怪我](entries/1200/1200220-kega.org) | けが | kega | 1200220 | learner | draft | **new** | Editorial review |
| N4-585 | [軒](entries/2078/2078590-ken.org) | けん | ken | 2078590 | learner | draft | **new** | Editorial review |
| N4-586 | [高等学校](entries/1283/1283860-koutougakkou.org) | こうとうがっこう | koutougakkou | 1283860 | learner | draft | **new** | Editorial review |
| N4-587 | [事](entries/1313/1313580-koto.org) | こと | koto | 1313580 | learner | draft | **new** | Editorial review |
| N4-588 | [御座います](entries/1612/1612690-gozaimasu.org) | ございます | gozaimasu | 1612690 | learner | draft | **new** | Editorial review |
| N4-589 | [様](entries/1545/1545790-sama.org) | さま | sama | 1545790 | learner | draft | **new** | Editorial review |
| N4-590 | [叱る](entries/1319/1319580-shikaru.org) | しかる | shikaru | 1319580 | learner | draft | **new** | Editorial review |
| N4-591 | [式](entries/1319/1319060-shiki.org) | しき | shiki | 1319060 | learner | draft | **new** | Editorial review |
| N4-592 | [支度](entries/1310/1310260-shitaku.org) | したく | shitaku | 1310260 | learner | draft | **new** | Editorial review |
| N4-593 | [失礼](entries/1320/1320230-shitsurei.org) | しつれい | shitsurei | 1320230 | learner | draft | **new** | Editorial review |
| N4-594 | [仕舞う](entries/1305/1305380-shimau.org) | しまう | shimau | 1305380 | learner | draft | **new** | Editorial review |
| N4-595 | [出席](entries/1339/1339460-shusseki.org) | しゅっせき | shusseki | 1339460 | learner | draft | **new** | Editorial review |
| N4-596 | [出発](entries/1340/1340000-shuppatsu.org) | しゅっぱつ | shuppatsu | 1340000 | learner | draft | **new** | Editorial review |
| N4-597 | [正月](entries/1377/1377030-shougatsu.org) | しょうがつ | shougatsu | 1377030 | learner | draft | **new** | Editorial review |
| N4-598 | [招待](entries/1349/1349610-shoutai.org) | しょうたい | shoutai | 1349610 | learner | draft | **new** | Editorial review |
| N4-599 | [承知](entries/1349/1349480-shouchi.org) | しょうち | shouchi | 1349480 | learner | draft | **new** | Editorial review |
| N4-600 | [食事](entries/1358/1358490-shokuji.org) | しょくじ | shokuji | 1358490 | learner | draft | **new** | Editorial review |
| N4-601 | [心配](entries/1360/1360930-shinpai.org) | しんぱい | shinpai | 1360930 | learner | draft | **new** | Editorial review |
| N4-602 | [邪魔](entries/1323/1323500-jama.org) | じゃま | jama | 1323500 | learner | draft | **new** | Editorial review |
| N4-603 | [準備](entries/1341/1341670-junbi.org) | じゅんび | junbi | 1341670 | learner | draft | **new** | Editorial review |
| N4-604 | [空く](entries/1586/1586265-suku.org) | すく | suku | 1586265 | learner | draft | **new** | Editorial review |
| N4-605 | [素晴らしい](entries/1397/1397300-subarashii.org) | すばらしい | subarashii | 1397300 | learner | draft | **new** | Editorial review |
| N4-606 | [掏摸](entries/1567/1567450-suri.org) | すり | suri | 1567450 | learner | draft | **new** | Editorial review |
| N4-607 | [随分](entries/1372/1372800-zuibun.org) | ずいぶん | zuibun | 1372800 | learner | draft | **new** | Editorial review |
| N4-608 | [製](entries/1380/1380580-sei.org) | せい | sei | 1380580 | learner | draft | **new** | Editorial review |
| N4-609 | [世話](entries/1374/1374300-sewa.org) | せわ | sewa | 1374300 | learner | draft | **new** | Editorial review |
| N4-610 | [専門](entries/1389/1389880-senmon.org) | せんもん | senmon | 1389880 | learner | draft | **new** | Editorial review |
| N4-611 | [是非](entries/1374/1374530-zehi.org) | ぜひ | zehi | 1374530 | learner | draft | **new** | Editorial review |
| N4-612 | [全然](entries/1395/1395620-zenzen.org) | ぜんぜん | zenzen | 1395620 | learner | draft | **new** | Editorial review |
| N4-613 | [そう](entries/1006/1006610-sou.org) | そう | sou | 1006610 | learner | draft | **new** | Editorial review |
| N4-614 | [相談](entries/1401/1401210-soudan.org) | そうだん | soudan | 1401210 | learner | draft | **new** | Editorial review |
| N4-615 | [代](entries/1982/1982860-dai.org) | だい | dai | 1982860 | learner | draft | **new** | Editorial review |
| N4-616 | [駄目](entries/1409/1409110-dame.org) | だめ | dame | 1409110 | learner | draft | **new** | Editorial review |
| N4-617 | [月](entries/1255/1255430-tsuki.org) | つき | tsuki | 1255430 | learner | draft | **new** | Editorial review |
| N4-618 | [点く](entries/1441/1441400-tsuku.org) | つく | tsuku | 1441400 | learner | draft | **new** | Editorial review |
| N4-619 | [連れる](entries/1559/1559290-tsureru.org) | つれる | tsureru | 1559290 | learner | draft | **new** | Editorial review |
| N4-620 | [出来るだけ](entries/1340/1340460-dekirudake.org) | できるだけ | dekirudake | 1340460 | learner | draft | **new** | Editorial review |
| N4-621 | [通り](entries/1432/1432920-toori.org) | とおり | toori | 1432920 | learner | draft | **new** | Editorial review |
| N4-622 | [中々](entries/1599/1599420-nakanaka.org) | なかなか | nakanaka | 1599420 | learner | draft | **new** | Editorial review |
| N4-623 | [匂い](entries/1599/1599760-nioi.org) | におい | nioi | 1599760 | learner | draft | **new** | Editorial review |
| N4-624 | [二階建て](entries/1599/1599800-nikaidate.org) | にかいだて | nikaidate | 1599800 | learner | draft | **new** | Editorial review |
| N4-625 | [熱心](entries/1467/1467910-nesshin.org) | ねっしん | nesshin | 1467910 | learner | draft | **new** | Editorial review |
| N4-626 | [喉](entries/1600/1600280-nodo.org) | のど | nodo | 1600280 | learner | draft | **new** | Editorial review |
| N4-627 | [許り](entries/1010/1010240-bakari.org) | ばかり | bakari | 1010240 | learner | draft | **new** | Editorial review |
| N4-628 | [引き出す](entries/1601/1601660-hikidasu.org) | ひきだす | hikidasu | 1601660 | learner | draft | **new** | Editorial review |
| N4-629 | [髭](entries/1601/1601810-hige.org) | ひげ | hige | 1601810 | learner | draft | **new** | Editorial review |
| N4-630 | [吃驚](entries/1226/1226360-bikkuri.org) | びっくり | bikkuri | 1226360 | learner | draft | **new** | Editorial review |
| N4-631 | [降り出す](entries/1282/1282770-furidasu.org) | ふりだす | furidasu | 1282770 | learner | draft | **new** | Editorial review |
| N4-632 | [葡萄](entries/1499/1499230-budou.org) | ぶどう | budou | 1499230 | learner | draft | **new** | Editorial review |
| N4-633 | [放送](entries/1516/1516750-housou.org) | ほうそう | housou | 1516750 | learner | draft | **new** | Editorial review |
| N4-634 | [程](entries/1436/1436510-hodo.org) | ほど | hodo | 1436510 | learner | draft | **new** | Editorial review |
| N4-635 | [真面目](entries/1364/1364360-majime.org) | まじめ | majime | 1364360 | learner | draft | **new** | Editorial review |
| N4-636 | [先ず](entries/1387/1387240-mazu.org) | まず | mazu | 1387240 | learner | draft | **new** | Editorial review |
| N4-637 | [儘](entries/1585/1585410-mama.org) | まま | mama | 1585410 | learner | draft | **new** | Editorial review |
| N4-638 | [真ん中](entries/1604/1604350-mannaka.org) | まんなか | mannaka | 1604350 | learner | draft | **new** | Editorial review |
| N4-640 | [勿論](entries/1535/1535780-mochiron.org) | もちろん | mochiron | 1535780 | learner | draft | **new** | Editorial review |
| N4-641 | [最も](entries/1293/1293700-mottomo.org) | もっとも | mottomo | 1293700 | learner | draft | **new** | Editorial review |
| N4-642 | [貰う](entries/1535/1535910-morau.org) | もらう | morau | 1535910 | learner | draft | **new** | Editorial review |
| N4-643 | [輸出](entries/1538/1538820-yushutsu.org) | ゆしゅつ | yushutsu | 1538820 | learner | draft | **new** | Editorial review |
| N4-644 | [輸入](entries/1538/1538870-yunyuu.org) | ゆにゅう | yunyuu | 1538870 | learner | draft | **new** | Editorial review |
| N4-645 | [様](entries/1605/1605840-you.org) | よう | you | 1605840 | learner | draft | **new** | Editorial review |
| N4-646 | [宜しい](entries/1224/1224880-yoroshii.org) | よろしい | yoroshii | 1224880 | learner | draft | **new** | Editorial review |
| N4-647 | [オーバー](entries/1032/1032390-oobaa.org) | オーバー | oobaa | 1032390 | learner | draft | **new** | Editorial review |
| N4-648 | [塵](entries/1369/1369900-gomi.org) | ごみ | gomi | 1369900 | learner | draft | **new** | Editorial review |
| N4-649 | [スーパー](entries/1066/1066710-suupaa.org) | スーパー | suupaa | 1066710 | learner | draft | **new** | Editorial review |
| N4-650 | [ハンバーグ](entries/1096/1096870-hanbaagu.org) | ハンバーグ | hanbaagu | 1096870 | learner | draft | **new** | Editorial review |
| N4-651 | [パパ](entries/1102/1102140-papa.org) | パパ | papa | 1102140 | learner | draft | **new** | Editorial review |
| N4-652 | [あっ](entries/2394/2394370-a.org) | あっ | a | 2394370 | learner | draft | **new** | Editorial review |
| N4-653 | [窺う](entries/1172/1172230-ukagau.org) | うかがう | ukagau | 1172230 | learner | draft | **new** | Editorial review |
| N4-654 | [お金持ち](entries/2429/2429350-okanemochi.org) | おかねもち | okanemochi | 2429350 | learner | draft | **new** | Editorial review |
| N4-655 | [沖](entries/1182/1182500-oki.org) | おき | oki | 1182500 | learner | draft | **new** | Editorial review |
| N4-656 | [唖](entries/1149/1149990-oshi.org) | おし | oshi | 1149990 | learner | draft | **new** | Editorial review |
| N4-657 | [織る](entries/1357/1357420-oru.org) | おる | oru | 1357420 | learner | draft | **new** | Editorial review |
| N4-659 | [格好](entries/1590/1590480-kakkou.org) | かっこう | kakkou | 1590480 | learner | draft | **new** | Editorial review |
| N4-660 | [けど](entries/1004/1004200-kedo.org) | けど | kedo | 1004200 | learner | draft | **new** | Editorial review |
| N4-661 | [けれど](entries/2853/2853889-keredo.org) | けれど | keredo | 2853889 | learner | draft | **new** | Editorial review |
| N4-662 | [御](entries/1270/1270190-go.org) | ご | go | 1270190 | learner | draft | **new** | Editorial review |
| N4-663 | [修理](entries/1332/1332400-shuuri.org) | しゅうり | shuuri | 1332400 | learner | draft | **new** | Editorial review |
| N4-665 | [建て](entries/2609/2609780-date.org) | だて | date | 2609780 | learner | draft | **new** | Editorial review |
| N4-666 | [町](entries/2853/2853569-chou.org) | ちょう | chou | 2853569 | learner | draft | **new** | Editorial review |
| N4-667 | [付く](entries/1495/1495740-tsuku.org) | つく | tsuku | 1495740 | learner | draft | **new** | Editorial review |
| N4-668 | [直る](entries/2846/2846390-naoru.org) | なおる | naoru | 2846390 | learner | draft | **new** | Editorial review |
| N4-669 | [憎い](entries/1403/1403390-nikui.org) | にくい | nikui | 1403390 | learner | draft | **new** | Editorial review |
| N4-670 | [卑下](entries/1482/1482700-hige.org) | ひげ | hige | 1482700 | learner | draft | **new** | Editorial review |
| N4-671 | [武道](entries/1498/1498880-budou.org) | ぶどう | budou | 1498880 | learner | draft | **new** | Editorial review |
| N4-672 | [真中](entries/2838/2838012-manaka.org) | まなか | manaka | 2838012 | learner | draft | **new** | Editorial review |
| N4-675 | [矢張り](entries/2772/2772770-yahari.org) | やはり | yahari | 2772770 | learner | draft | **new** | Editorial review |
| N4-676 | [ハンドバッグ](entries/1096/1096770-handobaggu.org) | ハンドバッグ | handobaggu | 1096770 | learner | draft | **new** | Editorial review |
| N4-677 | [嗚呼](entries/1565/1565440-aa.org) | ああ | aa | 1565440 | learner | draft | **new** | Editorial review |
| N4-678 | [ああ](entries/2085/2085080-aa.org) | ああ | aa | 2085080 | learner | draft | **new** | Editorial review |
| N4-679 | [字](entries/1315/1315120-aza.org) | あざ | aza | 1315120 | learner | draft | **new** | Editorial review |
| N4-681 | [幾らでも](entries/1858/1858120-ikurademo.org) | いくらでも | ikurademo | 1858120 | learner | draft | **new** | Editorial review |
| N4-682 | [行けません](entries/1612/1612750-ikemasen.org) | いけません | ikemasen | 1612750 | learner | draft | **new** | Editorial review |
| N4-683 | [市](entries/1308/1308080-ichi.org) | いち | ichi | 1308080 | learner | draft | **new** | Editorial review |
| N4-684 | [行ってまいります](entries/2149/2149180-ittemairimasu.org) | いってまいります | ittemairimasu | 2149180 | learner | draft | **new** | Editorial review |
| N4-685 | [行ってらっしゃい](entries/2088/2088750-itterasshai.org) | いってらっしゃい | itterasshai | 2088750 | learner | draft | **new** | Editorial review |
| N4-686 | [一敗](entries/1165/1165660-ippai.org) | いっぱい | ippai | 1165660 | learner | draft | **new** | Editorial review |
| N4-687 | [お帰りなさい](entries/1001/1001740-okaerinasai.org) | おかえりなさい | okaerinasai | 1001740 | learner | draft | **new** | Editorial review |
| N4-688 | [お陰様で](entries/1270/1270220-okagesamade.org) | おかげさまで | okagesamade | 1270220 | learner | draft | **new** | Editorial review |
| N4-689 | [お大事に](entries/1002/1002390-odaijini.org) | おだいじに | odaijini | 1002390 | learner | draft | **new** | Editorial review |
| N4-690 | [お待たせしました](entries/2149/2149640-omataseshimashita.org) | おまたせしました | omataseshimashita | 2149640 | learner | draft | **new** | Editorial review |
| N4-691 | [おめでとう御座います](entries/1001/1001540-omedetougozaimasu.org) | おめでとうございます | omedetougozaimasu | 1001540 | learner | draft | **new** | Editorial review |
| N4-692 | [居る](entries/1577/1577985-oru.org) | おる | oru | 1577985 | learner | draft | **new** | Editorial review |
| N4-693 | [各校](entries/1204/1204960-kakukou.org) | かくこう | kakukou | 1204960 | learner | draft | **new** | Editorial review |
| N4-695 | [畏まりました](entries/1002/1002790-kashikomarimashita.org) | かしこまりました | kashikomarimashita | 1002790 | learner | draft | **new** | Editorial review |
| N4-696 | [難い](entries/1582/1582640-katai.org) | かたい | katai | 1582640 | learner | draft | **new** | Editorial review |
| N4-697 | [金持ち](entries/1242/1242970-kanemochi.org) | かねもち | kanemochi | 1242970 | learner | draft | **new** | Editorial review |
| N4-698 | [汚れる](entries/1179/1179000-kegareru.org) | けがれる | kegareru | 1179000 | learner | draft | **new** | Editorial review |
| N4-699 | [死](entries/1310/1310720-shi.org) | し | shi | 1310720 | learner | draft | **new** | Editorial review |
| N4-700 | [し](entries/2086/2086640-shi.org) | し | shi | 2086640 | learner | draft | **new** | Editorial review |
| N4-701 | [僕](entries/1521/1521390-shimobe.org) | しもべ | shimobe | 1521390 | learner | draft | **new** | Editorial review |
| N4-702 | [１０分](entries/1335/1335070-jippun.org) | じっぷん | jippun | 1335070 | learner | draft | **new** | Editorial review |
| N4-703 | [中](entries/2083/2083570-juu.org) | じゅう | juu | 2083570 | learner | draft | **new** | Editorial review |
| N4-704 | [嬢](entries/1355/1355930-jou.org) | じょう | jou | 1355930 | learner | draft | **new** | Editorial review |
| N4-705 | [畳](entries/1356/1356740-jou.org) | じょう | jou | 1356740 | learner | draft | **new** | Editorial review |
| N4-706 | [ずっと](entries/1006/1006380-zutto.org) | ずっと | zutto | 1006380 | learner | draft | **new** | Editorial review |
| N4-707 | [然う](entries/2137/2137720-sou.org) | そう | sou | 2137720 | learner | draft | **new** | Editorial review |
| N4-708 | [只今](entries/1538/1538960-tadaima.org) | ただいま | tadaima | 1538960 | learner | draft | **new** | Editorial review |
| N4-709 | [点](entries/1007/1007860-chobo.org) | ちょぼ | chobo | 1007860 | learner | draft | **new** | Editorial review |
| N4-710 | [端](entries/2746/2746070-tsuma.org) | つま | tsuma | 2746070 | learner | draft | **new** | Editorial review |
| N4-711 | [店](entries/1582/1582125-ten.org) | てん | ten | 1582125 | learner | draft | **new** | Editorial review |
| N4-712 | [治す](entries/2856/2856318-naosu.org) | なおす | naosu | 2856318 | learner | draft | **new** | Editorial review |
| N4-713 | [杯](entries/2019/2019640-hai.org) | はい | hai | 2019640 | learner | draft | **new** | Editorial review |
| N4-714 | [端](entries/1581/1581610-hashi.org) | はし | hashi | 1581610 | learner | draft | **new** | Editorial review |
| N4-716 | [都](entries/1444/1444950-miyako.org) | みやこ | miyako | 1444950 | learner | draft | **new** | Editorial review |
| N4-717 | [惨い](entries/1303/1303270-mugoi.org) | むごい | mugoi | 1303270 | learner | draft | **new** | Editorial review |
| N4-718 | [巡る](entries/1342/1342050-meguru.org) | めぐる | meguru | 1342050 | learner | draft | **new** | Editorial review |
| N4-719 | [や](entries/2028/2028960-ya.org) | や | ya | 2028960 | learner | draft | **new** | Editorial review |
| N4-720 | [易い](entries/1156/1156990-yasui.org) | やすい | yasui | 1156990 | learner | draft | **new** | Editorial review |
| N4-721 | [矢っ張り](entries/1012/1012810-yappari.org) | やっぱり | yappari | 1012810 | learner | draft | **new** | Editorial review |
| N4-722 | [陽](entries/1605/1605845-you.org) | よう | you | 1605845 | learner | draft | **new** | Editorial review |
| N4-723 | [クラブ](entries/1044/1044310-kurabu.org) | クラブ | kurabu | 1044310 | learner | draft | **new** | Editorial review |
| N3-1 | [愛](entries/1150/1150410-ai.org) | あい | ai | 1150410 | learner | draft | **new** | Editorial review |
| N3-2 | [愛情](entries/1150/1150860-aijou.org) | あいじょう | aijou | 1150860 | learner | draft | **new** | Editorial review |
| N3-3 | [アイスクリーム](entries/1013/1013980-aisukuriimu.org) | アイスクリーム | aisukuriimu | 1013980 | learner | draft | **new** | Editorial review |
| N3-4 | [愛する](entries/1150/1150450-aisuru.org) | あいする | aisuru | 1150450 | learner | draft | **new** | Editorial review |
| N3-5 | [合図](entries/1284/1284930-aizu.org) | あいず | aizu | 1284930 | learner | draft | **new** | Editorial review |
| N3-6 | [相手](entries/1401/1401000-aite.org) | あいて | aite | 1401000 | learner | draft | **new** | Editorial review |
| N3-7 | [生憎](entries/1379/1379210-ainiku.org) | あいにく | ainiku | 1379210 | learner | draft | **new** | Editorial review |
| N3-8 | [アイロン](entries/1014/1014590-airon.org) | アイロン | airon | 1014590 | learner | draft | **new** | Editorial review |
| N3-9 | [ＯＵＴ](entries/1014/1014680-auto.org) | アウト | auto | 1014680 | learner | draft | **new** | Editorial review |
| N3-10 | [明かり](entries/1586/1586210-akari.org) | あかり | akari | 1586210 | learner | draft | **new** | Editorial review |
| N3-11 | [空き](entries/1609/1609010-aki.org) | あき | aki | 1609010 | learner | draft | **new** | Editorial review |
| N3-12 | [明らか](entries/1532/1532310-akiraka.org) | あきらか | akiraka | 1532310 | learner | draft | **new** | Editorial review |
| N3-13 | [諦める](entries/1436/1436730-akirameru.org) | あきらめる | akirameru | 1436730 | learner | draft | **new** | Editorial review |
| N3-14 | [飽きる](entries/1586/1586250-akiru.org) | あきる | akiru | 1586250 | learner | draft | **new** | Editorial review |
| N3-15 | [握手](entries/1152/1152730-akushu.org) | あくしゅ | akushu | 1152730 | learner | draft | **new** | Editorial review |
| N3-16 | [悪魔](entries/1152/1152510-akuma.org) | あくま | akuma | 1152510 | learner | draft | **new** | Editorial review |
| N3-17 | [預ける](entries/1544/1544990-azukeru.org) | あずける | azukeru | 1544990 | learner | draft | **new** | Editorial review |
| N3-18 | [汗](entries/1213/1213060-ase.org) | あせ | ase | 1213060 | learner | draft | **new** | Editorial review |
| N3-19 | [値](entries/1581/1581630-atai.org) | あたい | atai | 1581630 | learner | draft | **new** | Editorial review |
| N3-20 | [与える](entries/1544/1544730-ataeru.org) | あたえる | ataeru | 1544730 | learner | draft | **new** | Editorial review |
| N3-21 | [辺り](entries/1512/1512080-atari.org) | あたり | atari | 1512080 | learner | draft | **new** | Editorial review |
| N3-22 | [当たる](entries/1448/1448810-ataru.org) | あたる | ataru | 1448810 | learner | draft | **new** | Editorial review |
| N3-23 | [彼方此方](entries/1612/1612620-achikochi.org) | あちこち | achikochi | 1612620 | learner | draft | **new** | Editorial review |
| N3-24 | [扱う](entries/1153/1153440-atsukau.org) | あつかう | atsukau | 1153440 | learner | draft | **new** | Editorial review |
| N3-25 | [集まり](entries/1609/1609050-atsumari.org) | あつまり | atsumari | 1609050 | learner | draft | **new** | Editorial review |
| N3-26 | [当てる](entries/1448/1448860-ateru.org) | あてる | ateru | 1448860 | learner | draft | **new** | Editorial review |
| N3-27 | [跡](entries/1383/1383680-ato.org) | あと | ato | 1383680 | learner | draft | **new** | Editorial review |
| N3-28 | [穴](entries/1254/1254480-ana.org) | あな | ana | 1254480 | learner | draft | **new** | Editorial review |
| N3-29 | [油](entries/1538/1538590-abura.org) | あぶら | abura | 1538590 | learner | draft | **new** | Editorial review |
| N3-30 | [誤り](entries/1271/1271290-ayamari.org) | あやまり | ayamari | 1271290 | learner | draft | **new** | Editorial review |
| N3-31 | [粗い](entries/1396/1396910-arai.org) | あらい | arai | 1396910 | learner | draft | **new** | Editorial review |
| N3-32 | [嵐](entries/1549/1549340-arashi.org) | あらし | arashi | 1549340 | learner | draft | **new** | Editorial review |
| N3-33 | [新た](entries/1361/1361510-arata.org) | あらた | arata | 1361510 | learner | draft | **new** | Editorial review |
| N3-34 | [凡ゆる](entries/1586/1586780-arayuru.org) | あらゆる | arayuru | 1586780 | learner | draft | **new** | Editorial review |
| N3-35 | [表わす](entries/1263/1263490-arawasu.org) | あらわす | arawasu | 1263490 | learner | draft | **new** | Editorial review |
| N3-36 | [表す](entries/1263/1263490-arawasu.org) | あらわす | arawasu | 1263490 | learner | draft | **new** | Editorial review |
| N3-37 | [現れ](entries/1610/1610550-araware.org) | あらわれ | araware | 1610550 | learner | draft | **new** | Editorial review |
| N3-38 | [現れる](entries/1263/1263510-arawareru.org) | あらわれる | arawareru | 1263510 | learner | draft | **new** | Editorial review |
| N3-39 | [有難う](entries/1586/1586820-arigatou.org) | ありがとう | arigatou | 1586820 | learner | draft | **new** | Editorial review |
| N3-40 | [或る](entries/1586/1586840-aru.org) | ある | aru | 1586840 | learner | draft | **new** | Editorial review |
| N3-41 | [或いは](entries/1586/1586850-aruiwa.org) | あるいは | aruiwa | 1586850 | learner | draft | **new** | Editorial review |
| N3-42 | [アルバム](entries/1019/1019450-arubamu.org) | アルバム | arubamu | 1019450 | learner | draft | **new** | Editorial review |
| N3-43 | [泡](entries/1517/1517510-awa.org) | あわ | awa | 1517510 | learner | draft | **new** | Editorial review |
| N3-44 | [合わせる](entries/1284/1284480-awaseru.org) | あわせる | awaseru | 1284480 | learner | draft | **new** | Editorial review |
| N3-45 | [哀れ](entries/1150/1150110-aware.org) | あわれ | aware | 1150110 | learner | draft | **new** | Editorial review |
| N3-46 | [案](entries/1154/1154770-an.org) | あん | an | 1154770 | learner | draft | **new** | Editorial review |
| N3-47 | [暗記](entries/1586/1586910-anki.org) | あんき | anki | 1586910 | learner | draft | **new** | Editorial review |
| N3-48 | [安定](entries/1154/1154120-antei.org) | あんてい | antei | 1154120 | learner | draft | **new** | Editorial review |
| N3-49 | [案内](entries/1154/1154860-annai.org) | あんない | annai | 1154860 | learner | draft | **new** | Editorial review |
| N3-50 | [あんなに](entries/1981/1981450-annani.org) | あんなに | annani | 1981450 | learner | draft | **new** | Editorial review |
| N3-51 | [胃](entries/1158/1158500-i.org) | い | i | 1158500 | learner | draft | **new** | Editorial review |
| N3-52 | [委員](entries/1156/1156100-iin.org) | いいん | iin | 1156100 | learner | draft | **new** | Editorial review |
| N3-53 | [意外](entries/1156/1156410-igai.org) | いがい | igai | 1156410 | learner | draft | **new** | Editorial review |
| N3-54 | [息](entries/1404/1404320-iki.org) | いき | iki | 1404320 | learner | draft | **new** | Editorial review |
| N3-55 | [行き](entries/1578/1578790-iki.org) | いき | iki | 1578790 | learner | draft | **new** | Editorial review |
| N3-56 | [勢い](entries/1375/1375040-ikioi.org) | いきおい | ikioi | 1375040 | learner | draft | **new** | Editorial review |
| N3-57 | [生き物](entries/1378/1378590-ikimono.org) | いきもの | ikimono | 1378590 | learner | draft | **new** | Editorial review |
| N3-58 | [行けない](entries/1000/1000730-ikenai.org) | いけない | ikenai | 1000730 | learner | draft | **new** | Editorial review |
| N3-59 | [医師](entries/1159/1159930-ishi.org) | いし | ishi | 1159930 | learner | draft | **new** | Editorial review |
| N3-60 | [意志](entries/1156/1156560-ishi.org) | いし | ishi | 1156560 | learner | draft | **new** | Editorial review |
| N3-61 | [意思](entries/1156/1156610-ishi.org) | いし | ishi | 1156610 | learner | draft | **new** | Editorial review |
| N3-62 | [意識](entries/1156/1156640-ishiki.org) | いしき | ishiki | 1156640 | learner | draft | **new** | Editorial review |
| N3-63 | [維持](entries/1158/1158450-iji.org) | いじ | iji | 1158450 | learner | draft | **new** | Editorial review |
| N3-64 | [異常](entries/1157/1157760-ijou.org) | いじょう | ijou | 1157760 | learner | draft | **new** | Editorial review |
| N3-65 | [泉](entries/1390/1390780-izumi.org) | いずみ | izumi | 1390780 | learner | draft | **new** | Editorial review |
| N3-66 | [何れ](entries/1566/1566210-izure.org) | いずれ | izure | 1566210 | learner | draft | **new** | Editorial review |
| N3-67 | [以前](entries/1155/1155150-izen.org) | いぜん | izen | 1155150 | learner | draft | **new** | Editorial review |
| N3-68 | [板](entries/1481/1481350-ita.org) | いた | ita | 1481350 | learner | draft | **new** | Editorial review |
| N3-69 | [悪戯](entries/1151/1151580-itazura.org) | いたずら | itazura | 1151580 | learner | draft | **new** | Editorial review |
| N3-70 | [頂きます](entries/1410/1410800-itadakimasu.org) | いただきます | itadakimasu | 1410800 | learner | draft | **new** | Editorial review |
| N3-71 | [頂く](entries/1587/1587290-itadaku.org) | いただく | itadaku | 1587290 | learner | draft | **new** | Editorial review |
| N3-72 | [痛み](entries/1587/1587300-itami.org) | いたみ | itami | 1587300 | learner | draft | **new** | Editorial review |
| N3-73 | [至る](entries/1311/1311870-itaru.org) | いたる | itaru | 1311870 | learner | draft | **new** | Editorial review |
| N3-74 | [偉大](entries/1155/1155920-idai.org) | いだい | idai | 1155920 | learner | draft | **new** | Editorial review |
| N3-75 | [抱く](entries/1584/1584090-idaku.org) | いだく | idaku | 1584090 | learner | draft | **new** | Editorial review |
| N3-76 | [位置](entries/1587/1587310-ichi.org) | いち | ichi | 1587310 | learner | draft | **new** | Editorial review |
| N3-77 | [市](entries/1308/1308080-ichi.org) | いち | ichi | 1308080 | learner | draft | **new** | Editorial review |
| N3-78 | [一時](entries/1576/1576100-ichiji.org) | いちじ | ichiji | 1576100 | learner | draft | **new** | Editorial review |
| N3-79 | [一度に](entries/1609/1609210-ichidoni.org) | いちどに | ichidoni | 1609210 | learner | draft | **new** | Editorial review |
| N3-80 | [市場](entries/1308/1308300-ichiba.org) | いちば | ichiba | 1308300 | learner | draft | **new** | Editorial review |
| N3-81 | [一家](entries/1575/1575940-ikka.org) | いっか | ikka | 1575940 | learner | draft | **new** | Editorial review |
| N3-82 | [一種](entries/1163/1163170-isshu.org) | いっしゅ | isshu | 1163170 | learner | draft | **new** | Editorial review |
| N3-83 | [一瞬](entries/1163/1163340-isshun.org) | いっしゅん | isshun | 1163340 | learner | draft | **new** | Editorial review |
| N3-84 | [一生](entries/1576/1576200-isshou.org) | いっしょう | isshou | 1576200 | learner | draft | **new** | Editorial review |
| N3-85 | [一層](entries/1164/1164340-issou.org) | いっそう | issou | 1164340 | learner | draft | **new** | Editorial review |
| N3-86 | [一体](entries/1164/1164510-ittai.org) | いったい | ittai | 1164510 | learner | draft | **new** | Editorial review |
| N3-87 | [一致](entries/1164/1164740-itchi.org) | いっち | itchi | 1164740 | learner | draft | **new** | Editorial review |
| N3-88 | [一般](entries/1165/1165790-ippan.org) | いっぱん | ippan | 1165790 | learner | draft | **new** | Editorial review |
| N3-89 | [一方](entries/1166/1166510-ippou.org) | いっぽう | ippou | 1166510 | learner | draft | **new** | Editorial review |
| N3-90 | [何時か](entries/1188/1188790-itsuka.org) | いつか | itsuka | 1188790 | learner | draft | **new** | Editorial review |
| N3-91 | [何時でも](entries/1577/1577130-itsudemo.org) | いつでも | itsudemo | 1577130 | learner | draft | **new** | Editorial review |
| N3-92 | [何時までも](entries/1188/1188880-itsumademo.org) | いつまでも | itsumademo | 1188880 | learner | draft | **new** | Editorial review |
| N3-93 | [従兄弟](entries/1335/1335290-itoko.org) | いとこ | itoko | 1335290 | learner | draft | **new** | Editorial review |
| N3-94 | [移動](entries/1158/1158400-idou.org) | いどう | idou | 1158400 | learner | draft | **new** | Editorial review |
| N3-95 | [稲](entries/1167/1167820-ine.org) | いね | ine | 1167820 | learner | draft | **new** | Editorial review |
| N3-96 | [居眠り](entries/1231/1231890-inemuri.org) | いねむり | inemuri | 1231890 | learner | draft | **new** | Editorial review |
| N3-97 | [命](entries/1531/1531940-inochi.org) | いのち | inochi | 1531940 | learner | draft | **new** | Editorial review |
| N3-98 | [違反](entries/1158/1158950-ihan.org) | いはん | ihan | 1158950 | learner | draft | **new** | Editorial review |
| N3-99 | [衣服](entries/1158/1158810-ifuku.org) | いふく | ifuku | 1158810 | learner | draft | **new** | Editorial review |
| N3-100 | [居間](entries/1231/1231720-ima.org) | いま | ima | 1231720 | learner | draft | **new** | Editorial review |
| N3-101 | [今に](entries/1288/1288940-imani.org) | いまに | imani | 1288940 | learner | draft | **new** | Editorial review |
| N3-102 | [今にも](entries/1288/1288950-imanimo.org) | いまにも | imanimo | 1288950 | learner | draft | **new** | Editorial review |
| N3-103 | [以来](entries/1155/1155210-irai.org) | いらい | irai | 1155210 | learner | draft | **new** | Editorial review |
| N3-104 | [依頼](entries/1155/1155710-irai.org) | いらい | irai | 1155710 | learner | draft | **new** | Editorial review |
| N3-105 | [苛々](entries/1587/1587700-iraira.org) | いらいら | iraira | 1587700 | learner | draft | **new** | Editorial review |
| N3-106 | [いらっしゃい](entries/1000/1000920-irasshai.org) | いらっしゃい | irasshai | 1000920 | learner | draft | **new** | Editorial review |
| N3-107 | [医療](entries/1160/1160140-iryou.org) | いりょう | iryou | 1160140 | learner | draft | **new** | Editorial review |
| N3-108 | [岩](entries/1217/1217270-iwa.org) | いわ | iwa | 1217270 | learner | draft | **new** | Editorial review |
| N3-109 | [祝い](entries/1337/1337370-iwai.org) | いわい | iwai | 1337370 | learner | draft | **new** | Editorial review |
| N3-110 | [祝う](entries/1337/1337390-iwau.org) | いわう | iwau | 1337390 | learner | draft | **new** | Editorial review |
| N3-111 | [言わば](entries/1264/1264380-iwaba.org) | いわば | iwaba | 1264380 | learner | draft | **new** | Editorial review |
| N3-112 | [所謂](entries/1343/1343150-iwayuru.org) | いわゆる | iwayuru | 1343150 | learner | draft | **new** | Editorial review |
| N3-113 | [インク](entries/1022/1022210-inku.org) | インク | inku | 1022210 | learner | draft | **new** | Editorial review |
| N3-114 | [印刷](entries/1168/1168190-insatsu.org) | いんさつ | insatsu | 1168190 | learner | draft | **new** | Editorial review |
| N3-115 | [印象](entries/1168/1168390-inshou.org) | いんしょう | inshou | 1168390 | learner | draft | **new** | Editorial review |
| N3-116 | [引退](entries/1169/1169610-intai.org) | いんたい | intai | 1169610 | learner | draft | **new** | Editorial review |
| N3-117 | [引用](entries/1169/1169660-inyou.org) | いんよう | inyou | 1169660 | learner | draft | **new** | Editorial review |
| N3-118 | [ウイスキー](entries/1025/1025140-uisukii.org) | ウイスキー | uisukii | 1025140 | learner | draft | **new** | Editorial review |
| N3-119 | [伺う](entries/1305/1305700-ukagau.org) | うかがう | ukagau | 1305700 | learner | draft | **new** | Editorial review |
| N3-120 | [嗽](entries/1577/1577660-ugai.org) | うがい | ugai | 1577660 | learner | draft | **new** | Editorial review |
| N3-121 | [受け取る](entries/1329/1329650-uketoru.org) | うけとる | uketoru | 1329650 | learner | draft | **new** | Editorial review |
| N3-122 | [動かす](entries/1451/1451170-ugokasu.org) | うごかす | ugokasu | 1451170 | learner | draft | **new** | Editorial review |
| N3-123 | [兎](entries/1443/1443970-usagi.org) | うさぎ | usagi | 1443970 | learner | draft | **new** | Editorial review |
| N3-124 | [牛](entries/1231/1231490-ushi.org) | うし | ushi | 1231490 | learner | draft | **new** | Editorial review |
| N3-125 | [失う](entries/1319/1319750-ushinau.org) | うしなう | ushinau | 1319750 | learner | draft | **new** | Editorial review |
| N3-126 | [嘘](entries/1172/1172400-uso.org) | うそ | uso | 1172400 | learner | draft | **new** | Editorial review |
| N3-127 | [疑う](entries/1225/1225510-utagau.org) | うたがう | utagau | 1225510 | learner | draft | **new** | Editorial review |
| N3-128 | [宇宙](entries/1171/1171300-uchuu.org) | うちゅう | uchuu | 1171300 | learner | draft | **new** | Editorial review |
| N3-129 | [訴える](entries/1397/1397720-uttaeru.org) | うったえる | uttaeru | 1397720 | learner | draft | **new** | Editorial review |
| N3-130 | [撃つ](entries/1253/1253570-utsu.org) | うつ | utsu | 1253570 | learner | draft | **new** | Editorial review |
| N3-131 | [移す](entries/1158/1158160-utsusu.org) | うつす | utsusu | 1158160 | learner | draft | **new** | Editorial review |
| N3-132 | [唸る](entries/1565/1565300-unaru.org) | うなる | unaru | 1565300 | learner | draft | **new** | Editorial review |
| N3-133 | [奪う](entries/1416/1416340-ubau.org) | うばう | ubau | 1416340 | learner | draft | **new** | Editorial review |
| N3-134 | [馬](entries/1471/1471560-uma.org) | うま | uma | 1471560 | learner | draft | **new** | Editorial review |
| N3-135 | [上手い](entries/1310/1310460-umai.org) | うまい | umai | 1310460 | learner | draft | **new** | Editorial review |
| N3-136 | [生まれ](entries/1609/1609350-umare.org) | うまれ | umare | 1609350 | learner | draft | **new** | Editorial review |
| N3-137 | [梅](entries/1473/1473460-ume.org) | うめ | ume | 1473460 | learner | draft | **new** | Editorial review |
| N3-138 | [裏切る](entries/1550/1550380-uragiru.org) | うらぎる | uragiru | 1550380 | learner | draft | **new** | Editorial review |
| N3-139 | [得る](entries/1454/1454500-uru.org) | うる | uru | 1454500 | learner | draft | **new** | Editorial review |
| N3-140 | [嬉しい](entries/1219/1219510-ureshii.org) | うれしい | ureshii | 1219510 | learner | draft | **new** | Editorial review |
| N3-141 | [売れる](entries/1473/1473960-ureru.org) | うれる | ureru | 1473960 | learner | draft | **new** | Editorial review |
| N3-142 | [噂](entries/1172/1172590-uwasa.org) | うわさ | uwasa | 1172590 | learner | draft | **new** | Editorial review |
| N3-143 | [運](entries/1172/1172610-un.org) | うん | un | 1172610 | learner | draft | **new** | Editorial review |
| N3-144 | [運転](entries/1172/1172830-unten.org) | うんてん | unten | 1172830 | learner | draft | **new** | Editorial review |
| N3-145 | [運動](entries/1172/1172910-undou.org) | うんどう | undou | 1172910 | learner | draft | **new** | Editorial review |
| N3-146 | [柄](entries/1508/1508290-e.org) | え | e | 1508290 | learner | draft | **new** | Editorial review |
| N3-147 | [永遠](entries/1174/1174070-eien.org) | えいえん | eien | 1174070 | learner | draft | **new** | Editorial review |
| N3-148 | [永久](entries/1576/1576520-eikyuu.org) | えいきゅう | eikyuu | 1576520 | learner | draft | **new** | Editorial review |
| N3-149 | [影響](entries/1173/1173660-eikyou.org) | えいきょう | eikyou | 1173660 | learner | draft | **new** | Editorial review |
| N3-150 | [営業](entries/1173/1173430-eigyou.org) | えいぎょう | eigyou | 1173430 | learner | draft | **new** | Editorial review |
| N3-151 | [衛星](entries/1174/1174760-eisei.org) | えいせい | eisei | 1174760 | learner | draft | **new** | Editorial review |
| N3-152 | [栄養](entries/1173/1173990-eiyou.org) | えいよう | eiyou | 1173990 | learner | draft | **new** | Editorial review |
| N3-153 | [笑顔](entries/1351/1351400-egao.org) | えがお | egao | 1351400 | learner | draft | **new** | Editorial review |
| N3-154 | [描く](entries/1583/1583460-egaku.org) | えがく | egaku | 1583460 | learner | draft | **new** | Editorial review |
| N3-155 | [餌](entries/1173/1173340-esa.org) | えさ | esa | 1173340 | learner | draft | **new** | Editorial review |
| N3-156 | [エネルギー](entries/1029/1029430-enerugii.org) | エネルギー | enerugii | 1029430 | learner | draft | **new** | Editorial review |
| N3-157 | [得る](entries/1588/1588760-eru.org) | える | eru | 1588760 | learner | draft | **new** | Editorial review |
| N3-158 | [縁](entries/1177/1177490-en.org) | えん | en | 1177490 | learner | draft | **new** | Editorial review |
| N3-159 | [円](entries/1175/1175570-en.org) | えん | en | 1175570 | learner | draft | **new** | Editorial review |
| N3-160 | [演技](entries/1176/1176820-engi.org) | えんぎ | engi | 1176820 | learner | draft | **new** | Editorial review |
| N3-161 | [援助](entries/1176/1176660-enjo.org) | えんじょ | enjo | 1176660 | learner | draft | **new** | Editorial review |
| N3-162 | [エンジン](entries/1030/1030950-enjin.org) | エンジン | enjin | 1030950 | learner | draft | **new** | Editorial review |
| N3-163 | [演説](entries/1176/1176960-enzetsu.org) | えんぜつ | enzetsu | 1176960 | learner | draft | **new** | Editorial review |
| N3-164 | [演奏](entries/1607/1607520-ensou.org) | えんそう | ensou | 1607520 | learner | draft | **new** | Editorial review |
| N3-165 | [老い](entries/1643/1643510-oi.org) | おい | oi | 1643510 | learner | draft | **new** | Editorial review |
| N3-166 | [追いつく](entries/1588/1588810-oitsuku.org) | おいつく | oitsuku | 1588810 | learner | draft | **new** | Editorial review |
| N3-167 | [追う](entries/1432/1432410-ou.org) | おう | ou | 1432410 | learner | draft | **new** | Editorial review |
| N3-168 | [王](entries/1629/1629200-ou.org) | おう | ou | 1629200 | learner | draft | **new** | Editorial review |
| N3-169 | [王様](entries/1181/1181700-ousama.org) | おうさま | ousama | 1181700 | learner | draft | **new** | Editorial review |
| N3-170 | [王子](entries/1181/1181500-ouji.org) | おうじ | ouji | 1181500 | learner | draft | **new** | Editorial review |
| N3-171 | [応じる](entries/1179/1179830-oujiru.org) | おうじる | oujiru | 1179830 | learner | draft | **new** | Editorial review |
| N3-172 | [横断](entries/1180/1180900-oudan.org) | おうだん | oudan | 1180900 | learner | draft | **new** | Editorial review |
| N3-173 | [終える](entries/1332/1332760-oeru.org) | おえる | oeru | 1332760 | learner | draft | **new** | Editorial review |
| N3-174 | [大いに](entries/1412/1412880-ooini.org) | おおいに | ooini | 1412880 | learner | draft | **new** | Editorial review |
| N3-175 | [覆う](entries/1588/1588840-oou.org) | おおう | oou | 1588840 | learner | draft | **new** | Editorial review |
| N3-176 | [大家](entries/1413/1413140-ooya.org) | おおや | ooya | 1413140 | learner | draft | **new** | Editorial review |
| N3-177 | [丘](entries/1588/1588920-oka.org) | おか | oka | 1588920 | learner | draft | **new** | Editorial review |
| N3-178 | [沖](entries/1182/1182500-oki.org) | おき | oki | 1182500 | learner | draft | **new** | Editorial review |
| N3-179 | [奥](entries/1179/1179320-oku.org) | おく | oku | 1179320 | learner | draft | **new** | Editorial review |
| N3-180 | [贈る](entries/1403/1403550-okuru.org) | おくる | okuru | 1403550 | learner | draft | **new** | Editorial review |
| N3-181 | [起こる](entries/1223/1223680-okoru.org) | おこる | okoru | 1223680 | learner | draft | **new** | Editorial review |
| N3-182 | [幼い](entries/1545/1545110-osanai.org) | おさない | osanai | 1545110 | learner | draft | **new** | Editorial review |
| N3-183 | [収める](entries/1589/1589090-osameru.org) | おさめる | osameru | 1589090 | learner | draft | **new** | Editorial review |
| N3-184 | [お喋り](entries/1002/1002450-oshaberi.org) | おしゃべり | oshaberi | 1002450 | learner | draft | **new** | Editorial review |
| N3-185 | [汚染](entries/1179/1179040-osen.org) | おせん | osen | 1179040 | learner | draft | **new** | Editorial review |
| N3-186 | [恐らく](entries/1236/1236650-osoraku.org) | おそらく | osoraku | 1236650 | learner | draft | **new** | Editorial review |
| N3-187 | [恐れる](entries/1589/1589200-osoreru.org) | おそれる | osoreru | 1589200 | learner | draft | **new** | Editorial review |
| N3-188 | [恐ろしい](entries/1236/1236690-osoroshii.org) | おそろしい | osoroshii | 1236690 | learner | draft | **new** | Editorial review |
| N3-189 | [お互い](entries/1979/1979930-otagai.org) | おたがい | otagai | 1979930 | learner | draft | **new** | Editorial review |
| N3-190 | [穏やか](entries/1183/1183590-odayaka.org) | おだやか | odayaka | 1183590 | learner | draft | **new** | Editorial review |
| N3-191 | [男の人](entries/1420/1420020-otokonohito.org) | おとこのひと | otokonohito | 1420020 | learner | draft | **new** | Editorial review |
| N3-192 | [劣る](entries/1558/1558400-otoru.org) | おとる | otoru | 1558400 | learner | draft | **new** | Editorial review |
| N3-193 | [鬼](entries/1224/1224190-oni.org) | おに | oni | 1224190 | learner | draft | **new** | Editorial review |
| N3-194 | [お昼](entries/1660/1660100-ohiru.org) | おひる | ohiru | 1660100 | learner | draft | **new** | Editorial review |
| N3-195 | [帯](entries/1410/1410410-obi.org) | おび | obi | 1410410 | learner | draft | **new** | Editorial review |
| N3-196 | [オフィス](entries/1034/1034660-ofisu.org) | オフィス | ofisu | 1034660 | learner | draft | **new** | Editorial review |
| N3-197 | [溺れる](entries/1437/1437560-oboreru.org) | おぼれる | oboreru | 1437560 | learner | draft | **new** | Editorial review |
| N3-198 | [お前](entries/1002/1002290-omae.org) | おまえ | omae | 1002290 | learner | draft | **new** | Editorial review |
| N3-199 | [御目出度う](entries/1270/1270700-omedetou.org) | おめでとう | omedetou | 1270700 | learner | draft | **new** | Editorial review |
| N3-200 | [思い出](entries/1589/1589340-omoide.org) | おもいで | omoide | 1589340 | learner | draft | **new** | Editorial review |
| N3-201 | [主に](entries/1324/1324990-omoni.org) | おもに | omoni | 1324990 | learner | draft | **new** | Editorial review |
| N3-202 | [思わず](entries/1309/1309460-omowazu.org) | おもわず | omowazu | 1309460 | learner | draft | **new** | Editorial review |
| N3-203 | [泳ぎ](entries/1613/1613570-oyogi.org) | およぎ | oyogi | 1613570 | learner | draft | **new** | Editorial review |
| N3-204 | [凡そ](entries/1523/1523450-oyoso.org) | およそ | oyoso | 1523450 | learner | draft | **new** | Editorial review |
| N3-205 | [及ぼす](entries/1228/1228180-oyobosu.org) | およぼす | oyobosu | 1228180 | learner | draft | **new** | Editorial review |
| N3-206 | [居る](entries/1577/1577985-oru.org) | おる | oru | 1577985 | learner | draft | **new** | Editorial review |
| N3-207 | [下ろす](entries/1589/1589580-orosu.org) | おろす | orosu | 1589580 | learner | draft | **new** | Editorial review |
| N3-208 | [恩](entries/1183/1183090-on.org) | おん | on | 1183090 | learner | draft | **new** | Editorial review |
| N3-209 | [温暖](entries/1183/1183480-ondan.org) | おんだん | ondan | 1183480 | learner | draft | **new** | Editorial review |
| N3-210 | [温度](entries/1183/1183510-ondo.org) | おんど | ondo | 1183510 | learner | draft | **new** | Editorial review |
| N3-211 | [オーバー](entries/1032/1032390-oobaa.org) | オーバー | oobaa | 1032390 | learner | draft | **new** | Editorial review |
| N3-212 | [可](entries/1190/1190710-ka.org) | か | ka | 1190710 | learner | draft | **new** | Editorial review |
| N3-213 | [課](entries/1195/1195710-ka.org) | か | ka | 1195710 | learner | draft | **new** | Editorial review |
| N3-214 | [会](entries/1198/1198170-kai.org) | かい | kai | 1198170 | learner | draft | **new** | Editorial review |
| N3-215 | [回](entries/1199/1199330-kai.org) | かい | kai | 1199330 | learner | draft | **new** | Editorial review |
| N3-216 | [会員](entries/1198/1198230-kaiin.org) | かいいん | kaiin | 1198230 | learner | draft | **new** | Editorial review |
| N3-217 | [絵画](entries/1202/1202300-kaiga.org) | かいが | kaiga | 1202300 | learner | draft | **new** | Editorial review |
| N3-218 | [海外](entries/1201/1201260-kaigai.org) | かいがい | kaigai | 1201260 | learner | draft | **new** | Editorial review |
| N3-219 | [会計](entries/1198/1198430-kaikei.org) | かいけい | kaikei | 1198430 | learner | draft | **new** | Editorial review |
| N3-220 | [解決](entries/1198/1198960-kaiketsu.org) | かいけつ | kaiketsu | 1198960 | learner | draft | **new** | Editorial review |
| N3-221 | [会合](entries/1198/1198530-kaigou.org) | かいごう | kaigou | 1198530 | learner | draft | **new** | Editorial review |
| N3-222 | [開始](entries/1202/1202760-kaishi.org) | かいし | kaishi | 1202760 | learner | draft | **new** | Editorial review |
| N3-223 | [解釈](entries/1199/1199010-kaishaku.org) | かいしゃく | kaishaku | 1199010 | learner | draft | **new** | Editorial review |
| N3-224 | [改善](entries/1200/1200960-kaizen.org) | かいぜん | kaizen | 1200960 | learner | draft | **new** | Editorial review |
| N3-225 | [快適](entries/1200/1200120-kaiteki.org) | かいてき | kaiteki | 1200120 | learner | draft | **new** | Editorial review |
| N3-226 | [回復](entries/1199/1199720-kaifuku.org) | かいふく | kaifuku | 1199720 | learner | draft | **new** | Editorial review |
| N3-227 | [飼う](entries/1312/1312970-kau.org) | かう | kau | 1312970 | learner | draft | **new** | Editorial review |
| N3-228 | [替える](entries/1589/1589780-kaeru.org) | かえる | kaeru | 1589780 | learner | draft | **new** | Editorial review |
| N3-229 | [香り](entries/1589/1589820-kaori.org) | かおり | kaori | 1589820 | learner | draft | **new** | Editorial review |
| N3-230 | [抱える](entries/1516/1516310-kakaeru.org) | かかえる | kakaeru | 1516310 | learner | draft | **new** | Editorial review |
| N3-231 | [価格](entries/1189/1189500-kakaku.org) | かかく | kakaku | 1189500 | learner | draft | **new** | Editorial review |
| N3-232 | [係](entries/1589/1589840-kakari.org) | かかり | kakari | 1589840 | learner | draft | **new** | Editorial review |
| N3-233 | [罹る](entries/1609/1609500-kakaru.org) | かかる | kakaru | 1609500 | learner | draft | **new** | Editorial review |
| N3-234 | [化学](entries/1186/1186760-kagaku.org) | かがく | kagaku | 1186760 | learner | draft | **new** | Editorial review |
| N3-235 | [輝く](entries/1224/1224020-kagayaku.org) | かがやく | kagayaku | 1224020 | learner | draft | **new** | Editorial review |
| N3-236 | [限る](entries/1264/1264640-kagiru.org) | かぎる | kagiru | 1264640 | learner | draft | **new** | Editorial review |
| N3-237 | [覚悟](entries/1206/1206080-kakugo.org) | かくご | kakugo | 1206080 | learner | draft | **new** | Editorial review |
| N3-238 | [確実](entries/1205/1205830-kakujitsu.org) | かくじつ | kakujitsu | 1205830 | learner | draft | **new** | Editorial review |
| N3-239 | [隠す](entries/1170/1170650-kakusu.org) | かくす | kakusu | 1170650 | learner | draft | **new** | Editorial review |
| N3-240 | [拡大](entries/1205/1205200-kakudai.org) | かくだい | kakudai | 1205200 | learner | draft | **new** | Editorial review |
| N3-241 | [確認](entries/1205/1205900-kakunin.org) | かくにん | kakunin | 1205900 | learner | draft | **new** | Editorial review |
| N3-242 | [隠れる](entries/1170/1170660-kakureru.org) | かくれる | kakureru | 1170660 | learner | draft | **new** | Editorial review |
| N3-243 | [家具](entries/1191/1191870-kagu.org) | かぐ | kagu | 1191870 | learner | draft | **new** | Editorial review |
| N3-244 | [欠ける](entries/1253/1253920-kakeru.org) | かける | kakeru | 1253920 | learner | draft | **new** | Editorial review |
| N3-245 | [影](entries/1590/1590145-kage.org) | かげ | kage | 1590145 | learner | draft | **new** | Editorial review |
| N3-246 | [陰](entries/1590/1590150-kage.org) | かげ | kage | 1590150 | learner | draft | **new** | Editorial review |
| N3-247 | [加減](entries/1190/1190080-kagen.org) | かげん | kagen | 1190080 | learner | draft | **new** | Editorial review |
| N3-248 | [過去](entries/1196/1196030-kako.org) | かこ | kako | 1196030 | learner | draft | **new** | Editorial review |
| N3-249 | [囲む](entries/1155/1155980-kakomu.org) | かこむ | kakomu | 1155980 | learner | draft | **new** | Editorial review |
| N3-250 | [籠](entries/1590/1590200-kago.org) | かご | kago | 1590200 | learner | draft | **new** | Editorial review |
| N3-251 | [菓子](entries/1195/1195670-kashi.org) | かし | kashi | 1195670 | learner | draft | **new** | Editorial review |
| N3-252 | [賢い](entries/1260/1260260-kashikoi.org) | かしこい | kashikoi | 1260260 | learner | draft | **new** | Editorial review |
| N3-253 | [歌手](entries/1193/1193290-kashu.org) | かしゅ | kashu | 1193290 | learner | draft | **new** | Editorial review |
| N3-254 | [家事](entries/1191/1191980-kaji.org) | かじ | kaji | 1191980 | learner | draft | **new** | Editorial review |
| N3-255 | [数](entries/1580/1580820-kazu.org) | かず | kazu | 1580820 | learner | draft | **new** | Editorial review |
| N3-256 | [稼ぐ](entries/1194/1194450-kasegu.org) | かせぐ | kasegu | 1194450 | learner | draft | **new** | Editorial review |
| N3-257 | [数える](entries/1372/1372900-kazoeru.org) | かぞえる | kazoeru | 1372900 | learner | draft | **new** | Editorial review |
| N3-258 | [肩](entries/1258/1258950-kata.org) | かた | kata | 1258950 | learner | draft | **new** | Editorial review |
| N3-259 | [型](entries/1250/1250090-kata.org) | かた | kata | 1250090 | learner | draft | **new** | Editorial review |
| N3-260 | [方々](entries/1584/1584100-katagata.org) | かたがた | katagata | 1584100 | learner | draft | **new** | Editorial review |
| N3-261 | [刀](entries/1446/1446420-katana.org) | かたな | katana | 1446420 | learner | draft | **new** | Editorial review |
| N3-262 | [語る](entries/1270/1270990-kataru.org) | かたる | kataru | 1270990 | learner | draft | **new** | Editorial review |
| N3-263 | [価値](entries/1189/1189600-kachi.org) | かち | kachi | 1189600 | learner | draft | **new** | Editorial review |
| N3-264 | [勝ち](entries/1609/1609560-kachi.org) | かち | kachi | 1609560 | learner | draft | **new** | Editorial review |
| N3-265 | [活気](entries/1208/1208270-kakki.org) | かっき | kakki | 1208270 | learner | draft | **new** | Editorial review |
| N3-266 | [格好](entries/1590/1590480-kakkou.org) | かっこう | kakkou | 1590480 | learner | draft | **new** | Editorial review |
| N3-267 | [活動](entries/1208/1208360-katsudou.org) | かつどう | katsudou | 1208360 | learner | draft | **new** | Editorial review |
| N3-268 | [活用](entries/1208/1208460-katsuyou.org) | かつよう | katsuyou | 1208460 | learner | draft | **new** | Editorial review |
| N3-269 | [悲しむ](entries/1483/1483200-kanashimu.org) | かなしむ | kanashimu | 1483200 | learner | draft | **new** | Editorial review |
| N3-270 | [必ずしも](entries/1487/1487410-kanarazushimo.org) | かならずしも | kanarazushimo | 1487410 | learner | draft | **new** | Editorial review |
| N3-271 | [可也](entries/1590/1590560-kanari.org) | かなり | kanari | 1590560 | learner | draft | **new** | Editorial review |
| N3-272 | [金](entries/1242/1242590-kane.org) | かね | kane | 1242590 | learner | draft | **new** | Editorial review |
| N3-273 | [可能](entries/1191/1191060-kanou.org) | かのう | kanou | 1191060 | learner | draft | **new** | Editorial review |
| N3-274 | [株](entries/1208/1208920-kabu.org) | かぶ | kabu | 1208920 | learner | draft | **new** | Editorial review |
| N3-275 | [被る](entries/1484/1484330-kaburu.org) | かぶる | kaburu | 1484330 | learner | draft | **new** | Editorial review |
| N3-276 | [構う](entries/1279/1279680-kamau.org) | かまう | kamau | 1279680 | learner | draft | **new** | Editorial review |
| N3-277 | [神](entries/1364/1364440-kami.org) | かみ | kami | 1364440 | learner | draft | **new** | Editorial review |
| N3-278 | [上](entries/1352/1352150-kami.org) | かみ | kami | 1352150 | learner | draft | **new** | Editorial review |
| N3-279 | [雷](entries/1585/1585060-kaminari.org) | かみなり | kaminari | 1585060 | learner | draft | **new** | Editorial review |
| N3-280 | [髪の毛](entries/1477/1477960-kaminoke.org) | かみのけ | kaminoke | 1477960 | learner | draft | **new** | Editorial review |
| N3-281 | [科目](entries/1590/1590600-kamoku.org) | かもく | kamoku | 1590600 | learner | draft | **new** | Editorial review |
| N3-282 | [かも知れない](entries/1002/1002970-kamoshirenai.org) | かもしれない | kamoshirenai | 1002970 | learner | draft | **new** | Editorial review |
| N3-283 | [火曜](entries/1194/1194280-kayou.org) | かよう | kayou | 1194280 | learner | draft | **new** | Editorial review |
| N3-284 | [空](entries/1245/1245280-kara.org) | から | kara | 1245280 | learner | draft | **new** | Editorial review |
| N3-285 | [刈る](entries/1209/1209540-karu.org) | かる | karu | 1209540 | learner | draft | **new** | Editorial review |
| N3-286 | [彼ら](entries/1483/1483090-karera.org) | かれら | karera | 1483090 | learner | draft | **new** | Editorial review |
| N3-287 | [皮](entries/1483/1483800-kawa.org) | かわ | kawa | 1483800 | learner | draft | **new** | Editorial review |
| N3-288 | [革](entries/1483/1483805-kawa.org) | かわ | kawa | 1483805 | learner | draft | **new** | Editorial review |
| N3-289 | [可哀想](entries/1590/1590740-kawaisou.org) | かわいそう | kawaisou | 1590740 | learner | draft | **new** | Editorial review |
| N3-290 | [可愛らしい](entries/1190/1190740-kawairashii.org) | かわいらしい | kawairashii | 1190740 | learner | draft | **new** | Editorial review |
| N3-291 | [缶](entries/1214/1214540-kan.org) | かん | kan | 1214540 | learner | draft | **new** | Editorial review |
| N3-292 | [勘](entries/1210/1210590-kan.org) | かん | kan | 1210590 | learner | draft | **new** | Editorial review |
| N3-293 | [管](entries/1577/1577650-kan.org) | かん | kan | 1577650 | learner | draft | **new** | Editorial review |
| N3-294 | [感覚](entries/1212/1212330-kankaku.org) | かんかく | kankaku | 1212330 | learner | draft | **new** | Editorial review |
| N3-295 | [考え](entries/1281/1281000-kangae.org) | かんがえ | kangae | 1281000 | learner | draft | **new** | Editorial review |
| N3-296 | [観客](entries/1214/1214810-kankyaku.org) | かんきゃく | kankyaku | 1214810 | learner | draft | **new** | Editorial review |
| N3-297 | [環境](entries/1213/1213280-kankyou.org) | かんきょう | kankyou | 1213280 | learner | draft | **new** | Editorial review |
| N3-298 | [歓迎](entries/1212/1212960-kangei.org) | かんげい | kangei | 1212960 | learner | draft | **new** | Editorial review |
| N3-299 | [観光](entries/1214/1214840-kankou.org) | かんこう | kankou | 1214840 | learner | draft | **new** | Editorial review |
| N3-300 | [観察](entries/1214/1214900-kansatsu.org) | かんさつ | kansatsu | 1214900 | learner | draft | **new** | Editorial review |
| N3-301 | [感謝](entries/1212/1212380-kansha.org) | かんしゃ | kansha | 1212380 | learner | draft | **new** | Editorial review |
| N3-302 | [関心](entries/1215/1215870-kanshin.org) | かんしん | kanshin | 1215870 | learner | draft | **new** | Editorial review |
| N3-303 | [感心](entries/1212/1212450-kanshin.org) | かんしん | kanshin | 1212450 | learner | draft | **new** | Editorial review |
| N3-304 | [感じ](entries/1212/1212250-kanji.org) | かんじ | kanji | 1212250 | learner | draft | **new** | Editorial review |
| N3-305 | [患者](entries/1212/1212210-kanja.org) | かんじゃ | kanja | 1212210 | learner | draft | **new** | Editorial review |
| N3-306 | [感情](entries/1212/1212410-kanjou.org) | かんじょう | kanjou | 1212410 | learner | draft | **new** | Editorial review |
| N3-307 | [勘定](entries/1210/1210750-kanjou.org) | かんじょう | kanjou | 1210750 | learner | draft | **new** | Editorial review |
| N3-308 | [感じる](entries/1212/1212260-kanjiru.org) | かんじる | kanjiru | 1212260 | learner | draft | **new** | Editorial review |
| N3-309 | [関する](entries/1215/1215790-kansuru.org) | かんする | kansuru | 1215790 | learner | draft | **new** | Editorial review |
| N3-310 | [完成](entries/1211/1211490-kansei.org) | かんせい | kansei | 1211490 | learner | draft | **new** | Editorial review |
| N3-311 | [完全](entries/1211/1211510-kanzen.org) | かんぜん | kanzen | 1211510 | learner | draft | **new** | Editorial review |
| N3-312 | [監督](entries/1213/1213720-kantoku.org) | かんとく | kantoku | 1213720 | learner | draft | **new** | Editorial review |
| N3-313 | [感動](entries/1212/1212570-kandou.org) | かんどう | kandou | 1212570 | learner | draft | **new** | Editorial review |
| N3-314 | [管理](entries/1214/1214200-kanri.org) | かんり | kanri | 1214200 | learner | draft | **new** | Editorial review |
| N3-315 | [完了](entries/1211/1211630-kanryou.org) | かんりょう | kanryou | 1211630 | learner | draft | **new** | Editorial review |
| N3-316 | [関連](entries/1216/1216060-kanren.org) | かんれん | kanren | 1216060 | learner | draft | **new** | Editorial review |
| N3-317 | [カー](entries/1036/1036170-kaa.org) | カー | kaa | 1036170 | learner | draft | **new** | Editorial review |
| N3-318 | [カード](entries/1036/1036400-kaado.org) | カード | kaado | 1036400 | learner | draft | **new** | Editorial review |
| N3-319 | [害](entries/1204/1204330-gai.org) | がい | gai | 1204330 | learner | draft | **new** | Editorial review |
| N3-320 | [外交](entries/1203/1203540-gaikou.org) | がいこう | gaikou | 1203540 | learner | draft | **new** | Editorial review |
| N3-321 | [外出](entries/1203/1203800-gaishutsu.org) | がいしゅつ | gaishutsu | 1203800 | learner | draft | **new** | Editorial review |
| N3-322 | [画家](entries/1197/1197120-gaka.org) | がか | gaka | 1197120 | learner | draft | **new** | Editorial review |
| N3-323 | [額](entries/1207/1207500-gaku.org) | がく | gaku | 1207500 | learner | draft | **new** | Editorial review |
| N3-324 | [学](entries/1955/1955900-gaku.org) | がく | gaku | 1955900 | learner | draft | **new** | Editorial review |
| N3-325 | [学者](entries/1206/1206800-gakusha.org) | がくしゃ | gakusha | 1206800 | learner | draft | **new** | Editorial review |
| N3-326 | [学習](entries/1206/1206820-gakushuu.org) | がくしゅう | gakushuu | 1206820 | learner | draft | **new** | Editorial review |
| N3-327 | [学問](entries/1207/1207130-gakumon.org) | がくもん | gakumon | 1207130 | learner | draft | **new** | Editorial review |
| N3-328 | [がっかり](entries/1003/1003170-gakkari.org) | がっかり | gakkari | 1003170 | learner | draft | **new** | Editorial review |
| N3-329 | [学期](entries/1206/1206650-gakki.org) | がっき | gakki | 1206650 | learner | draft | **new** | Editorial review |
| N3-330 | [我慢](entries/1196/1196970-gaman.org) | がまん | gaman | 1196970 | learner | draft | **new** | Editorial review |
| N3-331 | [柄](entries/1508/1508300-gara.org) | がら | gara | 1508300 | learner | draft | **new** | Editorial review |
| N3-332 | [記憶](entries/1223/1223150-kioku.org) | きおく | kioku | 1223150 | learner | draft | **new** | Editorial review |
| N3-333 | [気温](entries/1221/1221950-kion.org) | きおん | kion | 1221950 | learner | draft | **new** | Editorial review |
| N3-334 | [機械](entries/1220/1220810-kikai.org) | きかい | kikai | 1220810 | learner | draft | **new** | Editorial review |
| N3-335 | [期間](entries/1220/1220550-kikan.org) | きかん | kikan | 1220550 | learner | draft | **new** | Editorial review |
| N3-336 | [機関](entries/1220/1220870-kikan.org) | きかん | kikan | 1220870 | learner | draft | **new** | Editorial review |
| N3-337 | [企業](entries/1218/1218190-kigyou.org) | きぎょう | kigyou | 1218190 | learner | draft | **new** | Editorial review |
| N3-338 | [利く](entries/1591/1591100-kiku.org) | きく | kiku | 1591100 | learner | draft | **new** | Editorial review |
| N3-339 | [効く](entries/1591/1591100-kiku.org) | きく | kiku | 1591100 | learner | draft | **new** | Editorial review |
| N3-340 | [機嫌](entries/1220/1220930-kigen.org) | きげん | kigen | 1220930 | learner | draft | **new** | Editorial review |
| N3-341 | [気候](entries/1222/1222170-kikou.org) | きこう | kikou | 1222170 | learner | draft | **new** | Editorial review |
| N3-342 | [岸](entries/1217/1217040-kishi.org) | きし | kishi | 1217040 | learner | draft | **new** | Editorial review |
| N3-343 | [記者](entries/1223/1223250-kisha.org) | きしゃ | kisha | 1223250 | learner | draft | **new** | Editorial review |
| N3-344 | [記事](entries/1223/1223240-kiji.org) | きじ | kiji | 1223240 | learner | draft | **new** | Editorial review |
| N3-345 | [生地](entries/1379/1379330-kiji.org) | きじ | kiji | 1379330 | learner | draft | **new** | Editorial review |
| N3-346 | [傷](entries/1580/1580260-kizu.org) | きず | kizu | 1580260 | learner | draft | **new** | Editorial review |
| N3-347 | [期待](entries/1220/1220570-kitai.org) | きたい | kitai | 1220570 | learner | draft | **new** | Editorial review |
| N3-348 | [帰宅](entries/1221/1221430-kitaku.org) | きたく | kitaku | 1221430 | learner | draft | **new** | Editorial review |
| N3-349 | [貴重](entries/1223/1223520-kichou.org) | きちょう | kichou | 1223520 | learner | draft | **new** | Editorial review |
| N3-350 | [きちんと](entries/1003/1003400-kichinto.org) | きちんと | kichinto | 1003400 | learner | draft | **new** | Editorial review |
| N3-351 | [きつい](entries/1003/1003450-kitsui.org) | きつい | kitsui | 1003450 | learner | draft | **new** | Editorial review |
| N3-352 | [気づく](entries/1591/1591330-kizuku.org) | きづく | kizuku | 1591330 | learner | draft | **new** | Editorial review |
| N3-353 | [気に入る](entries/1221/1221740-kiniiru.org) | きにいる | kiniiru | 1221740 | learner | draft | **new** | Editorial review |
| N3-354 | [記入](entries/1223/1223330-kinyuu.org) | きにゅう | kinyuu | 1223330 | learner | draft | **new** | Editorial review |
| N3-355 | [記念](entries/1223/1223340-kinen.org) | きねん | kinen | 1223340 | learner | draft | **new** | Editorial review |
| N3-356 | [機能](entries/1221/1221130-kinou.org) | きのう | kinou | 1221130 | learner | draft | **new** | Editorial review |
| N3-357 | [気の毒](entries/1221/1221770-kinodoku.org) | きのどく | kinodoku | 1221770 | learner | draft | **new** | Editorial review |
| N3-358 | [寄付](entries/1591/1591400-kifu.org) | きふ | kifu | 1591400 | learner | draft | **new** | Editorial review |
| N3-359 | [基本](entries/1219/1219190-kihon.org) | きほん | kihon | 1219190 | learner | draft | **new** | Editorial review |
| N3-360 | [希望](entries/1219/1219910-kibou.org) | きぼう | kibou | 1219910 | learner | draft | **new** | Editorial review |
| N3-361 | [決まり](entries/1609/1609660-kimari.org) | きまり | kimari | 1609660 | learner | draft | **new** | Editorial review |
| N3-362 | [気味](entries/1222/1222640-kimi.org) | きみ | kimi | 1222640 | learner | draft | **new** | Editorial review |
| N3-363 | [奇妙](entries/1219/1219490-kimyou.org) | きみょう | kimyou | 1219490 | learner | draft | **new** | Editorial review |
| N3-364 | [キャプテン](entries/1041/1041850-kyaputen.org) | キャプテン | kyaputen | 1041850 | learner | draft | **new** | Editorial review |
| N3-365 | [キャンプ](entries/1042/1042200-kyanpu.org) | キャンプ | kyanpu | 1042200 | learner | draft | **new** | Editorial review |
| N3-366 | [九](entries/1578/1578150-kyuu.org) | きゅう | kyuu | 1578150 | learner | draft | **new** | Editorial review |
| N3-367 | [旧](entries/1230/1230380-kyuu.org) | きゅう | kyuu | 1230380 | learner | draft | **new** | Editorial review |
| N3-368 | [級](entries/1919/1919590-kyuu.org) | きゅう | kyuu | 1919590 | learner | draft | **new** | Editorial review |
| N3-369 | [球](entries/1229/1229880-kyuu.org) | きゅう | kyuu | 1229880 | learner | draft | **new** | Editorial review |
| N3-370 | [休憩](entries/1227/1227720-kyuukei.org) | きゅうけい | kyuukei | 1227720 | learner | draft | **new** | Editorial review |
| N3-371 | [急激](entries/1228/1228680-kyuugeki.org) | きゅうげき | kyuugeki | 1228680 | learner | draft | **new** | Editorial review |
| N3-372 | [吸収](entries/1228/1228330-kyuushuu.org) | きゅうしゅう | kyuushuu | 1228330 | learner | draft | **new** | Editorial review |
| N3-373 | [救助](entries/1229/1229200-kyuujo.org) | きゅうじょ | kyuujo | 1229200 | learner | draft | **new** | Editorial review |
| N3-374 | [急速](entries/1228/1228890-kyuusoku.org) | きゅうそく | kyuusoku | 1228890 | learner | draft | **new** | Editorial review |
| N3-375 | [急に](entries/2269/2269050-kyuuni.org) | きゅうに | kyuuni | 2269050 | learner | draft | **new** | Editorial review |
| N3-376 | [給料](entries/1230/1230360-kyuuryou.org) | きゅうりょう | kyuuryou | 1230360 | learner | draft | **new** | Editorial review |
| N3-377 | [教科書](entries/1237/1237020-kyoukasho.org) | きょうかしょ | kyoukasho | 1237020 | learner | draft | **new** | Editorial review |
| N3-378 | [供給](entries/1233/1233630-kyoukyuu.org) | きょうきゅう | kyoukyuu | 1233630 | learner | draft | **new** | Editorial review |
| N3-379 | [競技](entries/1234/1234080-kyougi.org) | きょうぎ | kyougi | 1234080 | learner | draft | **new** | Editorial review |
| N3-380 | [教師](entries/1237/1237130-kyoushi.org) | きょうし | kyoushi | 1237130 | learner | draft | **new** | Editorial review |
| N3-381 | [教授](entries/1237/1237160-kyouju.org) | きょうじゅ | kyouju | 1237160 | learner | draft | **new** | Editorial review |
| N3-382 | [強調](entries/1236/1236470-kyouchou.org) | きょうちょう | kyouchou | 1236470 | learner | draft | **new** | Editorial review |
| N3-383 | [共通](entries/1234/1234700-kyoutsuu.org) | きょうつう | kyoutsuu | 1234700 | learner | draft | **new** | Editorial review |
| N3-384 | [共同](entries/1591/1591660-kyoudou.org) | きょうどう | kyoudou | 1591660 | learner | draft | **new** | Editorial review |
| N3-385 | [恐怖](entries/1236/1236750-kyoufu.org) | きょうふ | kyoufu | 1236750 | learner | draft | **new** | Editorial review |
| N3-386 | [協力](entries/1591/1591720-kyouryoku.org) | きょうりょく | kyouryoku | 1591720 | learner | draft | **new** | Editorial review |
| N3-387 | [強力](entries/1236/1236600-kyouryoku.org) | きょうりょく | kyouryoku | 1236600 | learner | draft | **new** | Editorial review |
| N3-388 | [許可](entries/1232/1232880-kyoka.org) | きょか | kyoka | 1232880 | learner | draft | **new** | Editorial review |
| N3-389 | [局](entries/1239/1239560-kyoku.org) | きょく | kyoku | 1239560 | learner | draft | **new** | Editorial review |
| N3-390 | [極](entries/1956/1956100-kyoku.org) | きょく | kyoku | 1956100 | learner | draft | **new** | Editorial review |
| N3-391 | [巨大](entries/1232/1232180-kyodai.org) | きょだい | kyodai | 1232180 | learner | draft | **new** | Editorial review |
| N3-392 | [器用](entries/1218/1218960-kiyou.org) | きよう | kiyou | 1218960 | learner | draft | **new** | Editorial review |
| N3-393 | [嫌う](entries/1257/1257250-kirau.org) | きらう | kirau | 1257250 | learner | draft | **new** | Editorial review |
| N3-394 | [霧](entries/1531/1531110-kiri.org) | きり | kiri | 1531110 | learner | draft | **new** | Editorial review |
| N3-395 | [切れ](entries/1384/1384840-kire.org) | きれ | kire | 1384840 | learner | draft | **new** | Editorial review |
| N3-396 | [切れる](entries/1384/1384860-kireru.org) | きれる | kireru | 1384860 | learner | draft | **new** | Editorial review |
| N3-397 | [記録](entries/1223/1223440-kiroku.org) | きろく | kiroku | 1223440 | learner | draft | **new** | Editorial review |
| N3-398 | [金](entries/1242/1242600-kin.org) | きん | kin | 1242600 | learner | draft | **new** | Editorial review |
| N3-399 | [禁煙](entries/1241/1241490-kinen.org) | きんえん | kinen | 1241490 | learner | draft | **new** | Editorial review |
| N3-400 | [金額](entries/1242/1242700-kingaku.org) | きんがく | kingaku | 1242700 | learner | draft | **new** | Editorial review |
| N3-401 | [金庫](entries/1242/1242850-kinko.org) | きんこ | kinko | 1242850 | learner | draft | **new** | Editorial review |
| N3-402 | [禁止](entries/1241/1241550-kinshi.org) | きんし | kinshi | 1241550 | learner | draft | **new** | Editorial review |
| N3-403 | [金銭](entries/1243/1243020-kinsen.org) | きんせん | kinsen | 1243020 | learner | draft | **new** | Editorial review |
| N3-404 | [金属](entries/1243/1243040-kinzoku.org) | きんぞく | kinzoku | 1243040 | learner | draft | **new** | Editorial review |
| N3-405 | [近代](entries/1242/1242420-kindai.org) | きんだい | kindai | 1242420 | learner | draft | **new** | Editorial review |
| N3-406 | [緊張](entries/1241/1241880-kinchou.org) | きんちょう | kinchou | 1241880 | learner | draft | **new** | Editorial review |
| N3-407 | [筋肉](entries/1241/1241810-kinniku.org) | きんにく | kinniku | 1241810 | learner | draft | **new** | Editorial review |
| N3-408 | [金融](entries/1243/1243290-kinyuu.org) | きんゆう | kinyuu | 1243290 | learner | draft | **new** | Editorial review |
| N3-409 | [金曜](entries/1243/1243310-kinyou.org) | きんよう | kinyou | 1243310 | learner | draft | **new** | Editorial review |
| N3-410 | [議員](entries/1226/1226020-giin.org) | ぎいん | giin | 1226020 | learner | draft | **new** | Editorial review |
| N3-411 | [議会](entries/1226/1226040-gikai.org) | ぎかい | gikai | 1226040 | learner | draft | **new** | Editorial review |
| N3-412 | [技師](entries/1225/1225110-gishi.org) | ぎし | gishi | 1225110 | learner | draft | **new** | Editorial review |
| N3-413 | [義務](entries/1225/1225900-gimu.org) | ぎむ | gimu | 1225900 | learner | draft | **new** | Editorial review |
| N3-414 | [疑問](entries/1225/1225630-gimon.org) | ぎもん | gimon | 1225630 | learner | draft | **new** | Editorial review |
| N3-415 | [逆](entries/1226/1226960-gyaku.org) | ぎゃく | gyaku | 1226960 | learner | draft | **new** | Editorial review |
| N3-416 | [行儀](entries/1281/1281890-gyougi.org) | ぎょうぎ | gyougi | 1281890 | learner | draft | **new** | Editorial review |
| N3-417 | [議論](entries/1226/1226160-giron.org) | ぎろん | giron | 1226160 | learner | draft | **new** | Editorial review |
| N3-418 | [銀](entries/1595/1595090-gin.org) | ぎん | gin | 1595090 | learner | draft | **new** | Editorial review |
| N3-419 | [句](entries/1243/1243940-ku.org) | く | ku | 1243940 | learner | draft | **new** | Editorial review |
| N3-420 | [食う](entries/1592/1592100-kuu.org) | くう | kuu | 1592100 | learner | draft | **new** | Editorial review |
| N3-421 | [臭い](entries/1333/1333150-kusai.org) | くさい | kusai | 1333150 | learner | draft | **new** | Editorial review |
| N3-422 | [鎖](entries/1291/1291730-kusari.org) | くさり | kusari | 1291730 | learner | draft | **new** | Editorial review |
| N3-423 | [腐る](entries/1497/1497800-kusaru.org) | くさる | kusaru | 1497800 | learner | draft | **new** | Editorial review |
| N3-424 | [癖](entries/1509/1509350-kuse.org) | くせ | kuse | 1509350 | learner | draft | **new** | Editorial review |
| N3-425 | [下さる](entries/1184/1184280-kudasaru.org) | くださる | kudasaru | 1184280 | learner | draft | **new** | Editorial review |
| N3-426 | [下り](entries/1184/1184370-kudari.org) | くだり | kudari | 1184370 | learner | draft | **new** | Editorial review |
| N3-427 | [苦痛](entries/1244/1244560-kutsuu.org) | くつう | kutsuu | 1244560 | learner | draft | **new** | Editorial review |
| N3-428 | [区別](entries/1244/1244250-kubetsu.org) | くべつ | kubetsu | 1244250 | learner | draft | **new** | Editorial review |
| N3-429 | [組](entries/1397/1397450-kumi.org) | くみ | kumi | 1397450 | learner | draft | **new** | Editorial review |
| N3-430 | [組合](entries/1397/1397620-kumiai.org) | くみあい | kumiai | 1397620 | learner | draft | **new** | Editorial review |
| N3-431 | [組む](entries/1397/1397590-kumu.org) | くむ | kumu | 1397590 | learner | draft | **new** | Editorial review |
| N3-432 | [位](entries/1155/1155400-kurai.org) | くらい | kurai | 1155400 | learner | draft | **new** | Editorial review |
| N3-433 | [暮らし](entries/1514/1514930-kurashi.org) | くらし | kurashi | 1514930 | learner | draft | **new** | Editorial review |
| N3-434 | [クラシック](entries/1044/1044020-kurashikku.org) | クラシック | kurashikku | 1044020 | learner | draft | **new** | Editorial review |
| N3-435 | [暮らす](entries/1514/1514940-kurasu.org) | くらす | kurasu | 1514940 | learner | draft | **new** | Editorial review |
| N3-436 | [繰り返す](entries/1247/1247030-kurikaesu.org) | くりかえす | kurikaesu | 1247030 | learner | draft | **new** | Editorial review |
| N3-437 | [クリスマス](entries/1044/1044830-kurisumasu.org) | クリスマス | kurisumasu | 1044830 | learner | draft | **new** | Editorial review |
| N3-438 | [クリーム](entries/1044/1044480-kuriimu.org) | クリーム | kuriimu | 1044480 | learner | draft | **new** | Editorial review |
| N3-439 | [狂う](entries/1237/1237510-kuruu.org) | くるう | kuruu | 1237510 | learner | draft | **new** | Editorial review |
| N3-440 | [苦しい](entries/1244/1244320-kurushii.org) | くるしい | kurushii | 1244320 | learner | draft | **new** | Editorial review |
| N3-441 | [苦しむ](entries/1244/1244350-kurushimu.org) | くるしむ | kurushimu | 1244350 | learner | draft | **new** | Editorial review |
| N3-442 | [暮れ](entries/1514/1514950-kure.org) | くれ | kure | 1514950 | learner | draft | **new** | Editorial review |
| N3-443 | [苦労](entries/1244/1244680-kurou.org) | くろう | kurou | 1244680 | learner | draft | **new** | Editorial review |
| N3-444 | [加える](entries/1189/1189960-kuwaeru.org) | くわえる | kuwaeru | 1189960 | learner | draft | **new** | Editorial review |
| N3-445 | [詳しい](entries/1351/1351730-kuwashii.org) | くわしい | kuwashii | 1351730 | learner | draft | **new** | Editorial review |
| N3-446 | [加わる](entries/1189/1189980-kuwawaru.org) | くわわる | kuwawaru | 1189980 | learner | draft | **new** | Editorial review |
| N3-447 | [訓](entries/1956/1956150-kun.org) | くん | kun | 1956150 | learner | draft | **new** | Editorial review |
| N3-448 | [訓練](entries/1247/1247470-kunren.org) | くんれん | kunren | 1247470 | learner | draft | **new** | Editorial review |
| N3-449 | [偶然](entries/1246/1246270-guuzen.org) | ぐうぜん | guuzen | 1246270 | learner | draft | **new** | Editorial review |
| N3-450 | [具体](entries/1245/1245020-gutai.org) | ぐたい | gutai | 1245020 | learner | draft | **new** | Editorial review |
| N3-451 | [ぐっすり](entries/1004/1004060-gussuri.org) | ぐっすり | gussuri | 1004060 | learner | draft | **new** | Editorial review |
| N3-452 | [グラス](entries/1046/1046430-gurasu.org) | グラス | gurasu | 1046430 | learner | draft | **new** | Editorial review |
| N3-453 | [グランド](entries/1046/1046840-gurando.org) | グランド | gurando | 1046840 | learner | draft | **new** | Editorial review |
| N3-454 | [グループ](entries/1047/1047300-guruupu.org) | グループ | guruupu | 1047300 | learner | draft | **new** | Editorial review |
| N3-455 | [軍](entries/1247/1247660-gun.org) | ぐん | gun | 1247660 | learner | draft | **new** | Editorial review |
| N3-456 | [軍隊](entries/1248/1248710-guntai.org) | ぐんたい | guntai | 1248710 | learner | draft | **new** | Editorial review |
| N3-457 | [敬意](entries/1250/1250720-keii.org) | けいい | keii | 1250720 | learner | draft | **new** | Editorial review |
| N3-458 | [経営](entries/1251/1251130-keiei.org) | けいえい | keiei | 1251130 | learner | draft | **new** | Editorial review |
| N3-459 | [計画](entries/1252/1252090-keikaku.org) | けいかく | keikaku | 1252090 | learner | draft | **new** | Editorial review |
| N3-460 | [景気](entries/1250/1250830-keiki.org) | けいき | keiki | 1250830 | learner | draft | **new** | Editorial review |
| N3-461 | [経験](entries/1251/1251270-keiken.org) | けいけん | keiken | 1251270 | learner | draft | **new** | Editorial review |
| N3-462 | [傾向](entries/1249/1249470-keikou.org) | けいこう | keikou | 1249470 | learner | draft | **new** | Editorial review |
| N3-463 | [警告](entries/1252/1252360-keikoku.org) | けいこく | keikoku | 1252360 | learner | draft | **new** | Editorial review |
| N3-464 | [計算](entries/1252/1252140-keisan.org) | けいさん | keisan | 1252140 | learner | draft | **new** | Editorial review |
| N3-465 | [掲示](entries/1250/1250620-keiji.org) | けいじ | keiji | 1250620 | learner | draft | **new** | Editorial review |
| N3-466 | [刑事](entries/1249/1249660-keiji.org) | けいじ | keiji | 1249660 | learner | draft | **new** | Editorial review |
| N3-467 | [契約](entries/1250/1250190-keiyaku.org) | けいやく | keiyaku | 1250190 | learner | draft | **new** | Editorial review |
| N3-468 | [経由](entries/1251/1251670-keiyu.org) | けいゆ | keiyu | 1251670 | learner | draft | **new** | Editorial review |
| N3-469 | [怪我](entries/1200/1200220-kega.org) | けが | kega | 1200220 | learner | draft | **new** | Editorial review |
| N3-470 | [化粧](entries/1577/1577040-keshou.org) | けしょう | keshou | 1577040 | learner | draft | **new** | Editorial review |
| N3-471 | [ケチ](entries/2234/2234080-kechi.org) | ケチ | kechi | 2234080 | learner | draft | **new** | Editorial review |
| N3-472 | [結果](entries/1254/1254690-kekka.org) | けっか | kekka | 1254690 | learner | draft | **new** | Editorial review |
| N3-473 | [結局](entries/1254/1254730-kekkyoku.org) | けっきょく | kekkyoku | 1254730 | learner | draft | **new** | Editorial review |
| N3-474 | [決心](entries/1254/1254340-kesshin.org) | けっしん | kesshin | 1254340 | learner | draft | **new** | Editorial review |
| N3-475 | [決定](entries/1254/1254380-kettei.org) | けってい | kettei | 1254380 | learner | draft | **new** | Editorial review |
| N3-476 | [欠点](entries/1254/1254050-ketten.org) | けってん | ketten | 1254050 | learner | draft | **new** | Editorial review |
| N3-477 | [結論](entries/1255/1255020-ketsuron.org) | けつろん | ketsuron | 1255020 | learner | draft | **new** | Editorial review |
| N3-478 | [煙](entries/1177/1177180-kemuri.org) | けむり | kemuri | 1177180 | learner | draft | **new** | Editorial review |
| N3-479 | [県](entries/1258/1258810-ken.org) | けん | ken | 1258810 | learner | draft | **new** | Editorial review |
| N3-480 | [券](entries/1256/1256730-ken.org) | けん | ken | 1256730 | learner | draft | **new** | Editorial review |
| N3-481 | [軒](entries/2078/2078590-ken.org) | けん | ken | 2078590 | learner | draft | **new** | Editorial review |
| N3-482 | [見解](entries/1259/1259390-kenkai.org) | けんかい | kenkai | 1259390 | learner | draft | **new** | Editorial review |
| N3-483 | [健康](entries/1256/1256170-kenkou.org) | けんこう | kenkou | 1256170 | learner | draft | **new** | Editorial review |
| N3-484 | [検査](entries/1257/1257890-kensa.org) | けんさ | kensa | 1257890 | learner | draft | **new** | Editorial review |
| N3-485 | [建設](entries/1257/1257420-kensetsu.org) | けんせつ | kensetsu | 1257420 | learner | draft | **new** | Editorial review |
| N3-486 | [建築](entries/1257/1257500-kenchiku.org) | けんちく | kenchiku | 1257500 | learner | draft | **new** | Editorial review |
| N3-487 | [検討](entries/1258/1258000-kentou.org) | けんとう | kentou | 1258000 | learner | draft | **new** | Editorial review |
| N3-488 | [見当](entries/1259/1259930-kentou.org) | けんとう | kentou | 1259930 | learner | draft | **new** | Editorial review |
| N3-489 | [憲法](entries/1257/1257590-kenpou.org) | けんぽう | kenpou | 1257590 | learner | draft | **new** | Editorial review |
| N3-490 | [権利](entries/1258/1258200-kenri.org) | けんり | kenri | 1258200 | learner | draft | **new** | Editorial review |
| N3-491 | [ケース](entries/1047/1047880-ke-su.org) | ケース | ke-su | 1047880 | learner | draft | **new** | Editorial review |
| N3-492 | [下](entries/2080/2080200-ge.org) | げ | ge | 2080200 | learner | draft | **new** | Editorial review |
| N3-493 | [芸術](entries/1253/1253060-geijutsu.org) | げいじゅつ | geijutsu | 1253060 | learner | draft | **new** | Editorial review |
| N3-494 | [劇](entries/1253/1253310-geki.org) | げき | geki | 1253310 | learner | draft | **new** | Editorial review |
| N3-495 | [劇場](entries/1253/1253410-gekijou.org) | げきじょう | gekijou | 1253410 | learner | draft | **new** | Editorial review |
| N3-496 | [月](entries/2153/2153740-getsu.org) | げつ | getsu | 2153740 | learner | draft | **new** | Editorial review |
| N3-497 | [月曜](entries/1255/1255880-getsuyou.org) | げつよう | getsuyou | 1255880 | learner | draft | **new** | Editorial review |
| N3-498 | [限界](entries/1264/1264650-genkai.org) | げんかい | genkai | 1264650 | learner | draft | **new** | Editorial review |
| N3-499 | [現金](entries/1263/1263550-genkin.org) | げんきん | genkin | 1263550 | learner | draft | **new** | Editorial review |
| N3-500 | [言語](entries/1264/1264420-gengo.org) | げんご | gengo | 1264420 | learner | draft | **new** | Editorial review |
| N3-501 | [現在](entries/1263/1263650-genzai.org) | げんざい | genzai | 1263650 | learner | draft | **new** | Editorial review |
| N3-502 | [現象](entries/1263/1263750-genshou.org) | げんしょう | genshou | 1263750 | learner | draft | **new** | Editorial review |
| N3-503 | [現実](entries/1263/1263710-genjitsu.org) | げんじつ | genjitsu | 1263710 | learner | draft | **new** | Editorial review |
| N3-504 | [現状](entries/1263/1263770-genjou.org) | げんじょう | genjou | 1263770 | learner | draft | **new** | Editorial review |
| N3-505 | [現代](entries/1263/1263810-gendai.org) | げんだい | gendai | 1263810 | learner | draft | **new** | Editorial review |
| N3-506 | [現場](entries/1263/1263760-genba.org) | げんば | genba | 1263760 | learner | draft | **new** | Editorial review |
| N3-507 | [ゲーム](entries/1048/1048400-ge-mu.org) | ゲーム | ge-mu | 1048400 | learner | draft | **new** | Editorial review |
| N3-508 | [恋](entries/1558/1558670-koi.org) | こい | koi | 1558670 | learner | draft | **new** | Editorial review |
| N3-509 | [濃い](entries/1469/1469890-koi.org) | こい | koi | 1469890 | learner | draft | **new** | Editorial review |
| N3-510 | [恋人](entries/1558/1558920-koibito.org) | こいびと | koibito | 1558920 | learner | draft | **new** | Editorial review |
| N3-511 | [幸運](entries/1592/1592930-kouun.org) | こううん | kouun | 1592930 | learner | draft | **new** | Editorial review |
| N3-512 | [講演](entries/1282/1282240-kouen.org) | こうえん | kouen | 1282240 | learner | draft | **new** | Editorial review |
| N3-513 | [効果](entries/1275/1275130-kouka.org) | こうか | kouka | 1275130 | learner | draft | **new** | Editorial review |
| N3-514 | [硬貨](entries/1280/1280530-kouka.org) | こうか | kouka | 1280530 | learner | draft | **new** | Editorial review |
| N3-515 | [高価](entries/1283/1283300-kouka.org) | こうか | kouka | 1283300 | learner | draft | **new** | Editorial review |
| N3-516 | [交換](entries/1271/1271750-koukan.org) | こうかん | koukan | 1271750 | learner | draft | **new** | Editorial review |
| N3-517 | [航空](entries/1281/1281270-koukuu.org) | こうくう | koukuu | 1281270 | learner | draft | **new** | Editorial review |
| N3-518 | [光景](entries/1272/1272950-koukei.org) | こうけい | koukei | 1272950 | learner | draft | **new** | Editorial review |
| N3-519 | [貢献](entries/1282/1282410-kouken.org) | こうけん | kouken | 1282410 | learner | draft | **new** | Editorial review |
| N3-520 | [攻撃](entries/1279/1279170-kougeki.org) | こうげき | kougeki | 1279170 | learner | draft | **new** | Editorial review |
| N3-521 | [広告](entries/1278/1278510-koukoku.org) | こうこく | koukoku | 1278510 | learner | draft | **new** | Editorial review |
| N3-522 | [後者](entries/1269/1269720-kousha.org) | こうしゃ | kousha | 1269720 | learner | draft | **new** | Editorial review |
| N3-523 | [構成](entries/1279/1279730-kousei.org) | こうせい | kousei | 1279730 | learner | draft | **new** | Editorial review |
| N3-524 | [高速](entries/1283/1283700-kousoku.org) | こうそく | kousoku | 1283700 | learner | draft | **new** | Editorial review |
| N3-525 | [行動](entries/1282/1282100-koudou.org) | こうどう | koudou | 1282100 | learner | draft | **new** | Editorial review |
| N3-526 | [幸福](entries/1278/1278400-koufuku.org) | こうふく | koufuku | 1278400 | learner | draft | **new** | Editorial review |
| N3-527 | [公平](entries/1274/1274640-kouhei.org) | こうへい | kouhei | 1274640 | learner | draft | **new** | Editorial review |
| N3-528 | [候補](entries/1272/1272730-kouho.org) | こうほ | kouho | 1272730 | learner | draft | **new** | Editorial review |
| N3-529 | [考慮](entries/1281/1281170-kouryo.org) | こうりょ | kouryo | 1281170 | learner | draft | **new** | Editorial review |
| N3-530 | [越える](entries/1593/1593070-koeru.org) | こえる | koeru | 1593070 | learner | draft | **new** | Editorial review |
| N3-531 | [氷](entries/1488/1488840-koori.org) | こおり | koori | 1488840 | learner | draft | **new** | Editorial review |
| N3-532 | [凍る](entries/1593/1593100-kooru.org) | こおる | kooru | 1593100 | learner | draft | **new** | Editorial review |
| N3-533 | [呼吸](entries/1266/1266470-kokyuu.org) | こきゅう | kokyuu | 1266470 | learner | draft | **new** | Editorial review |
| N3-534 | [国語](entries/1286/1286370-kokugo.org) | こくご | kokugo | 1286370 | learner | draft | **new** | Editorial review |
| N3-535 | [黒板](entries/1288/1288080-kokuban.org) | こくばん | kokuban | 1288080 | learner | draft | **new** | Editorial review |
| N3-536 | [克服](entries/1285/1285790-kokufuku.org) | こくふく | kokufuku | 1285790 | learner | draft | **new** | Editorial review |
| N3-537 | [国民](entries/1287/1287070-kokumin.org) | こくみん | kokumin | 1287070 | learner | draft | **new** | Editorial review |
| N3-538 | [穀物](entries/1287/1287280-kokumotsu.org) | こくもつ | kokumotsu | 1287280 | learner | draft | **new** | Editorial review |
| N3-539 | [腰](entries/1288/1288340-koshi.org) | こし | koshi | 1288340 | learner | draft | **new** | Editorial review |
| N3-540 | [個人](entries/1264/1264770-kojin.org) | こじん | kojin | 1264770 | learner | draft | **new** | Editorial review |
| N3-541 | [越す](entries/1175/1175300-kosu.org) | こす | kosu | 1175300 | learner | draft | **new** | Editorial review |
| N3-542 | [国家](entries/1286/1286170-kokka.org) | こっか | kokka | 1286170 | learner | draft | **new** | Editorial review |
| N3-543 | [国会](entries/1286/1286240-kokkai.org) | こっかい | kokkai | 1286240 | learner | draft | **new** | Editorial review |
| N3-544 | [国境](entries/1286/1286320-kokkyou.org) | こっきょう | kokkyou | 1286320 | learner | draft | **new** | Editorial review |
| N3-545 | [骨折](entries/1288/1288640-kossetsu.org) | こっせつ | kossetsu | 1288640 | learner | draft | **new** | Editorial review |
| N3-546 | [小包](entries/1593/1593290-kozutsumi.org) | こづつみ | kozutsumi | 1593290 | learner | draft | **new** | Editorial review |
| N3-547 | [事](entries/1313/1313580-koto.org) | こと | koto | 1313580 | learner | draft | **new** | Editorial review |
| N3-548 | [異なる](entries/1157/1157510-kotonaru.org) | ことなる | kotonaru | 1157510 | learner | draft | **new** | Editorial review |
| N3-549 | [諺](entries/1264/1264600-kotowaza.org) | ことわざ | kotowaza | 1264600 | learner | draft | **new** | Editorial review |
| N3-550 | [断る](entries/1419/1419570-kotowaru.org) | ことわる | kotowaru | 1419570 | learner | draft | **new** | Editorial review |
| N3-551 | [粉](entries/1504/1504770-kona.org) | こな | kona | 1504770 | learner | draft | **new** | Editorial review |
| N3-552 | [好み](entries/1277/1277500-konomi.org) | このみ | konomi | 1277500 | learner | draft | **new** | Editorial review |
| N3-553 | [好む](entries/1277/1277520-konomu.org) | このむ | konomu | 1277520 | learner | draft | **new** | Editorial review |
| N3-554 | [小麦](entries/1348/1348630-komugi.org) | こむぎ | komugi | 1348630 | learner | draft | **new** | Editorial review |
| N3-555 | [小屋](entries/1347/1347830-koya.org) | こや | koya | 1347830 | learner | draft | **new** | Editorial review |
| N3-556 | [これ等](entries/1004/1004830-korera.org) | これら | korera | 1004830 | learner | draft | **new** | Editorial review |
| N3-557 | [頃](entries/1579/1579080-koro.org) | ころ | koro | 1579080 | learner | draft | **new** | Editorial review |
| N3-558 | [殺す](entries/1299/1299030-korosu.org) | ころす | korosu | 1299030 | learner | draft | **new** | Editorial review |
| N3-559 | [転ぶ](entries/1582/1582130-korobu.org) | ころぶ | korobu | 1582130 | learner | draft | **new** | Editorial review |
| N3-560 | [今回](entries/1289/1289070-konkai.org) | こんかい | konkai | 1289070 | learner | draft | **new** | Editorial review |
| N3-561 | [今後](entries/1289/1289140-kongo.org) | こんご | kongo | 1289140 | learner | draft | **new** | Editorial review |
| N3-562 | [混雑](entries/1290/1290390-konzatsu.org) | こんざつ | konzatsu | 1290390 | learner | draft | **new** | Editorial review |
| N3-563 | [こんなに](entries/1004/1004890-konnani.org) | こんなに | konnani | 1004890 | learner | draft | **new** | Editorial review |
| N3-564 | [困難](entries/1289/1289620-konnan.org) | こんなん | konnan | 1289620 | learner | draft | **new** | Editorial review |
| N3-565 | [今日は](entries/1289/1289400-konnichiha.org) | こんにちは | konnichiha | 1289400 | learner | draft | **new** | Editorial review |
| N3-566 | [婚約](entries/1289/1289710-konyaku.org) | こんやく | konyaku | 1289710 | learner | draft | **new** | Editorial review |
| N3-567 | [混乱](entries/1290/1290560-konran.org) | こんらん | konran | 1290560 | learner | draft | **new** | Editorial review |
| N3-568 | [コーチ](entries/1048/1048910-koochi.org) | コーチ | koochi | 1048910 | learner | draft | **new** | Editorial review |
| N3-569 | [コード](entries/1049/1049010-koodo.org) | コード | koodo | 1049010 | learner | draft | **new** | Editorial review |
| N3-570 | [後](entries/2147/2147630-go.org) | ご | go | 2147630 | learner | draft | **new** | Editorial review |
| N3-571 | [御](entries/1270/1270190-go.org) | ご | go | 1270190 | learner | draft | **new** | Editorial review |
| N3-572 | [語](entries/1270/1270910-go.org) | ご | go | 1270910 | learner | draft | **new** | Editorial review |
| N3-573 | [豪華](entries/1285/1285520-gouka.org) | ごうか | gouka | 1285520 | learner | draft | **new** | Editorial review |
| N3-574 | [合格](entries/1284/1284600-goukaku.org) | ごうかく | goukaku | 1284600 | learner | draft | **new** | Editorial review |
| N3-575 | [合計](entries/1284/1284740-goukei.org) | ごうけい | goukei | 1284740 | learner | draft | **new** | Editorial review |
| N3-576 | [強盗](entries/1236/1236500-goutou.org) | ごうとう | goutou | 1236500 | learner | draft | **new** | Editorial review |
| N3-577 | [誤解](entries/1271/1271310-gokai.org) | ごかい | gokai | 1271310 | learner | draft | **new** | Editorial review |
| N3-578 | [語学](entries/1271/1271010-gogaku.org) | ごがく | gogaku | 1271010 | learner | draft | **new** | Editorial review |
| N3-579 | [ゴミ](entries/1369/1369900-gomi.org) | ごみ | gomi | 1369900 | learner | draft | **new** | Editorial review |
| N3-580 | [御免なさい](entries/1270/1270680-gomennasai.org) | ごめんなさい | gomennasai | 1270680 | learner | draft | **new** | Editorial review |
| N3-581 | [ゴール](entries/1054/1054230-gooru.org) | ゴール | gooru | 1054230 | learner | draft | **new** | Editorial review |
| N3-582 | [差](entries/1291/1291070-sa.org) | さ | sa | 1291070 | learner | draft | **new** | Editorial review |
| N3-583 | [際](entries/1296/1296300-sai.org) | さい | sai | 1296300 | learner | draft | **new** | Editorial review |
| N3-584 | [最高](entries/1293/1293850-saikou.org) | さいこう | saikou | 1293850 | learner | draft | **new** | Editorial review |
| N3-585 | [最終](entries/1293/1293940-saishuu.org) | さいしゅう | saishuu | 1293940 | learner | draft | **new** | Editorial review |
| N3-586 | [最中](entries/1579/1579210-saichuu.org) | さいちゅう | saichuu | 1579210 | learner | draft | **new** | Editorial review |
| N3-587 | [最低](entries/1294/1294220-saitei.org) | さいてい | saitei | 1294220 | learner | draft | **new** | Editorial review |
| N3-588 | [才能](entries/1294/1294630-sainou.org) | さいのう | sainou | 1294630 | learner | draft | **new** | Editorial review |
| N3-589 | [裁判](entries/1296/1296120-saiban.org) | さいばん | saiban | 1296120 | learner | draft | **new** | Editorial review |
| N3-590 | [幸い](entries/1278/1278380-saiwai.org) | さいわい | saiwai | 1278380 | learner | draft | **new** | Editorial review |
| N3-591 | [サイン](entries/1056/1056230-sain.org) | サイン | sain | 1056230 | learner | draft | **new** | Editorial review |
| N3-592 | [境](entries/1235/1235950-sakai.org) | さかい | sakai | 1235950 | learner | draft | **new** | Editorial review |
| N3-593 | [逆らう](entries/1226/1226990-sakarau.org) | さからう | sakarau | 1226990 | learner | draft | **new** | Editorial review |
| N3-594 | [盛り](entries/1379/1379640-sakari.org) | さかり | sakari | 1379640 | learner | draft | **new** | Editorial review |
| N3-595 | [作業](entries/1297/1297540-sagyou.org) | さぎょう | sagyou | 1297540 | learner | draft | **new** | Editorial review |
| N3-596 | [作品](entries/1297/1297910-sakuhin.org) | さくひん | sakuhin | 1297910 | learner | draft | **new** | Editorial review |
| N3-597 | [作物](entries/1297/1297950-sakumotsu.org) | さくもつ | sakumotsu | 1297950 | learner | draft | **new** | Editorial review |
| N3-598 | [桜](entries/1593/1593710-sakura.org) | さくら | sakura | 1593710 | learner | draft | **new** | Editorial review |
| N3-599 | [酒](entries/1329/1329010-sake.org) | さけ | sake | 1329010 | learner | draft | **new** | Editorial review |
| N3-600 | [叫ぶ](entries/1235/1235910-sakebu.org) | さけぶ | sakebu | 1235910 | learner | draft | **new** | Editorial review |
| N3-601 | [避ける](entries/1583/1583260-sakeru.org) | さける | sakeru | 1583260 | learner | draft | **new** | Editorial review |
| N3-602 | [支える](entries/1310/1310090-sasaeru.org) | ささえる | sasaeru | 1310090 | learner | draft | **new** | Editorial review |
| N3-603 | [指す](entries/1309/1309670-sasu.org) | さす | sasu | 1309670 | learner | draft | **new** | Editorial review |
| N3-604 | [誘う](entries/1541/1541900-sasou.org) | さそう | sasou | 1541900 | learner | draft | **new** | Editorial review |
