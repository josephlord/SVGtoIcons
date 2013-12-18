SVGtoIcons
==========

Basic script to convert SVG files into icons and launch images for iOS (extendable to other things). This is quick and dirty and starting from blank non-functional project.

This project is inspired by [this blog post](http://throwachair.com/2013/10/26/generate-all-your-ios-app-icons-with-svg-and-inkscape/) although the plan is to add additional complexity.

It was originally created to assist with the icons for my Apps [Fast Lists](http://itunes.com/apps/fastlists) and [Phonics UK (only available in UK and Ireland)](http://itunes.com/apps/phonicsuk), please check them out on iTunes.

Please note that it is not yet polished or fast/efficient. It will launch Inkscape multiple times (at least once for each file you are creating). There is room for optimisation BUT it is much better than manually exporting multiple png sizes and unbelievably easier than tweaking the page parameters for each different shape of launch image.

Feel free to send Pull Requests or raise Issues and I'll try to look at them but if you need a change your best bet is to edit the script yourself, it is pretty short and simple.

Basic Commandline Use
---------------------

Assuming that you have already got Inkscape installed in /Applications on a Mac you shouldn't need to change the script file at all.

Just run `./svgtoicons.rb` with an SVG file for the launch image and 1024 pixel icon as `test_files/test_file.svg` and an icon file as `test_files/test_icon.svg`. It will then create launch image and icon png files in the `output` folder. The file names should clearly indicate the sizes of the output files to make it easy to insert into your Xcode project.

A regex is used to retreive the 'page' size from the SVG file, this may not be 100% reliable but worked fine with the SVG files I tested with.

Customisation and REPL usage
----------------------------

The script is really quite simple so you shouldn't have too much trouble modifiying it. The default actions only run when the script is run directly so there should be no side effects if you `require` it into your script or REPL.

These are the key functions although they rely on a couple of others to do the aspect fit calculations and to retreive the initial size from the SVG file.

### output_png(png_name, svg_name, width, height, background_colour=nil)

Outputs a png file to the requested name with the requested width and height. This is the core function relied on by the other convienience functions.

The original image is aspect fitted and centred in the png.

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
        <td>height</td><td>integer</td><td>Required output height in pixels.</td>
    </tr>
     <tr>
        <td>background_colour</td><td>string</td><td>Passed directly to Inkscape. Defaults to `#ffffff` (white).</td>
    </tr>
</table>

### ios_icon_sizes

Array of iOS icon sizes (`[58,120,29,40,80,76,152,1024]`) including for the App Store although it may be better to use a different image for the 1024 pixel icon. 

### ios_launch_image_sizes

 Sizes for launch images for iPhone and iPad, retina and non-retina, landscape and portrait: `[[640,960], [640,1136], [768,1024], [1536,2048], [1024,768], [2048,1536], [320,480],
 [768,1004], [1536,2008], [1024,748], [2048,1496]]`. 

### output_square_icons(sizes, svg_name, output_prefix, background_colour=nil)

Outputs a png for each array item in `sizes` at the requested size and with the name 'output_prefixX' where X is the size.

The original page is aspect fitted to the square and can optionally have a background_colour set.

<table>
    <tr>
        <td>sizes</td><td>array of integers</td><td>Output edge sizes for the (square) pngs. Defaults to `ios_icon_sizes`</td>
    </tr>
    <tr>
        <td>svg_name</td><td>string</td><td>The path and filename for the input svg file.</td>
    </tr>
    <tr>
      	<td>output_prefix</td><td>string</td><td>The path and filename for the output png files to which X.png will be appended where X is the size of the icon.</td>
    </tr>
     <tr>
        <td>background_colour</td><td>string</td><td>Passed directly to Inkscape. Defaults to `#ffffff` (white).</td>
    </tr>
</table>

### output_aspect_fit_rectangles(output_prefix, file_name, sizes)

Outputs pngs for each of the sizes in the array. Each array item can be an arbitrary rectangle and the original image will be aspect fitted into the rectangle and centred.

<table>
<tr>
    <td>output_prefix</td><td>string</td><td>The path and filename for the output png files to which X.png will be appended where X is the size of the icon.</td>
    </tr>
    <tr>
        <td>svg_name</td><td>string</td><td>The path and filename for the input svg file.</td>
    </tr>
    <tr>
        <td>sizes</td><td>array of arrays of integers</td><td>Output sizes. The inner arrays should have two integers (width and height). Default `ios_launch_image_sizes`.</td>
    </tr>
     <tr>
        <td>background_colour</td><td>string</td><td>Passed directly to Inkscape. Defaults to `#ffffff` (white).</td>
    </tr>

</table>

Future Possibilities
--------------------
### Use Cairo Library instead of Inkscape

The Inkscape requirement is a large and heavy one and up to date Inkscape is not available for OS X. The script would run far faster against the Cairo SVG libraries and could then be incorporated into a standalone application.

### Inkscape mode

You can carry out a series of actions on a single Inkscape instance which would be much faster but I have not explored this. Let me know if you get it running this way (or even better send a Pull Request)

### Tests

There are none, it would be nice to have some.

### Automatically generate XcAssets file

The new xcassets files look fairly simple, just a folder structure and some JSON files. It shouldn't be too hard to automatically create them but just for me doing it manually from the files created is good enough, massive use of this script could change this view.

### GUI app for the Mac App Store?

This would probably require using the Cairo library or similar instead of Inkscape.

Credits and Licensing
---------------------

Please also see [my blog post](http://blog.human-friendly.com/useful-svg-to-ios-icons-tip-using-inkscape).

This software is licensed under the GPLv2. I have chosen this as the same license as Inkscape itself even though this is not a derivative work of Inkscape. If you would like to discuss alternative licensing please get in touch.

