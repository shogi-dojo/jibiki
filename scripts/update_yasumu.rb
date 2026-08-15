require 'fileutils'

file_path = 'entries/1227/1227560-yasumu.org'
content = File.read(file_path)

updates = {
  1 => [
    { text: "бути відсутнім", qualifier: "пропускати" },
    { text: "не прийти" },
    { text: "брати вихідний" }
  ],
  2 => [
    { text: "відпочивати" },
    { text: "робити перерву" }
  ],
  3 => [
    { text: "лягати спати" },
    { text: "йти спати" }
  ],
  4 => [
    { text: "призупиняти", qualifier: "діяльність тощо" }
  ]
}

updates.each do |sense_idx, glosses|
  search_str = "* Sense s-1227560-%03d\n" % sense_idx
  sense_start = content.index(search_str)
  next unless sense_start
  
  next_sense_start = content.index("* Sense s-1227560-", sense_start + 1)
  next_sense_start = content.length unless next_sense_start
  
  sense_block = content[sense_start...next_sense_start]
  
  gloss_text = "** Ukrainian glosses\n"
  glosses.each_with_index do |g, i|
    gloss_text += "*** uk-s-1227560-%03d-%03d\n:PROPERTIES:\n:END:\n- text :: %s\n" % [sense_idx, i+1, g[:text]]
    gloss_text += "- qualifier :: %s\n" % g[:qualifier] if g[:qualifier]
  end
  
  # The Ukrainian glosses section starts at "** Ukrainian glosses"
  # and ends at the next "** " (like "** Learner notes" or "** Examples") or end of string.
  if sense_block =~ /\*\* Ukrainian glosses\n(.*?)(?=\*\* |\z)/m
    new_sense_block = sense_block.sub(/\*\* Ukrainian glosses\n(.*?)(?=\*\* |\z)/m, gloss_text)
  else
    # If no Ukrainian glosses section exists, add it before "** Learner notes" if it exists, else end of block
    if sense_block =~ /\*\* Learner notes/
      new_sense_block = sense_block.sub(/\*\* Learner notes/, gloss_text + "** Learner notes")
    elsif sense_block =~ /\*\* Examples/
      new_sense_block = sense_block.sub(/\*\* Examples/, gloss_text + "** Examples")
    else
      new_sense_block = sense_block.chomp + "\n" + gloss_text
    end
  end
  
  content = content[0...sense_start] + new_sense_block + content[next_sense_start..-1]
end

content.sub!("#+ENTRY_STATUS: untranslated", "#+ENTRY_STATUS: draft")

File.write(file_path, content)
puts "Updated #{file_path}"
