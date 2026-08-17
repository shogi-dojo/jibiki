import re

with open("entries/1355/1355810-baai.org", "r") as f:
    content = f.read()

senses = [
    ("- випадок\n- ситуація\n- обставини", "Часто використовується з часткою の (no) у конструкціях на зразок 〜の場合 (у випадку...), що виражає умову або гіпотетичну ситуацію."),
    ("- випадок\n- нагода", "Нідерландські відповідники."),
    ("- обставини\n- ситуація", "Нідерландські відповідники для 'ситуації'."),
    ("- випадок\n- обставина\n- ситуація", "Французькі відповідники."),
    ("- випадок\n- обставини\n- ситуація", "Німецькі відповідники."),
    ("- шухляда\n- сумка", "Угорські відповідники. (Ймовірно, помилково прив'язані до цього слова, але збережено згідно з оригіналом)."),
    ("- обставини\n- випадок\n- ситуація", "Російські відповідники, включно зі специфічними конструкціями 'у випадку (чогось) / якщо'."),
    ("- випадок\n- ситуація\n- обставини", "Іспанські відповідники.")
]

parts = content.split("** Ukrainian glosses\n")
new_content = parts[0]

primary_examples = """** Examples
- JA :: 雨の場合は、イベントは中止になります。
- READING :: あめのばあいは、イベントはちゅうしになります。
- UK :: У випадку дощу захід буде скасовано.
- EN :: In case of rain, the event will be canceled.
- FOCUS :: beginner
- JA :: 問題が発生した場合は、すぐに連絡してください。
- READING :: もんだいがはっせいしたばあいは、すぐにれんらくしてください。
- UK :: Якщо виникнуть проблеми, будь ласка, негайно зв'яжіться з нами.
- EN :: Please contact us immediately in the event that a problem occurs.
- FOCUS :: neutral
- JA :: 最悪の場合を想定して、計画を立てるべきだ。
- READING :: さいあくのばあいをそうていして、けいかくをたてるべきだ。
- UK :: Нам слід будувати плани, передбачаючи найгірший варіант розвитку подій.
- EN :: We should make plans assuming the worst-case scenario.
- FOCUS :: intermediate
"""

for i in range(8):
    gloss, note = senses[i]
    replacement = f"** Ukrainian glosses\n{gloss}\n** Learner notes\n{note}\n"
    if i == 0:
        replacement += primary_examples
    
    if i + 1 < len(parts):
        new_content += replacement + parts[i+1]
    else:
        new_content += replacement

with open("entries/1355/1355810-baai.org", "w") as f:
    f.write(new_content)
