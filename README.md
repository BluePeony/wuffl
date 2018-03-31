# Wuffl
<strong> 1. Introduction </strong>  
Wuffl is a simple image viewer which can move pictures either to a so called „pictureshow“ folder or to a „delete“ folder. Pictureshow and delete folders are located in the same folder as the chosen picture. Wuffl is available for Linux Ubuntu 14.04 and higher and Windows10.  

Imagine you review you vacation pictures and you need to select which pictures to show to your parents at the next family dinner or you work your way through a bunch of old pictures and you need to select a view for a anniversary celebration. Using a common image viewer you'll probably write down the names of the chosen pictures, then carefully select the pictures by the names you just wrote down, copy and then paste them in a new folder. At least that's the way I used to do it. Since it was a little bit annoying I came up with a new simple image viewer which helps you to move the picture to an extra folder (pictureshow folder) or to a delete folder.  
Source for the icons of the buttons: http://icons.mysitemyway.com  

<strong> 2. Installation </strong>  
To use the Wuffl image viewer you require:
<ul>
  <li> <a href="https://www.ruby-lang.org/en/downloads/"><code>ruby</code></a> (v2.4)
</ul>
as well as the following gems:  
<ul>
  <li><code>fastimage</code>
  <li><code>fileutils</code>
  <li><code>gtk3</code>
</ul>  
<strong>For Linux Ubuntu</strong> you need to download the following files:
<ul>
  <li>wuffl_functions.rb
  <li>wuffl_linux_all.rb
  <li>wuffl_linux_single.rb
  <li>empty_pic.png
  <li>next.png
  <li>pictureshow.png
  <li>prev.png
  <li>rotate.png
  <li>trash_can.png
</ul>

<strong>For Windows10 </strong> you need to download the following files:<ul>
  <li>wuffl_functions.rb
  <li>wuffl_win_all.rb
  <li>wuff_win_single.rb
  <li>empty_pic.png
  <li>next.png
  <li>pictureshow.png
  <li>prev.png
  <li>rotate.png
  <li>trash_can.png
</ul>

Create a new folder „wuffl“ where it's most convinient for you and put all downloaded files in that folder.
Using your terminal or cmd go to the wuffl folder and once you're there start Wuffl by typing
ruby wuffl_linux_all.rb (for linux)
ruby wuffl_win_all.rb (for windows)

Remark: there are two versions of Wuffl image viewer: wuffl_linux/win_all.rb and wuffl_linux/win_single.rb. Both versions are available for Linux as well as vor Windows. Both versions have the same functionalities. Just the way of execution differs a little bit.
 
In *_all.rb version as soon as you selected the first image to show the program buffers all images available in that folder.  Pro: you can switch to the next images very quickly. Con: in case your images are quiet big and/or you have a lot of them it may take some time for the program to load all of them. 

In *_single.rb version the program buffers only one image at a time. Pro: you can see the first image quickly. Con: when you click on the „next“ button to see the next picutre it may take a moment before you actually see it in case your image is large/big.   

You may notice the difference only in case of really large images. So just try which version suits you best.

