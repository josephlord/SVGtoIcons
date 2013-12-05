#!/usr/bin/env ruby

# ruby -e '[58,120,29,40,80,76,152,1024].each { |x| 
# 			`/Applications/Inkscape.app/Contents/Resources/bin/inkscape
#				--export-png icon#{x}.png -w #{x} icon.svg` }'

inkscape_app = '/Applications/Inkscape.app/Contents/Resources/bin/inkscape'
input_file_name = 'test_files/test_file.svg'

original_width = `#{inkscape_app} -z -C -W #{input_file_name}`

puts "The original width is: #{original_width}"

# <svg[^<>]*width="([\d\.]*)"[^<>]*>

widthRegex = Regexp.new '<svg[^<>]*width="([\d\.]*)"[^<>]*>'
heightRegex = '<svg[^<>]*height="([\d\.]*)"[^<>]*>'

input_file = File.open(input_file_name)
svg_header_string = input_file.readpartial(4096) # Overkill but if width/height not there definitely not in the file
input_file.close

puts "Width match: #{widthRegex.match(svg_header_string)[1].to_f/2.0}"
