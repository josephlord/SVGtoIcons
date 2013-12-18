#!/usr/bin/env ruby

# Down to about line 122 is sort of the library used by the commands below which are all you really need to change to
# get exactly the images you need generated for your project. Or you can just import the file and use in your script or
# in the REPL

# This requires Inkscape (http://www.inkscape.org/) to be installed and you may have to edit the script if you are not on
# a Mac or Inkscape isn't installed in /Applications

# The script is designed to be edited to your requirements to operate on existing SVG files. Make sure you configure the
# 'page' in the SVG file as that is used to work out the frame of the SVG that you want to protect.

# Copyright Human Friendly Ltd. licensed under GPLv2.

# Original inspiration from http://throwachair.com/2013/10/26/generate-all-your-ios-app-icons-with-svg-and-inkscape/: 
# ruby -e '[58,120,29,40,80,76,152,1024].each { |x| 
# 			`/Applications/Inkscape.app/Contents/Resources/bin/inkscape
#				--export-png icon#{x}.png -w #{x} icon.svg` }'

# Inkscape docs that may prove relevant
# http://linux.die.net/man/1/inkscape
# 

# This method returns the path to the inkscape binary.
def inkscape_app
  '/Applications/Inkscape.app/Contents/Resources/bin/inkscape'
end

# These just set up some defaults, you can set these to whatever is appropriate.
input_file_name = 'test_files/test_file.svg'
output_folder = 'output'

# Use these variables as starting points or just define exactly what you need
ios_icon_sizes = [58,120,29,40,80,76,152,1024]
ios_launch_image_sizes = [[640,960],[640,1136],[768,1024],[1536,2048],[1024,768],[2048,1536],[320,480],[768,1004],[1536,2008],[1024,748],[2048,1496]]
itunes_store_icon_sizes = [[1024,1024]]

# Returns the dimensions of the SVG image with the file_name. Finds the 'page' dimensions as set in Inkscape. 
#
# A bit ugly but it seems to work - It uses a simple regex to find the values in the XML, might
# be better parsing properly but this does the job for now. Only tested on Inkscape files.
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

# Returns the rect {x0, y0, x1, y1} that minimally contains the original width and height centred within a rectangle
# that matches the aspect ratio of the requested width and height
# NOTE: The output size doesn't match  the requested just the shape - the output stage handles the actual output size
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


# Outputs a png file to the requested name with the requested width and height
# The original image is aspect fitted and centred in the png. The background colour can be set to apply
# to the extension (white is default)
def output_png(png_name,svg_name,width,height,background_colour=nil)
	background_colour ||= '#ffffff'
	original_dimensions = get_svg_size(svg_name)
	export_area = aspect_fit(width,height,original_dimensions[:width],original_dimensions[:height])
	export_area_arg = "--export-area=#{export_area[:x0]}:#{export_area[:y0]}:#{export_area[:x1]}:#{export_area[:y1]}"
	`#{inkscape_app} --export-background=#{background_colour} #{export_area_arg} --export-png #{png_name} -w #{width} #{svg_name}`
end

# Outputs a png for each array item at the requested size and with the name 'output_prefixX' where X is the size
# The original page is aspect fitted to the square and can optionally have a background_colour set.
# The array is of individual numbers as this is optimised for squares (aspect fit is only done once)
def output_square_icons(sizes=ios_icon_sizes,svg_name=input_file_name,output_prefix='output/icon', background_colour=nil)
	export_area_arg = ''
	background_colour ||= '#ffffff'
	original_dimensions = get_svg_size(svg_name)
	if original_dimensions[:height] != original_dimensions[:width]
		export_area = aspect_fit(1,1,original_dimensions[:width],original_dimensions[:height])
		export_area_arg = "--export-area=#{export_area[:x0]}:#{export_area[:y0]}:#{export_area[:x1]}:#{export_area[:y1]}"
	end
	sizes.each { |x| `#{inkscape_app} --export-background=#{background_colour} #{export_area_arg} --export-png #{output_prefix}#{x}.png -w #{x} #{svg_name}` }
end

# Outputs pngs for each of the sizes in the array. Each array item can be a different shape
def output_aspect_fit_rectangles( output_prefix='output/launch_image', svg_name='test_files/launch_image.svg', sizes=ios_launch_image_sizes)
	sizes.each do |size|
		width = size[0]
		height = size[1]
		output_png "#{output_prefix}#{width}x#{height}.png", svg_name, width, height
	end
end

#####
# The above is effectively the library and the following is the specific commands I run to generate the files I need for Fast Lists


# Run the commands if this file was run directly
if __FILE__ == $0

	# This uses the same image for the iTunes 1024 logo as for the launch images. You could obviously make different calls
	launch_image = 'test_files/test_file.svg'
	output_aspect_fit_rectangles 'output/launch_image', launch_image, ios_launch_image_sizes + itunes_store_icon_sizes

	# Create iOS icons plus 100pix square for an App Review Site
	icon_sizes = ios_icon_sizes + [100]
	output_square_icons ios_icon_sizes, 'test_files/test_icon.svg', 'output/icon'

	# This is for the custom requirements of my app (Fast Lists - http://itunes.com/apps/fastlists )
	# Add whatever you need for your app here
	if '-fl' == $1
		tick_box_sizes = [44,66,88,132]
		tick_box_files = ['tickBoxChecked','tickBox']
		tick_box_files.each { |f| output_square_icons tick_box_sizes, "test_files/#{f}.svg", "output/#{f}" }
	end
end

