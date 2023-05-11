# Wuffl
<strong> 1. Introduction </strong>  
Wuffl is a simple image viewer which can move pictures either to a „selected“ folder or to a „delete“ folder. "Selected" and "Deleted" folders are located in the same folder as the chosen picture. Wuffl is available for Linux Ubuntu >=14.04, Mac and Windows.  

Imagine you review you vacation photographs and you need to select which pictures to show to your friends at the next party or you work your way through a bunch of old pictures and you need to select a view of them for a anniversary celebration. Wuffl allows you to move the picture to an extra folder ("Selected" folder) or to a "Deleted" folder while viewing it. 
<p>
Demo: https://www.youtube.com/watch?v=upL4r4l4CtI<br>
Source for the icons of the buttons: http://icons.mysitemyway.com  
</p>
<strong> 2. Installation </strong>  
To use the Wuffl image viewer you require:
<ul>
  <li> <a href="https://www.ruby-lang.org/en/downloads/"><code>ruby</code></a> (v2.4)
</ul>
as well as the following Ruby gems:  
<ul>
  <li><code>fastimage</code>
  <li><code>fileutils</code>
  <li><code>gtk3</code>
  <li><code>stringio</code></li>
</ul>  

Get the Wullf image viewer by typing ```git clone https://github.com/BluePeony/Wuffl.git``` in your command line.

<strong>3. Usage</strong>
Using your terminal or cmd go to the Wuffl folder and start Wuffl by typing  
<code> ruby wuffl_linux_all.rb </code> (for linux) or  
<code> ruby wuffl_win_all.rb </code> (for windows)
After starting Wuffl you'll see a start screen with a line of buttons at the bottom.  
To select an image go to the top left corner, klick on <code>File</code> → <code>Open file</code> and browse to the location of you images. Then select an image and click <code>open</code> or just doubleclick on the selected image. 

The buttons from left to right mean: <code>show previous image</code>, <code>rotate current image</code>, <code>move the current image to the folder 'Selected'</code>, <code>show next image</code>, <code>move the current image to the folder 'Deleted'</code>.

<strong>4. Remarks</strong>  
If you have any remarks, bugs, questions etc. please tell me, I'd be happy to help. 
