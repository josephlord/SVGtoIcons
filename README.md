SVGtoIcons
==========

Basic script to convert SVG files into icons and launch images for iOS (extendable to other things). This is quick and dirty and starting from blank non-functional project.

This project is inspired by [this blog post](http://throwachair.com/2013/10/26/generate-all-your-ios-app-icons-with-svg-and-inkscape/) although the plan is to add additional complexity.

It was originally created to assist with the icons for my Apps [Fast Lists](http://itunes.com/apps/fastlists) and [Phonics UK (only available in UK and Ireland)](http://itunes.com/apps/phonicsuk), please check them out on iTunes.

Basic Commandline Use
---------------------

Assuming that you have already got Inkscape installed in /Applications on a Mac you shouldn't need to change the script file at all.

Just run `./convert.rb` with an SVG file for the launch image and 1024 pixel icon as `test_files/test_file.svg` and an icon file as `test_files/test_icon.svg`. It will then create launch image and icon png files in the `output` folder. The file names should clearly indicate the sizes of the output files to make it easy to insert into your Xcode project.

A regex is used to retreive the 'page' size from the SVG file, this may not be 100% reliable but worked fine with the SVG files I tested with.

Customisation and REPL usage
----------------------------

The script is really quite simple so you shouldn't have too much trouble modifiying it. The default actions only run when the script is run directly so there should be no side effects if you `require` it into your script or REPL.

These are the key functions although they rely on a couple of others to do the aspect fit calculations and to retreive the initial size from the SVG file.

### output_png(png_name,svg_name,width,height,background_colour=nil)

Outputs a png file to the requested name with the requested width and height. This is the core function relied on by the other convienience functions.

The original image is aspect fitted and centred in the png. The background colour can be set (white is default).

<table>
    <tr>
        <td>png_name</td><td>string</td><td>The path and filename for the output png file.</td>
    </tr>
    <tr>
        <td>svg_name</td><td>string</td><td>The path and filename for the input svg file.</td>
    </tr>
    <tr>
        <td>width</td><td>integer</td><td>Required output width in pixels.</td>
    </tr>
    <tr>
        <td>width</td><td>integer</td><td>Required output width in pixels.</td>
    </tr>
        <tr>
        <td>height</td><td>integer</td><td>Required output height in pixels.</td>
    </tr>
</table>


###

# Outputs a png for each array item at the requested size and with the name 'output_prefixX' where X is the size
# The original page is aspect fitted to the square and can optionally have a background_colour set.
# The array is of individual numbers as this is optimised for squares (aspect fit is only done once)
def output_square_icons(sizes=ios_icon_sizes,file_name=input_file_name,output_prefix='output/icon', background_colour=nil)


# Outputs pngs for each of the sizes in the array. Each array item can be a different shape
def output_aspect_fit_rectangles( output_prefix='output/launch_image', file_name='test_files/launch_image.svg', sizes=ios_icon_sizes)
```

Credits and Licensing
---------------------

Please also see [my blog post](http://blog.human-friendly.com/useful-svg-to-ios-icons-tip-using-inkscape).

This software is licensed under the GPLv2. I have chosen this as the same license as Inkscape itself even though this is not a derivative work of Inkscape. If you would like to discuss alternative licensing please get in touch.

