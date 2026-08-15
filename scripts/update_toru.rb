require 'fileutils'

file_path = 'entries/1326/1326980-toru.org'
content = File.read(file_path)

updates = {
  1 => [
    { text: "схоплювати" },
    { text: "ловити" },
    { text: "тримати" }
  ],
  2 => [
    { text: "передавати" },
    { text: "подавати", qualifier: "щось комусь" }
  ],
  3 => [
    { text: "здобувати" },
    { text: "набувати" },
    { text: "брати", qualifier: "напр. відпустку" }
  ],
  4 => [
    { text: "приймати", qualifier: "метод, пропозицію тощо" },
    { text: "обирати" }
  ],
  5 => [
    { text: "прибирати" },
    { text: "позбавлятися" },
    { text: "знімати", qualifier: "капелюх, окуляри тощо" }
  ],
  6 => [
    { text: "забирати" },
    { text: "красти" },
    { text: "грабувати" }
  ],
  7 => [
    { text: "їсти" },
    { text: "приймати", qualifier: "вітаміни тощо" }
  ],
  8 => [
    { text: "збирати", qualifier: "квіти, врожай" },
    { text: "вичавлювати", qualifier: "сік" },
    { text: "ловити", qualifier: "рибу" }
  ],
  9 => [
    { text: "займати", qualifier: "час, місце" },
    { text: "приділяти" },
    { text: "виділяти" }
  ],
  10 => [
    { text: "бронювати" },
    { text: "зберігати" },
    { text: "відкладати" }
  ],
  11 => [
    { text: "розуміти", qualifier: "напр. жарт" },
    { text: "тлумачити" },
    { text: "осягати" }
  ],
  12 => [
    { text: "записувати" },
    { text: "фіксувати" }
  ],
  13 => [
    { text: "передплачувати", qualifier: "газету тощо" },
    { text: "купувати" }
  ],
  14 => [
    { text: "замовляти", qualifier: "доставку тощо" }
  ],
  15 => [
    { text: "стягувати", qualifier: "плату, штраф, податок" }
  ],
  16 => [
    { text: "брати", qualifier: "дружину, учня тощо" },
    { text: "усиновлювати" },
    { text: "приймати" }
  ],
  17 => [
    { text: "брати контроль" },
    { text: "ставати до", qualifier: "керма тощо" }
  ],
  18 => [
    { text: "змагатися" },
    { text: "грати", qualifier: "в карти, сумо тощо" }
  ]
}

# Fix missing glosses by appending carefully
updates.each do |sense_idx, glosses|
  search_str = "* Sense s-1326980-%03d\n" % sense_idx
  sense_start = content.index(search_str)
  next unless sense_start
  
  next_sense_start = content.index("* Sense s-1326980-", sense_start + 1)
  next_sense_start = content.length unless next_sense_start
  
  sense_block = content[sense_start...next_sense_start]
  
  # Count existing glosses in this block to determine the start index
  existing_count = sense_block.scan(/\*\*\* uk-s-1326980-\d{3}-\d{3}/).size
  
  gloss_text = ""
  glosses.each_with_index do |g, i|
    gloss_index = existing_count + i + 1
    gloss_text += "*** uk-s-1326980-%03d-%03d\n:PROPERTIES:\n:END:\n- text :: %s\n" % [sense_idx, gloss_index, g[:text]]
    gloss_text += "- qualifier :: %s\n" % g[:qualifier] if g[:qualifier]
  end
  
  # Insert at the very end of the sense block (before the next sense)
  if sense_block.end_with?("\n\n")
    new_sense_block = sense_block.sub(/\n\n\z/, "\n" + gloss_text + "\n")
  elsif sense_block.end_with?("\n")
    new_sense_block = sense_block.sub(/\n\z/, "\n" + gloss_text + "\n")
  else
    new_sense_block = sense_block + "\n" + gloss_text + "\n"
  end
  
  # For senses with NO existing ukrainian glosses, we must ensure "** Ukrainian glosses\n" is present.
  # But the template already has "** Ukrainian glosses\n" (except it might be trailing).
  # Wait, existing block looks like:
  # ** English glosses
  # - to pass
  # ** Ukrainian glosses
  # 
  # So it ends with "\n** Ukrainian glosses\n\n".
  # My append strategy will append AFTER "** Ukrainian glosses". That's exactly right.
  
  content = content[0...sense_start] + new_sense_block + content[next_sense_start..-1]
end

content.sub!("#+ENTRY_STATUS: untranslated", "#+ENTRY_STATUS: draft")

File.write(file_path, content)
puts "Updated #{file_path}"
