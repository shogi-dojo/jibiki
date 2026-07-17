# Dictionary entry progress

This is the merge ledger for the authored dictionary. It records what exists,
what has actually been reviewed, and what may be described as release-ready.
It must not be used to infer linguistic approval merely because an entry passes
the automated JMdict and Org checks.

Last reconciled with the entry tree: **2026-07-17** at entry commit
`5b32241`.

## Snapshot

| Metric | Current |
| --- | ---: |
| Canonical entry files | 291 |
| Canonical N5 entries | 290 |
| N5 queue rows covered | 298 / 667 (44.7%) |
| Extra seed entries | 1 (`日本語`) |
| `new` | 288 |
| `changes-requested` | 1 |
| `reviewed` | 2 |
| `confirmed` | 0 |
| `solid` | 0 |
| Entry metadata still marked `draft` | 291 |
| Learner profile | 290 |
| Enriched profile | 1 |

Queue rows 1–298 are represented without gaps. Eight queue aliases collapse
into existing JMdict entries, which is why 298 queue rows produce 290 canonical
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

- **青い / あおい (1381390):** sense 2 currently makes the fruit, vegetable,
  and traffic-light contexts sound archaic; sense 4 marks the literal
  “unripe” gloss as figurative. Correct both qualifiers, then repeat the
  editorial review.

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
| 3 | [青い](entries/1381/1381390-aoi.org) | あおい | aoi | 1381390 | learner | draft | **changes-requested** | Fix open sense 2/4 qualifiers; re-review |
| 4 | [赤](entries/2013/2013900-aka.org) | あか | aka | 2013900 | learner | draft | **new** | Editorial review |
| 5 | [赤い](entries/1383/1383240-akai.org) | あかい | akai | 1383240 | learner | draft | **new** | Editorial review |
| 6 | [明るい](entries/1532/1532350-akarui.org) | あかるい | akarui | 1532350 | learner | draft | **new** | Editorial review |
| 7 | [秋](entries/1332/1332650-aki.org) | あき | aki | 1332650 | learner | draft | **new** | Editorial review |
| 8–10 | [開く](entries/1586/1586270-aku.org) | あく | aku | 1586270 | learner | draft | **new** | Editorial review |
| 11–12 | [開ける](entries/1202/1202450-akeru.org) | あける | akeru | 1202450 | learner | draft | **new** | Editorial review |
| 13 | [上げる](entries/1352/1352320-ageru.org) | あげる | ageru | 1352320 | learner | draft | **new** | Editorial review |
| 14 | [朝](entries/1428/1428280-asa.org) | あさ | asa | 1428280 | learner | draft | **new** | Editorial review |
| 15 | [朝ご飯](entries/1586/1586330-asagohan.org) | あさごはん | asagohan | 1586330 | learner | draft | **new** | Editorial review |
| 16 | [明後日](entries/1584/1584640-asatte.org) | あさって | asatte | 1584640 | learner | draft | **new** | Editorial review |
| 17 | [足](entries/1404/1404630-ashi.org) | あし | ashi | 1404630 | learner | draft | **new** | Editorial review |
| 18 | [明日](entries/1584/1584660-ashita.org) | あした | ashita | 1584660 | learner | draft | **new** | Editorial review |
| 19 | [彼処](entries/1000/1000320-asoko.org) | あそこ | asoko | 1000320 | learner | draft | **new** | Editorial review |
| 20 | [遊ぶ](entries/1542/1542160-asobu.org) | あそぶ | asobu | 1542160 | learner | draft | **new** | Editorial review |
| 21–22 | [温かい](entries/1586/1586420-atatakai.org) | あたたかい | atatakai | 1586420 | learner | draft | **new** | Editorial review |
| 23 | [頭](entries/1582/1582310-atama.org) | あたま | atama | 1582310 | learner | draft | **new** | Editorial review |
| 24 | [新しい](entries/1361/1361490-atarashii.org) | あたらしい | atarashii | 1361490 | learner | draft | **new** | Editorial review |
| 25 | [彼方](entries/1483/1483185-achira.org) | あちら | achira | 1483185 | learner | draft | **new** | Editorial review |
| 26 | [暑い](entries/1343/1343460-atsui.org) | あつい | atsui | 1343460 | learner | draft | **new** | Editorial review |
| 27 | [熱い](entries/1467/1467720-atsui.org) | あつい | atsui | 1467720 | learner | draft | **new** | Editorial review |
| 28 | [厚い](entries/1275/1275320-atsui.org) | あつい | atsui | 1275320 | learner | draft | **new** | Editorial review |
| 29 | [後](entries/1269/1269320-ato.org) | あと | ato | 1269320 | learner | draft | **new** | Editorial review |
| 30 | [貴方](entries/1223/1223615-anata.org) | あなた | anata | 1223615 | learner | draft | **new** | Editorial review |
| 31 | [兄](entries/1249/1249900-ani.org) | あに | ani | 1249900 | learner | draft | **new** | Editorial review |
| 32 | [姉](entries/1307/1307630-ane.org) | あね | ane | 1307630 | learner | draft | **new** | Editorial review |
| 33–34 | [彼の](entries/1000/1000420-ano.org) | あの | ano | 1000420 | learner | draft | **new** | Editorial review |
| 35 | [アパート](entries/1017/1017760-apaato.org) | アパート | apaato | 1017760 | learner | draft | **new** | Editorial review |
| 36 | [浴びる](entries/1547/1547450-abiru.org) | あびる | abiru | 1547450 | learner | draft | **new** | Editorial review |
| 37 | [危ない](entries/1218/1218380-abunai.org) | あぶない | abunai | 1218380 | learner | draft | **new** | Editorial review |
| 38 | [甘い](entries/1213/1213400-amai.org) | あまい | amai | 1213400 | learner | draft | **new** | Editorial review |
| 39 | [余り](entries/1584/1584930-amari.org) | あまり | amari | 1584930 | learner | draft | **new** | Editorial review |
| 40 | [雨](entries/1171/1171900-ame.org) | あめ | ame | 1171900 | learner | draft | **new** | Editorial review |
| 41 | [飴](entries/1153/1153520-ame.org) | あめ | ame | 1153520 | learner | draft | **new** | Editorial review |
| 42 | [洗う](entries/1390/1390930-arau.org) | あらう | arau | 1390930 | learner | draft | **new** | Editorial review |
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
| seed | [日本語](entries/1464/1464530-nihongo.org) | にほんご | nihongo | 1464530 | enriched | draft | **new** | Editorial review |

