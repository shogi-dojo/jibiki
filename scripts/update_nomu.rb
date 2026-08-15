require 'fileutils'

file_path = 'entries/1169/1169870-nomu.org'
content = File.read(file_path)

updates = {
  1 => [
    { text: "ковтати" },
    { text: "приймати", qualifier: "ліки" }
  ],
  2 => [
    { text: "палити", qualifier: "тютюн" },
    { text: "курити" }
  ],
  3 => [
    { text: "поглинати" },
    { text: "заковтувати" }
  ],
  4 => [
    { text: "стримувати", qualifier: "гнів, сльози тощо" },
    { text: "пригнічувати" },
    { text: "затамовувати", qualifier: "подих" }
  ],
  5 => [
    { text: "приймати", qualifier: "вимоги, умови тощо" },
    { text: "погоджуватися" }
  ],
  6 => [
    { text: "недооцінювати" },
    { text: "ставитися зневажливо" }
  ],
  7 => [
    { text: "ховати", qualifier: "зброю тощо" },
    { text: "приховувати" }
  ]
}

updates.each do |sense_idx, glosses|
  search_str = "* Sense s-1169870-%03d\n" % sense_idx
  sense_start = content.index(search_str)
  next unless sense_start
  
  next_sense_start = content.index("* Sense s-1169870-", sense_start + 1)
  next_sense_start = content.length unless next_sense_start
  
  sense_block = content[sense_start...next_sense_start]
  
  existing_count = sense_block.scan(/\*\*\* uk-s-1169870-\d{3}-\d{3}/).size
  
  gloss_text = ""
  
  # Ensure "** Ukrainian glosses" is present if there were no previous glosses
  unless sense_block.include?("** Ukrainian glosses")
    gloss_text += "** Ukrainian glosses\n"
  end
  
  glosses.each_with_index do |g, i|
    gloss_index = existing_count + i + 1
    gloss_text += "*** uk-s-1169870-%03d-%03d\n:PROPERTIES:\n:END:\n- text :: %s\n" % [sense_idx, gloss_index, g[:text]]
    gloss_text += "- qualifier :: %s\n" % g[:qualifier] if g[:qualifier]
  end
  
  # For inserting we always append just after existing glosses. Or at the end.
  # The block ends with `** Ukrainian glosses\n` (if empty) or `** Ukrainian glosses\n*** ...\n...` 
  # So simply appending at the end is fine, but we should make sure the newlines are correct.
  if sense_block.end_with?("\n\n")
    new_sense_block = sense_block.sub(/\n\n\z/, "\n" + gloss_text + "\n")
  elsif sense_block.end_with?("\n")
    new_sense_block = sense_block.sub(/\n\z/, "\n" + gloss_text + "\n")
  else
    new_sense_block = sense_block + "\n" + gloss_text + "\n"
  end
  
  content = content[0...sense_start] + new_sense_block + content[next_sense_start..-1]
end

content.sub!("#+ENTRY_STATUS: untranslated", "#+ENTRY_STATUS: draft")

File.write(file_path, content)
puts "Updated #{file_path}"
