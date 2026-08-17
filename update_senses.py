import re
import sys
import os

files = [
    "entries/1426/1426290-hiruyasumi.org",
    "entries/1450/1450270-fumu.org",
    "entries/1473/1473230-bai.org",
    "entries/1476/1476430-hazu.org",
    "entries/1477/1477170-hatsuon.org"
]

data_map = {
    "hiruyasumi": {
        "senses": {
            1: {
                "gloss": "- обідня перерва",
                "note": "Іменник, що позначає обідню перерву в школі або на роботі. Часто використовується для вказівки на час відпочинку в середині дня.",
                "examples": """*** beginner
- JA :: 昼休みに弁当を食べます。
- READING :: ひるやすみに べんとうを たべます。
- UK :: Під час обідньої перерви я їм бенто.
- EN :: I eat a bento during my lunch break.
- FOCUS :: 昼休み[ひるやすみ]に
*** neutral
- JA :: 今日の昼休みは図書館に行きました。
- READING :: きょうの ひるやすみは としょかんに いきました。
- UK :: Сьогодні в обідню перерву я ходив до бібліотеки.
- EN :: I went to the library during my lunch break today.
- FOCUS :: 昼休み[ひるやすみ]は
*** intermediate
- JA :: 会社の昼休みは12時から1時間です。
- READING :: かいしゃの ひるやすみは じゅうにじから いちじかんです。
- UK :: Обідня перерва в компанії триває одну годину з 12-ї.
- EN :: The lunch break at the company is for one hour starting from 12 o'clock.
- FOCUS :: 昼休み[ひるやすみ]は"""
            },
            "default": {
                "gloss": "- обідня перерва",
                "note": "Позначає перерву на обід або відпочинок посеред дня."
            }
        }
    },
    "fumu": {
        "senses": {
            1: {
                "gloss": "- наступати\n- топтати\n- ступати (на щось)",
                "note": "Перехідне дієслово. Означає фізичну дію наступання ногою на якийсь предмет або поверхню.",
                "examples": """*** beginner
- JA :: 犬の尻尾を踏みました。
- READING :: いぬの しっぽを ふみました。
- UK :: Я наступив собаці на хвіст.
- EN :: I stepped on the dog's tail.
- FOCUS :: 踏[ふ]みました
*** neutral
- JA :: ブレーキを踏むのが遅れました。
- READING :: ブレーキを ふむのが おくれました。
- UK :: Я запізнився з натисканням на гальма.
- EN :: I was late stepping on the brakes.
- FOCUS :: 踏[ふ]むのが
*** intermediate
- JA :: 満員電車で足を踏まれて痛かった。
- READING :: まんいんでんしゃで あしを ふまれて いたかった。
- UK :: Мені наступили на ногу в переповненому поїзді, і це було боляче.
- EN :: My foot was stepped on in the crowded train and it hurt.
- FOCUS :: 踏[ふ]まれて"""
            },
            2: {
                "gloss": "- ступати (на землю)\n- відвідувати",
                "note": "Використовується в переносному значенні, наприклад, ступати на чужу землю."
            },
            3: {
                "gloss": "- зазнавати\n- переживати (досвід)",
                "note": "Означає проходження через певний досвід або випробування (наприклад, 場数を踏む)."
            },
            4: {
                "gloss": "- дотримуватися (правил)\n- проходити (формальності)\n- виконувати",
                "note": "Вживається, коли йдеться про дотримання процедур або виконання кроків (наприклад, 手続きを踏む)."
            },
            5: {
                "gloss": "- оцінювати\n- припускати",
                "note": "Означає оцінку вартості або винесення судження щодо ситуації."
            },
            6: {
                "gloss": "- римувати",
                "note": "Використовується переважно у виразі «韻を踏む» (римувати)."
            },
            7: {
                "gloss": "- успадковувати (трон)",
                "note": "Вживається у контексті сходження на престол або успадкування титулу."
            },
            "default": {
                "gloss": "- наступати",
                "note": "Перехідне дієслово, що означає дію наступання ногою або проходження певних етапів."
            }
        }
    },
    "bai": {
        "senses": {
            1: {
                "gloss": "- вдвічі більше\n- подвійний",
                "note": "Іменник, що позначає подвійну кількість або розмір чогось.",
                "examples": """*** beginner
- JA :: 値段が倍になりました。
- READING :: ねだんが ばいに なりました。
- UK :: Ціна зросла вдвічі.
- EN :: The price has doubled.
- FOCUS :: 倍[ばい]に
*** neutral
- JA :: 彼の給料は私の倍です。
- READING :: かれの きゅうりょうは わたしの ばいです。
- UK :: Його зарплата вдвічі більша за мою.
- EN :: His salary is double mine.
- FOCUS :: 倍[ばい]です
*** intermediate
- JA :: 努力すれば、喜びも倍になるでしょう。
- READING :: どりょくすれば、よろこびも ばいに なるでしょう。
- UK :: Якщо докладете зусиль, ваша радість також подвоїться.
- EN :: If you make an effort, your joy will also double.
- FOCUS :: 倍[ばい]に"""
            },
            2: {
                "gloss": "- разів (більше)",
                "note": "Використовується як суфікс після числівників для позначення кратності (наприклад, 3倍 - у три рази)."
            },
            3: {
                "gloss": "- один з (певної кількості)",
                "note": "Позначає ймовірність або співвідношення, наприклад, 1 шанс із певної кількості."
            },
            "default": {
                "gloss": "- вдвічі більше\n- разів",
                "note": "Позначає подвійну кількість або слугує лічильним суфіксом для кратності."
            }
        }
    },
    "hazu": {
        "senses": {
            1: {
                "gloss": "- напевно\n- має бути\n- очікується",
                "note": "Допоміжне слово, яке виражає впевненість мовця у тому, що щось має статися або є правдою на основі об'єктивних фактів.",
                "examples": """*** beginner
- JA :: 彼は今日来るはずです。
- READING :: かれは きょう くる はずです。
- UK :: Він напевно прийде сьогодні.
- EN :: He is expected to come today.
- FOCUS :: くるはずです
*** neutral
- JA :: 荷物は明日届くはずだったのに、まだ来ない。
- READING :: にもつは あした とどく はずだったのに、まだ こない。
- UK :: Посилка мала прибути завтра, але ще не прийшла. (Або: Посилка мала прибути вчора - залежить від контексту, але тут \"мала б прибути\").
- EN :: The package was supposed to arrive tomorrow, but it hasn't come yet.
- FOCUS :: 届[とど]くはずだったのに
*** intermediate
- JA :: そんなはずはありません。何かの間違いです。
- READING :: そんな はずは ありません。なにかの まちがいです。
- UK :: Цього не може бути. Це якась помилка.
- EN :: That can't be. It must be some mistake.
- FOCUS :: はずは ありません"""
            },
            2: {
                "gloss": "- зарубка (на луку)",
                "note": "Іменник, що позначає виїмку на кінці лука для тятиви."
            },
            3: {
                "gloss": "- зарубка (на стрілі)",
                "note": "Іменник, що позначає виїмку на задньому кінці стріли."
            },
            4: {
                "gloss": "- захват у формі зарубки",
                "note": "Специфічний термін у сумо, що позначає певний вид захвату."
            },
            5: {
                "gloss": "- дерев'яна рама на щоглі",
                "note": "Технічний термін, що позначає дерев'яну деталь на традиційному японському судні."
            },
            "default": {
                "gloss": "- має бути\n- напевно",
                "note": "Допоміжне слово для вираження логічної впевненості або очікування."
            }
        }
    },
    "hatsuon": {
        "senses": {
            1: {
                "gloss": "- вимова",
                "note": "Іменник, який також може використовуватися як дієслово з суфіксом «する» (вимовляти). Позначає спосіб артикуляції звуків або слів.",
                "examples": """*** beginner
- JA :: 先生の発音はきれいです。
- READING :: せんせいの はつおんは きれいです。
- UK :: Вимова вчителя гарна.
- EN :: The teacher's pronunciation is beautiful.
- FOCUS :: 発音[はつおん]は
*** neutral
- JA :: この単語の発音が分かりません。
- READING :: この たんごの はつおんが わかりません。
- UK :: Я не знаю вимови цього слова.
- EN :: I don't know the pronunciation of this word.
- FOCUS :: 発音[はつおん]が
*** intermediate
- JA :: 英語の発音を良くするために、毎日練習しています。
- READING :: えいごの はつおんを よくする ために、まいにち れんしゅう しています。
- UK :: Я щодня тренуюся, щоб покращити свою англійську вимову.
- EN :: I practice every day to improve my English pronunciation.
- FOCUS :: 発音[はつおん]を"""
            },
            2: {
                "gloss": "- звукоутворення\n- створення звуку",
                "note": "Позначає фізичний процес утворення звуку."
            },
            "default": {
                "gloss": "- вимова",
                "note": "Позначає спосіб вимови слів або створення звуків."
            }
        }
    }
}

for filepath in files:
    key = filepath.split("-")[-1].replace(".org", "")
    if key not in data_map:
        print(f"Skipping {filepath}")
        continue
    
    with open("/Users/mac/projects/jisho/" + filepath, "r") as f:
        content = f.read()
    
    # Split by senses
    parts = re.split(r'(\* Sense s-\d+-\d+)', content)
    new_content = parts[0]
    
    for i in range(1, len(parts), 2):
        header = parts[i]
        body = parts[i+1]
        
        # Get sense index
        m = re.search(r':SOURCE_SENSE_INDEX:\s*(\d+)', body)
        if m:
            idx = int(m.group(1))
        else:
            idx = 1
            
        is_primary = ":LEARNER_PRIORITY: primary" in body
        
        sense_data = data_map[key]["senses"].get(idx, data_map[key]["senses"]["default"])
        
        # Replace ** Ukrainian glosses
        # Find where it is and if it exists
        if "** Ukrainian glosses" in body:
            body = re.sub(r'\*\* Ukrainian glosses\n(?:- .*\n)*', f'** Ukrainian glosses\n{sense_data["gloss"]}\n** Learner notes\n{sense_data["note"]}\n', body, count=1)
        else:
            # Append if missing? It should be there.
            pass
            
        if is_primary:
            if "** Examples" in body:
                body = re.sub(r'\*\* Examples\n.*?(?=\* Sense|\Z)', f'** Examples\n{sense_data["examples"]}\n', body, flags=re.DOTALL)
            else:
                body = re.sub(r'(\*\* Learner notes\n.*?\n)(?=\* Sense|\Z)', r'\1** Examples\n' + sense_data["examples"] + '\n', body, count=1, flags=re.DOTALL)
                
        new_content += header + body
        
    with open("/Users/mac/projects/jisho/" + filepath, "w") as f:
        f.write(new_content)
    
    print(f"Updated {filepath}")

