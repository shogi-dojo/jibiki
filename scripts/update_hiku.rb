require 'fileutils'

file_path = 'entries/1169/1169250-hiku.org'
content = File.read(file_path)

updates = {
  2 => [
    { text: "привертати", qualifier: "увагу, симпатію" }
  ],
  3 => [
    { text: "відводити", qualifier: "назад, про руку" },
    { text: "втягувати", qualifier: "підборіддя, живіт тощо" }
  ],
  4 => [
    { text: "тягнути", qualifier: "карту, фішку маджонгу" }
  ],
  5 => [
    { text: "проводити", qualifier: "лінію, план" }
  ],
  7 => [
    { text: "грати", qualifier: "на струнних або клавішних інструментах" }
  ],
  9 => [
    { text: "тягнути", qualifier: "транспортний засіб" }
  ],
  11 => [
    { text: "відступати" },
    { text: "спадати", qualifier: "про воду" },
    { text: "слабшати" }
  ],
  12 => [
    { text: "походити", qualifier: "від когось" },
    { text: "успадковувати", qualifier: "рису характеру" }
  ],
  13 => [
    { text: "цитувати" },
    { text: "наводити", qualifier: "як приклад або доказ" }
  ],
  14 => [
    { text: "проводити", qualifier: "електрику, газ, воду" },
    { text: "встановлювати", qualifier: "телефон" }
  ],
  15 => [
    { text: "тримати", qualifier: "ноту" }
  ],
  16 => [
    { text: "наносити", qualifier: "помаду" },
    { text: "змащувати", qualifier: "олією" },
    { text: "натирати", qualifier: "воском" }
  ],
  17 => [
    { text: "відступати" },
    { text: "відходити назад" }
  ],
  18 => [
    { text: "спадати", qualifier: "про жар, пухлину" },
    { text: "слабшати" }
  ],
  19 => [
    { text: "йти з посади" },
    { text: "залишати роботу" }
  ],
  20 => [
    { text: "знічуватися", qualifier: "від чиїхось слів або поведінки" },
    { text: "відсахуватися" }
  ],
  21 => [
    { text: "відступати", qualifier: "у грі ґо" }
  ]
}

updates.each do |sense_idx, glosses|
  search_str = "* Sense s-1169250-%03d\n" % sense_idx
  sense_start = content.index(search_str)
  next unless sense_start
  
  next_sense_start = content.index("* Sense s-1169250-", sense_start + 1)
  next_sense_start = content.length unless next_sense_start
  
  sense_block = content[sense_start...next_sense_start]
  
  gloss_text = "** Ukrainian glosses\n"
  glosses.each_with_index do |g, i|
    gloss_text += "*** uk-s-1169250-%03d-%03d\n:PROPERTIES:\n:END:\n- text :: %s\n" % [sense_idx, i+1, g[:text]]
    gloss_text += "- qualifier :: %s\n" % g[:qualifier] if g[:qualifier]
  end
  
  # Replacing just the last match of "** Ukrainian glosses" inside this block
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
