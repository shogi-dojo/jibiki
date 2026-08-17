import re

def process_harau():
    with open('/Users/mac/projects/jisho/entries/1501/1501620-harau.org', 'r', encoding='utf-8') as f:
        content = f.read()

    def repl(m):
        sense_id = m.group(1)
        uk_text = ""
        notes = ""
        ex_text = ""
        
        if sense_id == '001':
            uk_text = "- платити\n- розплачуватися (напр., гроші, рахунок)"
            notes = "Перехідне дієслово 1-ї групи, що означає сплату грошей за товари, послуги чи борги."
            ex_text = """** Examples
*** beginner
- JA :: レジでお金を払います。
- READING :: レジでおかねをはらいます。
- UK :: Я плачу гроші на касі.
- EN :: I pay money at the cash register.
- FOCUS :: 払います
*** neutral
- JA :: 彼は夕食の代金を払ってくれました。
- READING :: かれはゆうしょくのだいきんをはらってくれました。
- UK :: Він заплатив за вечерю.
- EN :: He paid for dinner.
- FOCUS :: 払ってくれました
*** intermediate
- JA :: クレジットカードで払うことはできますか。
- READING :: クレジットカードではらうことはできますか。
- UK :: Чи можна розрахуватися кредитною карткою?
- EN :: Can I pay by credit card?
- FOCUS :: 払う
"""
        elif sense_id == '002':
            uk_text = "- змахувати\n- змітати\n- очищати\n- обрізати (гілки)"
            notes = "Використовується для опису дії змітання пилу чи бруду, а також змахування чогось."
        elif sense_id == '003':
            uk_text = "- проганяти\n- витісняти (напр., конкурентів)"
            notes = "Означає позбавлення або усунення чогось небажаного, наприклад конкурентів."
        elif sense_id == '004':
            uk_text = "- розпродавати\n- збувати\n- позбуватися"
            notes = "Використовується в контексті продажу речей, що більше не потрібні."
        elif sense_id == '005':
            uk_text = "- звертати (увагу)\n- виявляти (повагу, турботу)"
            notes = "Вживається з абстрактними поняттями (увага, повага тощо), означаючи їх виявлення."
        elif sense_id == '006':
            uk_text = "- докладати (зусилля, жертви)\n- витрачати"
            notes = "Використовується в значенні здійснення певних зусиль або пожертв."
        elif sense_id == '007':
            uk_text = "- виїжджати\n- звільняти приміщення"
            notes = "Використовується для позначення виселення або звільнення житла чи місця."
        elif sense_id == '008':
            uk_text = "- підсікати\n- збивати (напр., з ніг)"
            notes = "Фізична дія змітання або збивання з ніг у спорті чи в бою."
        elif sense_id == '009':
            uk_text = "- робити мазок\n- змах (у японській каліграфії)"
            notes = "Специфічний термін у японській каліграфії, що означає завершальний штрих із поступовим підняттям пензля."
        elif sense_id == '010':
            uk_text = "- скидати (рахівницю)"
            notes = "Використовується для позначення скидання кісточок на японській рахівниці (соробані) на нуль."
        else:
            uk_text = "- платити\n- змахувати"
            notes = "Це значення відповідає перекладу слова іншими мовами."
        
        ans = f"{m.group(0)}{uk_text}\n** Learner notes\n{notes}\n"
        if ex_text:
            ans += ex_text
        return ans

    content = re.sub(r'\* Sense s-1501620-(\d{3}).*?\*\* Ukrainian glosses\n', repl, content, flags=re.DOTALL)
    with open('/Users/mac/projects/jisho/entries/1501/1501620-harau.org', 'w', encoding='utf-8') as f:
        f.write(content)

def process_bunka():
    with open('/Users/mac/projects/jisho/entries/1505/1505120-bunka.org', 'r', encoding='utf-8') as f:
        content = f.read()

    def repl(m):
        sense_id = m.group(1)
        uk_text = ""
        notes = ""
        ex_text = ""
        
        if sense_id == '001':
            uk_text = "- культура\n- цивілізація"
            notes = "Іменник, що позначає культуру як сукупність матеріальних і духовних цінностей суспільства."
            ex_text = """** Examples
*** beginner
- JA :: 日本の文化に興味があります。
- READING :: にほんのぶんかにきょうみがあります。
- UK :: Я цікавлюся японською культурою.
- EN :: I am interested in Japanese culture.
- FOCUS :: 文化
*** neutral
- JA :: 言葉は文化の一部です。
- READING :: ことばはぶんかのいちぶです。
- UK :: Мова є частиною культури.
- EN :: Language is a part of culture.
- FOCUS :: 文化
*** intermediate
- JA :: 異なる文化を理解することが大切です。
- READING :: ことなるぶんかをりかいすることがたいせつです。
- UK :: Важливо розуміти різні культури.
- EN :: It is important to understand different cultures.
- FOCUS :: 文化
"""
        elif sense_id == '002':
            uk_text = "- ера Бунка (1804-1818)"
            notes = "Назва японської історичної ери (1804–1818)."
        else:
            uk_text = "- культура"
            notes = "Це значення відповідає перекладу слова іншими мовами."
        
        ans = f"{m.group(0)}{uk_text}\n** Learner notes\n{notes}\n"
        if ex_text:
            ans += ex_text
        return ans

    content = re.sub(r'\* Sense s-1505120-(\d{3}).*?\*\* Ukrainian glosses\n', repl, content, flags=re.DOTALL)
    with open('/Users/mac/projects/jisho/entries/1505/1505120-bunka.org', 'w', encoding='utf-8') as f:
        f.write(content)


def process_bungaku():
    with open('/Users/mac/projects/jisho/entries/1505/1505190-bungaku.org', 'r', encoding='utf-8') as f:
        content = f.read()

    def repl(m):
        sense_id = m.group(1)
        uk_text = ""
        notes = ""
        ex_text = ""
        
        if sense_id == '001':
            uk_text = "- література"
            notes = "Іменник, що означає літературу (як мистецтво або предмет вивчення)."
            ex_text = """** Examples
*** beginner
- JA :: 私は大学で文学を勉強しています。
- READING :: わたしはだいがくでぶんがくをべんきょうしています。
- UK :: Я вивчаю літературу в університеті.
- EN :: I study literature at university.
- FOCUS :: 文学
*** neutral
- JA :: 日本の近代文学についてレポートを書きました。
- READING :: にほんのきんだいぶんがくについてレポートをかきました。
- UK :: Я написав доповідь про сучасну японську літературу.
- EN :: I wrote a report on modern Japanese literature.
- FOCUS :: 文学
*** intermediate
- JA :: 彼は文学作品を通して社会問題を描いた。
- READING :: かれはぶんがくさくひんをとおしてしゃかいもんだいをえがいた。
- UK :: Через свої літературні твори він зобразив соціальні проблеми.
- EN :: He depicted social problems through his literary works.
- FOCUS :: 文学作品
"""
        else:
            uk_text = "- література"
            notes = "Це значення відповідає перекладу слова іншими мовами."
        
        ans = f"{m.group(0)}{uk_text}\n** Learner notes\n{notes}\n"
        if ex_text:
            ans += ex_text
        return ans

    content = re.sub(r'\* Sense s-1505190-(\d{3}).*?\*\* Ukrainian glosses\n', repl, content, flags=re.DOTALL)
    with open('/Users/mac/projects/jisho/entries/1505/1505190-bungaku.org', 'w', encoding='utf-8') as f:
        f.write(content)

if __name__ == '__main__':
    process_harau()
    process_bunka()
    process_bungaku()

