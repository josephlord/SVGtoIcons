#!/usr/bin/env ruby

# Original inspiration from: 
# ruby -e '[58,120,29,40,80,76,152,1024].each { |x| 
# 			`/Applications/Inkscape.app/Contents/Resources/bin/inkscape
#				--export-png icon#{x}.png -w #{x} icon.svg` }'
def inkscape_app
  '/Applications/Inkscape.app/Contents/Resources/bin/inkscape'
end
input_file_name = 'test_files/test_file.svg'
output_folder = 'output'

#original_width = `#{inkscape_app} -z -C -W #{input_file_name}`

ios_icon_sizes = [58,120,29,40,80,76,152,1024]
launch_image_sizes = [[640,960],[640,1160],[768,1024],[1536,2048],[1024,768],[2048,1536],[320,480],[768,1004],[1536,2008],[1024,748],[2048,1496]]

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

def aspect_fit(width, height, original_width, original_height)
	width = width.to_f
	height = height.to_f
	if width == original_width && height == original_height
		return {x0: 0, y0: 0, x1: height, x2: width}
	end
	orig_aspect_ratio = original_width / original_height
	req_aspect_ratio = width / height
	puts "Original ratio: #{orig_aspect_ratio}, requested ratio: #{req_aspect_ratio}"
	ret_rect = {}
	if req_aspect_ratio > orig_aspect_ratio
		# We are going to be height constrained
		ret_rect[:y0] = 0
		ret_rect[:y1] = original_height
		new_width = original_height * req_aspect_ratio
		puts "New width: #{new_width}"
		ret_rect[:x0] = 0.5 * (original_width - new_width)
		ret_rect[:x1] = 0.5 * (new_width + original_width)
	else
		# Width constrained
		ret_rect[:x0] = 0
		ret_rect[:x1] = original_width
		new_height = original_width / req_aspect_ratio
		puts "New height: #{new_width}"
		ret_rect[:y0] = 0.5 * (original_height - new_height)
		ret_rect[:y1] = 0.5 * (new_height + original_height)
	end
	ret_rect
end

def output_png(png_name,svg_name,width,height,background_colour=nil)
	background_colour ||= '#ffffff'
	original_dimensions = get_svg_size(svg_name)
	export_area = aspect_fit(width,height,original_dimensions[:width],original_dimensions[:height])
	export_area_arg = "--export-area=#{export_area[:x0]}:#{export_area[:y0]}:#{export_area[:x1]}:#{export_area[:y1]}"
	`#{inkscape_app} --export-background=#{background_colour} #{export_area_arg} --export-png #{png_name} -w #{width} #{svg_name}`
end

# Outputs a png of the name iconX.png where X is an item from the array
def output_square_icons(sizes=ios_icon_sizes,file_name=input_file_name,output_prefix='output/icon', background_colour=nil)
	export_area_arg = ''
	background_colour ||= '#ffffff'
	original_dimensions = get_svg_size(file_name)
	if original_dimensions[:height] != original_dimensions[:width]
		export_area = aspect_fit(1,1,original_dimensions[:width],original_dimensions[:height])
		export_area_arg = "--export-area=#{export_area[:x0]}:#{export_area[:y0]}:#{export_area[:x1]}:#{export_area[:y1]}"
	end
	sizes.each { |x| `#{inkscape_app} --export-background=#{background_colour} #{export_area_arg} --export-png #{output_prefix}#{x}.png -w #{x} #{file_name}` }
end

launch_image = 'test_files/test_file.svg'
icon_image = 'test_files/icon.svg'

launch_image_sizes.each do |size|
	width = size[0]
	height = size[1]
	output_png "output/launch#{width}x#{height}.png", launch_image, width, height
end

output_square_icons ios_icon_sizes, icon_image, 'output/icon'
