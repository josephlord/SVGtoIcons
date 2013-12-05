#!/usr/bin/env ruby

# ruby -e '[58,120,29,40,80,76,152,1024].each { |x| 
# 			`/Applications/Inkscape.app/Contents/Resources/bin/inkscape
#				--export-png icon#{x}.png -w #{x} icon.svg` }'

inkscape_app = '/Applications/Inkscape.app/Contents/Resources/bin/inkscape'
input_file_name = 'test_files/test_file.svg'

#original_width = `#{inkscape_app} -z -C -W #{input_file_name}`

ios_icon_sizes = [58,120,29,40,80,76,152,1024]
launch_image_sizes = []

# <svg[^<>]*width="([\d\.]*)"[^<>]*>
def get_svg_size(file_name)
	widthRegex = Regexp.new '<svg[^<>]*width="([\d\.]*)"[^<>]*>'
	heightRegex = Regexp.new '<svg[^<>]*height="([\d\.]*)"[^<>]*>'

	input_file = File.open(file_name)
	svg_header_string = input_file.readpartial(4096) # Overkill but if width/height not there definitely not in the file
	input_file.close

	width = widthRegex.match(svg_header_string)[1].to_f
	height = heightRegex.match(svg_header_string)[1].to_f
	return {height: height, width: width}
end

original_dimensions = get_svg_size(input_file_name)

puts "The original dimenstions are #{original_dimensions[:width]} by #{original_dimensions[:height]}"

def aspect_fit(width, height, original_width, original_height)
	if width == original_width && height == original_height
		return {x0: 0, y0: 0, x1: height, x2: width}
	end

			
end

def output_square_icons(sizes=ios_icon_sizes)
	export_area_arg = ''
	if original_height != original_width
		export_area = aspect_fit()
		export_area_arg = "--export-area=x0:y0:x1:y1"
	end
	`inkscape_app --export-background=#ffffff #{export_area_arg} --export-png icon#{x}.png -w #{x} icon.svg`
end