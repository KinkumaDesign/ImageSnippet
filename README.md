ImageSnippet is Adobe Fireworks(FW) Extention.

It generates snippet code in FW from selected slice info.

## screen shot ##

![screen shot](https://github.com/KinkumaDesign/ImageSnippet/raw/master/images/image_snippet2_en.png)

## how to use ##

###ex1###

Assume there is a slice such as this.

![screen shot](https://github.com/KinkumaDesign/ImageSnippet/raw/master/images/image_snippet1.png)

Select the slice. You have to select only one slice. Because ImageSnippet can't handle multiple slices.

Push insert button in command panel. 

Then snippet which include slice's property is exported in snippet area.

![screen shot](https://github.com/KinkumaDesign/ImageSnippet/raw/master/images/screenshot.gif)

The snippet is formatted text.
The format is written in format area.

Formatted text this time is this.

    <img width="%w" height="%h" src="images/%p" alt="">


There are strings, such as %w, %h, and %p.
These are converted to slice's name, width, and height.

You can get five properties.

 format  | slice property's name
 ------------- | ------------- 
 %p    | name
 %w    | width
 %h | height
 %x | x
 %y | y
 
You can write six format text which is include each tab.

###ex2###

Assume you write css file.
It is good for you that writing format such as..

    width:%wpx;
    height:%hpx;
    left:%xpx;
    top:%ypx;

Then the generated code is this.

    width:99px;
    height:95px;
    left:47px;
    top:60px;


It is also convenience to push clipboard button to send snippet code to OS's clipboard.

## Benefit ##

- It doesn't need to switch application frequently.
- It doesn't need to open dialog to insert image in coding editor.
- Your eyes won't be tired.

## How to install ##

1. Download the data. (In github, below Configuration)
2. Copy it to the application directory.

For example CS5 in mac

    /Applications/Adobe Fireworks CS5.1/Configuration/Command Panels/KinkumaUtility/ImageSnippet.swf
    /Applications/Adobe Fireworks CS5.1/Configuration/Command Panels/KinkumaUtility/jsf/ImageSnippet.jsf

3. Relaunch Fireworks.

4. Open menu Window > KinkumaUtility > ImageSnippet

5. Command Pannel is shown.

6. Use it.




