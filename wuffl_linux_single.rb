require 'gtk3'
require 'fileutils'
require 'fastimage'
require_relative 'wuffl_functions.rb'

#finding out the current resolution
output_dimensions = `xdpyinfo | grep dimensions`
output_dimensions.tr!(" ","")
start_index = output_dimensions.index(":") + 1
end_index = output_dimensions.index("p") - 1
width_height_dim = output_dimensions.slice(start_index..end_index)

WINDOW_WIDTH = width_height_dim.slice(0..width_height_dim.index("x")-1).to_i
WINDOW_HEIGHT = width_height_dim.slice(width_height_dim.index("x")+1.. width_height_dim.length-1).to_i

IMG_MAX_W = (WINDOW_WIDTH * 0.43).to_i #max width for each image in pixels
IMG_MAX_H = (WINDOW_HEIGHT * 0.43).to_i #max height for each image in pixels

REDUCTION_FACTOR = 0.95

window = Gtk::Window.new
window.set_title "Wuffl"
window.set_window_position :center
window.set_default_size WINDOW_WIDTH, WINDOW_HEIGHT
window.signal_connect("destroy") {Gtk.main_quit}

vbox = Gtk::Box.new :vertical, 5
hbox = Gtk::Box.new :horizontal, 10

pb_current = GdkPixbuf::Pixbuf.new #current pixbuf
pb_portrait = GdkPixbuf::Pixbuf.new #pixbuf in portrait format (relevant only for rotations)
img_current = Gtk::Image.new  #current image

dir_path = "" #path of the image folder
pictureshow_path = ""
deleted_path = ""
all_orig_img = []
all_orig_pb = []
ind = 0
rotation_case = 'A' #relevant only for rotations
filename = ""
next_name_to_load = ""
ind_to_load = 0
is_landscape = true
 
halign = Gtk::Alignment.new 0.5, 0, 0, 0

#-----------Definition of Buttons ----------
prev_pb = GdkPixbuf::Pixbuf.new :file => "prev.png", :width => 50, :height => 50
next_pb = GdkPixbuf::Pixbuf.new :file => "next.png", :width => 50, :height => 50
rotate_pb = GdkPixbuf::Pixbuf.new :file => "rotate.png", :width => 50, :height => 50
picshow_pb = GdkPixbuf::Pixbuf.new :file => "pictureshow.png", :width => 50, :height => 50
delete_pb = GdkPixbuf::Pixbuf.new :file => "trash_can.png", :width => 50, :height => 50

prev_img = Gtk::Image.new :pixbuf => prev_pb
next_img = Gtk::Image.new :pixbuf => next_pb
rotate_img = Gtk::Image.new :pixbuf => rotate_pb
picshow_img = Gtk::Image.new :pixbuf => picshow_pb
delete_img = Gtk::Image.new :pixbuf => delete_pb

#-----------Previous-Button----------------------
prev_btn = Gtk::Button.new 
prev_btn.set_image(prev_img)
prev_btn.set_tooltip_text "previous image"
prev_btn.sensitive = false

#-----------Next-Button-----------------------
next_btn = Gtk::Button.new
next_btn.set_image(next_img)
next_btn.set_tooltip_text "next image"
next_btn.sensitive = false

#-----------Rotate-Button----------------------
rotate_btn = Gtk::Button.new
rotate_btn.set_image(rotate_img)
rotate_btn.set_tooltip_text "rotate image"
rotate_btn.sensitive = false

#-----------Pictureshow-Button-----------------
show_btn = Gtk::Button.new
show_btn.set_image(picshow_img)
show_btn.set_tooltip_text "add image to pictureshow"
show_btn.sensitive = false

#-----------Delete-Button---------------------
delete_btn = Gtk::Button.new
delete_btn.set_image(delete_img)
delete_btn.set_tooltip_text "delete image"
delete_btn.sensitive = false

#--------------End of Button Definitions -----------------

#-----------Beginn Menu---------------------
mb = Gtk::MenuBar.new

filemenu = Gtk::Menu.new
file = Gtk::MenuItem.new :label => "File"
file.set_submenu filemenu

open_file = Gtk::MenuItem.new :label => "Open file"
open_file.signal_connect("activate") do |w|
	dialog = Gtk::FileChooserDialog.new(:title => "Open file", :parent => window, :action => Gtk::FileChooserAction::OPEN, 
	:buttons => [[Gtk::Stock::OPEN, Gtk::ResponseType::ACCEPT], [Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL]])

	if dialog.run == Gtk::ResponseType::ACCEPT
		all_orig_img = []
		all_orig_pb = []
		ind = 0
		buff_ind = 0
		rotation_case = 'A'
		filename = dialog.filename
		dir_path = dialog.current_folder
		pictureshow_path = dir_path + "/Pictureshow"
		deleted_path = dir_path + "/Deleted"
		all_files = Dir.entries(dir_path)
		accepted_formats = [".jpg", ".JPG", ".png", ".PNG", ".gif", ".GIF"]
		
		all_files.each do |name|
			if accepted_formats.include? File.extname(name)
				all_orig_img << name
			end
		end
		all_orig_img = all_orig_img.sort
		just_the_name = File.basename filename

		all_orig_img.each_with_index do |name, index|
			if just_the_name == name
				ind = index
			end
		end

		if File.directory?(pictureshow_path) == false
			Dir.mkdir(pictureshow_path)
			FileUtils.chmod 0777, pictureshow_path
		end

		if File.directory?(deleted_path) == false
			Dir.mkdir(deleted_path)
			FileUtils.chmod 0777, deleted_path
		end

		buff_ind = ind
		for buff_ind in ind..(ind+1)
			if buff_ind < all_orig_img.length
				current_filename = dir_path + "/" + all_orig_img[buff_ind]
				all_orig_pb = prepare_pixbuf(current_filename, all_orig_pb)
			end
		end
		next_name_to_load = all_orig_img[ind+2]

		pb_current = all_orig_pb[ind]

		show_img(img_current, pb_current)
		window.set_title File.basename filename

		#activate all buttons
		prev_btn.sensitive = true
		next_btn.sensitive = true
		rotate_btn.sensitive = true
		show_btn.sensitive = true
		delete_btn.sensitive = true

	end
	dialog.destroy
end
filemenu.append open_file

quit = Gtk::MenuItem.new :label => "Exit"
quit.signal_connect("activate") {Gtk.main_quit}

filemenu.append quit

mb.append file
#-----------End of Menu------------------------

#-----------Beginn of Button Area-----------------

#--------------Previous-Button----------------------------
prev_btn.signal_connect("clicked") do 
	
	if (ind != 0) || (all_orig_img.length == all_orig_pb.length)
		ind = set_prev_index(ind, all_orig_img)
		filename = dir_path + "/" + all_orig_img[ind]
		is_landscape = img_dimensions_fi(filename)[0]
		pb_current = all_orig_pb[ind]
		show_img(img_current, pb_current)
		window.set_title File.basename filename
	end
	

end
#--------------End of Previous-Button----------------------

#-----------------Next-Button----------------------------
next_btn.signal_connect("clicked") do 

	ind = set_next_index(ind, all_orig_img)
	filename = dir_path + "/" + all_orig_img[ind]
	is_landscape = img_dimensions_fi(filename)[0]
	pb_current = all_orig_pb[ind]
	show_img(img_current, pb_current)
	window.set_title File.basename filename	

	#buffer the next image if not all loaded yet
	if all_orig_pb.length != all_orig_img.length
		ind_to_load = all_orig_img.find_index(next_name_to_load)
		current_filename = dir_path + "/" + next_name_to_load

		if ind_to_load+1 < all_orig_img.length
			next_name_to_load = all_orig_img[ind_to_load+1]
		end

		all_orig_pb = prepare_pixbuf(current_filename, all_orig_pb)
	end
end
#----------------End of Next-Button-----------------------------

#----------------Rotate-Button------------------
rotate_btn.signal_connect("clicked") do 
	
	if is_landscape == false # original image in portrait format
		pb_current = pb_current.rotate(:clockwise)
		
	else #original image in landscape format
		if rotation_case == 'A'
			pb_current = pb_current.rotate(:clockwise)
			width_pb = pb_current.width
			height_pb = pb_current.height
			if height_pb > IMG_MAX_H
				while height_pb > IMG_MAX_H do 
					height_pb *= REDUCTION_FACTOR
					width_pb *= REDUCTION_FACTOR
				end
				height_pb = height_pb.to_i
				width_pb = width_pb.to_i
				pb_portrait = pb_current.scale(width_pb, height_pb, :bilinear)
				pb_current = pb_portrait
			else
				pb_portrait = pb_current
			end
			rotation_case = 'B'

		elsif rotation_case == 'B'
			pb_current = all_orig_pb[ind].rotate(:upsidedown)
			rotation_case = 'C'

		elsif rotation_case == 'C'
			pb_current = pb_portrait.rotate(:upsidedown)
			rotation_case = 'D'

		elsif rotation_case == 'D'
			pb_current = all_orig_pb[ind]
			rotation_case = 'A'
		end
	end
	img_current.set_pixbuf(pb_current)
end
#----------------End of Rotate-Button------------------

#----------------Pictureshow-Button---------------------------
show_btn.signal_connect("clicked") do
	if all_orig_img.length > 0

		buff_ind = ind
		just_the_name = all_orig_img[ind]
		current_location = dir_path + "/" + just_the_name
		new_location = pictureshow_path + "/" + just_the_name
		FileUtils.mv(current_location, new_location) 

		all_orig_img.delete_at(ind)
		all_orig_pb.delete_at(ind)

		if all_orig_img.length > 0
			if ind == all_orig_img.length
				ind -= 1
			end

			just_the_name = all_orig_img[ind]
			filename = dir_path + "/" + just_the_name
			is_landscape = img_dimensions_fi(filename)[0]
			pb_current = all_orig_pb[ind]
			show_img(img_current, pb_current)
			window.set_title just_the_name

			#buffer the next image if not all loaded yet
			if all_orig_pb.length != all_orig_img.length
				ind_to_load = all_orig_img.find_index(next_name_to_load)
				current_filename = dir_path + "/" + next_name_to_load
				
				if ind_to_load+1 < all_orig_img.length
					next_name_to_load = all_orig_img[ind_to_load+1]
				end

				all_orig_pb = prepare_pixbuf(current_filename, all_orig_pb)
			end
		else
			pb_current = GdkPixbuf::Pixbuf.new :file => "empty_pic.png"
			img_current.set_pixbuf(pb_current)
			deactivate_buttons(prev_btn, next_btn, rotate_btn, show_btn, delete_btn)
		end
	else 
		pb_current = GdkPixbuf::Pixbuf.new :file => "empty_pic.png"
		img_current.set_pixbuf(pb_current)
		deactivate_buttons(prev_btn, next_btn, rotate_btn, show_btn, delete_btn)
	end
	
end
#-------------End of Pictureshow-Button --------------------

#----------------Delete-Button---------------------
delete_btn.signal_connect("clicked") do
	if all_orig_img.length > 0

		just_the_name = all_orig_img[ind]
		current_location = dir_path + "/" + just_the_name
		new_location = deleted_path + "/" + just_the_name
		FileUtils.mv(current_location, new_location) 

		all_orig_img.delete_at(ind)
		all_orig_pb.delete_at(ind)

		if all_orig_img.length > 0
			if ind == all_orig_img.length
				ind -= 1
			end

			just_the_name = all_orig_img[ind]
			filename = dir_path + "/" + just_the_name
			is_landscape = img_dimensions_fi(filename)[0]
			pb_current = all_orig_pb[ind]
			show_img(img_current, pb_current)
			window.set_title just_the_name

			#buffer the next image if not all loaded yet
			if all_orig_pb.length != all_orig_img.length
				ind_to_load = all_orig_img.find_index(next_name_to_load)
				current_filename = dir_path + "/" + next_name_to_load
				
				if ind_to_load+1 < all_orig_img.length
					next_name_to_load = all_orig_img[ind_to_load+1]
				end

				all_orig_pb = prepare_pixbuf(current_filename, all_orig_pb)
			end
		else
			pb_current = GdkPixbuf::Pixbuf.new :file => "empty_pic.png"
			img_current.set_pixbuf(pb_current)
			deactivate_buttons(prev_btn, next_btn, rotate_btn, show_btn, delete_btn)
		end
	else 
		pb_current = GdkPixbuf::Pixbuf.new :file => "empty_pic.png"
		img_current.set_pixbuf(pb_current)
		deactivate_buttons(prev_btn, next_btn, rotate_btn, show_btn, delete_btn)
	end
	
end
#------------End of Delete-Button----------------------------

hbox.add prev_btn
hbox.add rotate_btn
hbox.add show_btn
hbox.add next_btn
hbox.add delete_btn


halign.add hbox

#-----------End of Button Area-------------------

vbox.pack_start mb, :expand => false, :fill => false, :padding => 5
vbox.pack_start img_current, :expand => true, :fill => true, :padding => 5
vbox.pack_start halign, :expand=> false, :fill => false, :padding => 5

window.add vbox
window.show_all


Gtk.main
