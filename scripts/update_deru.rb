require 'fileutils'

file_path = 'entries/1338/1338240-deru.org'
content = File.read(file_path)

updates = {
  3 => [
    { text: "просуватися вперед" },
    { text: "рухатися вперед" }
  ],
  4 => [
    { text: "доходити", qualifier: "до чогось" },
    { text: "вести", qualifier: "про дорогу" },
    { text: "досягати" }
  ],

  7 => [
    { text: "бути присутнім" },
    { text: "брати участь" },
    { text: "виступати", qualifier: "у змаганнях" }
  ],
  8 => [
    { text: "порушуватися", qualifier: "про питання" },
    { text: "висловлюватися" }
  ],
  9 => [
    { text: "продаватися" },
    { text: "мати попит" }
  ],
  10 => [
    { text: "перевищувати" },
    { text: "виходити за межі" }
  ],
  11 => [
    { text: "виступати", qualifier: "за межі" },
    { text: "стирчати" }
  ],
  12 => [
    { text: "спалахувати", qualifier: "про пожежу, хворобу" },
    { text: "виникати" }
  ],
  13 => [
    { text: "вироблятися" },
    { text: "видобуватися" }
  ],
  14 => [
    { text: "походити", qualifier: "від чогось" },
    { text: "випливати", qualifier: "з чогось" }
  ],
  15 => [
    { text: "подаватися", qualifier: "про їжу" },
    { text: "видаватися" },
    { text: "надаватися" }
  ],
  16 => [
    { text: "відповідати", qualifier: "на телефонний дзвінок" },
    { text: "відчиняти", qualifier: "двері" }
  ],
  17 => [
    { text: "діяти" },
    { text: "поводитися" },
    { text: "займати позицію" }
  ],
  18 => [
    { text: "набирати", qualifier: "швидкість" }
  ],
  19 => [
    { text: "текти", qualifier: "про сльози, кров тощо" }
  ],
  20 => [
    { text: "закінчувати", qualifier: "навчальний заклад" },
    { text: "випускатися" }
  ],
  21 => [
    { text: "кінчати", qualifier: "про еякуляцію" }
  ]
}

updates.each do |sense_idx, glosses|
  search_str = "* Sense s-1338240-%03d\n" % sense_idx
  sense_start = content.index(search_str)
  next unless sense_start
  
  next_sense_start = content.index("* Sense s-1338240-", sense_start + 1)
  next_sense_start = content.length unless next_sense_start
  
  sense_block = content[sense_start...next_sense_start]
  
  gloss_text = "** Ukrainian glosses\n"
  glosses.each_with_index do |g, i|
    gloss_text += "*** uk-s-1338240-%03d-%03d\n:PROPERTIES:\n:END:\n- text :: %s\n" % [sense_idx, i+1, g[:text]]
    gloss_text += "- qualifier :: %s\n" % g[:qualifier] if g[:qualifier]
  end
  
  if sense_block.include?("** Ukrainian glosses\n\n")
    new_sense_block = sense_block.sub("** Ukrainian glosses\n\n", gloss_text)
  elsif sense_block.include?("** Ukrainian glosses\n")
    new_sense_block = sense_block.sub("** Ukrainian glosses\n", gloss_text)
  elsif sense_block.include?("** Ukrainian glosses")
    new_sense_block = sense_block.sub("** Ukrainian glosses", gloss_text)
  end
  
  content = content[0...sense_start] + new_sense_block + content[next_sense_start..-1]
end

content.sub!("#+ENTRY_STATUS: untranslated", "#+ENTRY_STATUS: draft")

File.write(file_path, content)
puts "Updated #{file_path}"
