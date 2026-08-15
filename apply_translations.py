import os

def update_file(filepath, replacements):
    with open(filepath, 'r') as f:
        content = f.read()

    # Update entry status
    content = content.replace('#+ENTRY_STATUS: untranslated', '#+ENTRY_STATUS: draft')

    # Apply all other replacements
    for target, replacement in replacements:
        if target not in content:
            print(f"Failed to find target in {filepath}:\n{target}")
            print(f"Content length: {len(content)}")
        content = content.replace(target, replacement)
        
    with open(filepath, 'w') as f:
        f.write(content)

# File 1
noru_path = '/Users/mac/projects/jisho/entries/1355/1355120-noru.org'
noru_replacements = [
    (
        "** Ukrainian glosses\n\n* Sense s-1355120-003",
        """** Ukrainian glosses
*** uk-s-1355120-002-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: ставати (на щось)
*** uk-s-1355120-002-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: сідати (на щось)

* Sense s-1355120-003"""
    ),
    (
        "** Ukrainian glosses\n\n* Sense s-1355120-004",
        """** Ukrainian glosses
*** uk-s-1355120-003-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: досягати
*** uk-s-1355120-003-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: перевершувати

* Sense s-1355120-004"""
    ),
    (
        "** Ukrainian glosses\n\n* Sense s-1355120-005",
        """** Ukrainian glosses
*** uk-s-1355120-004-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: слідувати
*** uk-s-1355120-004-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: йти в ногу (з часом)

* Sense s-1355120-005"""
    ),
    (
        "** Ukrainian glosses\n\n* Sense s-1355120-006",
        """** Ukrainian glosses
*** uk-s-1355120-005-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: брати участь
*** uk-s-1355120-005-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: приєднуватися

* Sense s-1355120-006"""
    ),
    (
        "** Ukrainian glosses\n\n* Sense s-1355120-007",
        """** Ukrainian glosses
*** uk-s-1355120-006-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: входити в ритм
*** uk-s-1355120-006-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: захоплюватися

* Sense s-1355120-007"""
    ),
    (
        "** Ukrainian glosses\n\n* Sense s-1355120-008",
        """** Ukrainian glosses
*** uk-s-1355120-007-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: бути обманутим
*** uk-s-1355120-007-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: попастися (на гачок)

* Sense s-1355120-008"""
    ),
    (
        "** Ukrainian glosses\n\n* Sense s-1355120-009",
        """** Ukrainian glosses
*** uk-s-1355120-008-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: розноситися
*** uk-s-1355120-008-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: поширюватися

* Sense s-1355120-009"""
    ),
    (
        "** Ukrainian glosses\n",
        """** Ukrainian glosses
*** uk-s-1355120-009-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: лягати (про фарбу)
*** uk-s-1355120-009-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: приставати
"""
    )
]


neru_path = '/Users/mac/projects/jisho/entries/1360/1360010-neru.org'
neru_replacements = [
    (
        "** Ukrainian glosses\n\n* Sense s-1360010-003",
        """** Ukrainian glosses
*** uk-s-1360010-002-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: лягати в ліжко
*** uk-s-1360010-002-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: лежати в ліжку

* Sense s-1360010-003"""
    ),
    (
        "** Ukrainian glosses\n\n* Sense s-1360010-004",
        """** Ukrainian glosses
*** uk-s-1360010-003-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: лягати

* Sense s-1360010-004"""
    ),
    (
        "** Ukrainian glosses\n\n* Sense s-1360010-005",
        """** Ukrainian glosses
*** uk-s-1360010-004-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: спати (з кимось)
*** uk-s-1360010-004-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: мати статеві стосунки

* Sense s-1360010-005"""
    ),
    (
        "** Ukrainian glosses\n\n* Sense s-1360010-006",
        """** Ukrainian glosses
*** uk-s-1360010-005-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: лежати гладко (про волосся)

* Sense s-1360010-006"""
    ),
    (
        "** Ukrainian glosses\n\n* Sense s-1360010-007",
        """** Ukrainian glosses
*** uk-s-1360010-006-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: лежати без діла (про кошти, запаси)
*** uk-s-1360010-006-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: простоювати

* Sense s-1360010-007"""
    ),
    (
        "** Ukrainian glosses\n",
        """** Ukrainian glosses
*** uk-s-1360010-007-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: бродити
*** uk-s-1360010-007-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: ферментуватися
"""
    )
]

naru_path = '/Users/mac/projects/jisho/entries/1375/1375610-naru.org'
naru_replacements = [
    (
        """** Ukrainian glosses
*** uk-s-1375610-002-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-07-18
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: складатися з

* Sense s-1375610-003""",
        """** Ukrainian glosses
*** uk-s-1375610-002-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: закінчуватися (чим-небудь)
*** uk-s-1375610-002-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: виявлятися
*** uk-s-1375610-002-003
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: обертатися (чим-небудь)

* Sense s-1375610-003"""
    ),
    (
        "** Ukrainian glosses\n\n* Sense s-1375610-004",
        """** Ukrainian glosses
*** uk-s-1375610-003-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: складатися з

* Sense s-1375610-004"""
    ),
    (
        "** Ukrainian glosses\n\n* Sense s-1375610-005",
        """** Ukrainian glosses
*** uk-s-1375610-004-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: бути завершеним
*** uk-s-1375610-004-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: бути реалізованим
*** uk-s-1375610-004-003
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: здійснюватися

* Sense s-1375610-005"""
    ),
    (
        "** Ukrainian glosses\n\n* Sense s-1375610-006",
        """** Ukrainian glosses
*** uk-s-1375610-005-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: перетворюватися
*** uk-s-1375610-005-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: ставати (ким-небудь, чим-небудь)

* Sense s-1375610-006"""
    ),
    (
        "** Ukrainian glosses\n\n* Sense s-1375610-007",
        """** Ukrainian glosses
*** uk-s-1375610-006-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: починати (робити щось)
*** uk-s-1375610-006-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: доходити до (чогось)

* Sense s-1375610-007"""
    ),
    (
        "** Ukrainian glosses\n\n* Sense s-1375610-008",
        """** Ukrainian glosses
*** uk-s-1375610-007-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: складати (суму)
*** uk-s-1375610-007-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: дорівнювати

* Sense s-1375610-008"""
    ),
    (
        "** Ukrainian glosses\n\n* Sense s-1375610-009",
        """** Ukrainian glosses
*** uk-s-1375610-008-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: виконувати роль
*** uk-s-1375610-008-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: виступати в ролі

* Sense s-1375610-009"""
    ),
    (
        "** Ukrainian glosses\n\n* Sense s-1375610-010",
        """** Ukrainian glosses
*** uk-s-1375610-009-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: використовуватися для
*** uk-s-1375610-009-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: слугувати для

* Sense s-1375610-010"""
    ),
    (
        "** Ukrainian glosses\n\n* Sense s-1375610-011",
        """** Ukrainian glosses
*** uk-s-1375610-010-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: перетворюватися (у сьоґі)

* Sense s-1375610-011"""
    ),
    (
        "** Ukrainian glosses\n",
        """** Ukrainian glosses
*** uk-s-1375610-011-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: робити (ввічливо)
"""
    )
]

sensei_path = '/Users/mac/projects/jisho/entries/1387/1387990-sensei.org'
sensei_replacements = [
    (
        "** Ukrainian glosses\n\n* Sense s-1387990-003",
        """** Ukrainian glosses
*** uk-s-1387990-002-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: сенсей (звернення до вчителя, лікаря, юриста)

* Sense s-1387990-003"""
    ),
    (
        "** Ukrainian glosses\n\n* Sense s-1387990-004",
        """** Ukrainian glosses
*** uk-s-1387990-003-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: жартівливе звернення

* Sense s-1387990-004"""
    ),
    (
        "** Ukrainian glosses\n",
        """** Ukrainian glosses
*** uk-s-1387990-004-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: старший (за віком)
"""
    )
]

sentaku_path = '/Users/mac/projects/jisho/entries/1390/1390980-sentaku.org'
sentaku_replacements = [
    (
        "** Ukrainian glosses\n",
        """** Ukrainian glosses
*** uk-s-1390980-002-001
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: відпочинок
*** uk-s-1390980-002-002
:PROPERTIES:
:TRANSLATOR_ID: antigravity
:TRANSLATED_AT: 2026-08-15
:REVIEWER_ID:
:REVIEWED_AT:
:END:
- text :: відновлення сил
"""
    )
]

for path, repls in [
    (noru_path, noru_replacements),
    (neru_path, neru_replacements),
    (naru_path, naru_replacements),
    (sensei_path, sensei_replacements),
    (sentaku_path, sentaku_replacements)
]:
    update_file(path, repls)
