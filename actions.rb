require 'gtk3'

module Actions

	# get the operating system of the machine
	def self.get_op_sys
		if (/darwin/ =~ RUBY_PLATFORM) != nil
			return 'mac'
		elsif (/linux/ =~ RUBY_PLATFORM) != nil
			return 'linux'
		elsif (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
			return 'windows'
		end
	end

	# get the resolution of the display
	def self.get_resolution(operating_system)

		case operating_system
			
		when 'windows'
			output_dimensions = `wmic path Win32_VideoController get VideoModeDescription,CurrentVerticalResolution,CurrentHorizontalResolution /format:value`

			# Horizontal Resolution of the screen
			hor_res_begin_index = output_dimensions.index("HorizontalResolution") + "HorizontalResolution=".length
			hor_res_end_index = output_dimensions.index("CurrentVertical") - 3
			win_width = output_dimensions.slice(hor_res_begin_index..hor_res_end_index).to_i

			# Vertical Resolution of the screen
			ver_res_begin_index = output_dimensions.index("VerticalResolution") + "VerticalResolution=".length
			ver_res_end_index = output_dimensions.index("VideoMode") - 3
			win_height = output_dimensions.slice(ver_res_begin_index..ver_res_end_index).to_i

		else
			if operating_system == "mac"
				output_dimensions = `system_profiler SPDisplaysDataType |grep Resolution`.chomp.tr(" ", "")			
				end_index = output_dimensions.index("Retina") - 1
			elsif operating_system == "linux"
				output_dimensions = `xdpyinfo | grep dimensions`.chomp.tr(" ", "")
				end_index = output_dimensions.index("p") - 1
			end
			start_index = output_dimensions.index(":") + 1
			resolution = output_dimensions.slice(start_index..end_index)
			win_width = resolution.slice(0..resolution.index("x")-1).to_i
			win_height = resolution.slice(resolution.index("x")+1.. resolution.length-1).to_i
		end	

		return [win_width, win_height]
	end

  def self.define_img_parameters(win_width, win_height)
    pb_current, pb_portrait = BasicElements.define_pixbuf

    img_parameters = {
      dir_path: "", # path of the image folder
      pictureshow_path: "", 
      deleted_path: "", 
      name: "",
      rotation_case: 'A',
      ind: 0,      
      is_landscape: true, 
      all_orig_img: [],
      all_orig_pb: [],
      pb_current: pb_current,
      pb_portrait: pb_portrait,
      img_current: Gtk::Image.new, # current image
      img_max_w: (win_width * 0.37).to_i, # max width for each image
      img_max_h: (win_height * 0.37).to_i , # max height for each image
      reduction_factor: 0.95
    }
    return img_parameters
  end

  # pack the boxes for the GUI
	def self.pack_boxes(window, img_current, box_set, button_set)
    box_set[:hbox].add button_set[:prev_btn]
    box_set[:hbox].add button_set[:rotate_btn]
    box_set[:hbox].add button_set[:show_btn]
    box_set[:hbox].add button_set[:next_btn]
    box_set[:hbox].add button_set[:delete_btn]
    box_set[:halign].add box_set[:hbox]

    box_set[:vbox].pack_start box_set[:mb], :expand => false, :fill => false, :padding => 5
    box_set[:vbox].pack_start img_current, :expand => true, :fill => true, :padding => 5
    box_set[:vbox].pack_start box_set[:halign], :expand => false, :fill => false, :padding => 5


    #@vbox.pack_start @mb, :expand => false, :fill => false, :padding => 5
    #@vbox.pack_start @img_current, :expand => true, :fill => true, :padding => 5
    #@vbox.pack_start @halign, :expand=> false, :fill => false, :padding => 5

    window.add box_set[:vbox]

    return box_set
  end

	# determine the dimensions of the given image with FastImage-gem
	def self.img_dimensions_fi (filename)	
		img_dim = FastImage.size("#{filename}")	
		img_orig_width_fi = img_dim[0]
		img_orig_height_fi = img_dim[1]

		if img_orig_width_fi > img_orig_height_fi
			is_orig_landscape = true
		else
			is_orig_landscape = false
		end

		fastimage_infos = [is_orig_landscape, img_orig_width_fi.to_i, img_orig_height_fi.to_i]
	end

	# resize the image if too big - for landscape mode
	def self.landscape_pic(pb_orig, img_width, img_height, img_max_w, img_max_h, reduction_factor)
		if img_width > img_max_w || img_height > img_max_h

				while img_width > img_max_w || img_height > img_max_h do
					img_width *= reduction_factor
					img_height *= reduction_factor
				end
		end

		img_width = img_width.to_i
		img_height = img_height.to_i

		pb_orig = pb_orig.scale(img_width, img_height, :bilinear)
		return pb_orig
	end

	# resize the image if too big - for portrait mode
	def self.portrait_pic(pb_orig, rotate_pic, img_width, img_height, img_max_h, reduction_factor)
		if rotate_pic == true
			pb_orig = pb_orig.rotate(:clockwise)
			z = img_width
			img_width = img_height
			img_height = z
		end

		if img_height > img_max_h
			while img_height > img_max_h do
				img_width *= reduction_factor
				img_height *= reduction_factor
			end
		end	
		
			img_height = img_height.to_i
			img_width = img_width.to_i

			pb_orig = pb_orig.scale(img_width, img_height, :bilinear)
			return pb_orig
	end

	# prepare image for loading
	def self.prepare_pixbuf(filename, array_of_orig_pixbufs, img_max_w, img_max_h, reduction_factor)
		fi_infos = self.img_dimensions_fi(filename)
		pixbuf_infos = GdkPixbuf::Pixbuf.get_file_info(filename)
		is_landscape = fi_infos[0]
		pixbuf_width = pixbuf_infos[1]
		pixbuf_height = pixbuf_infos[2]

		img_width = pixbuf_width
		img_height = pixbuf_height

		pb_orig = GdkPixbuf::Pixbuf.new :file => filename, :width => img_width, :height => img_height

		if fi_infos[1] > fi_infos[2] #landscape format
			pb_orig = self.landscape_pic(pb_orig, img_width, img_height, img_max_w, img_max_h, reduction_factor)
		else #portrait format
			if (fi_infos[1] == pixbuf_infos[1]) && (fi_infos[2] == pixbuf_infos[2])
				rotate_pic = false
			else
				rotate_pic = true
			end 
			pb_orig = portrait_pic(pb_orig, rotate_pic, img_width, img_height, img_max_h, reduction_factor)
		end

		array_of_orig_pixbufs << pb_orig

		return [array_of_orig_pixbufs, is_landscape]
	end

	# display the current image
	def self.show_img(img_curr, pb_curr)
		img_curr.set_pixbuf(pb_curr)
		
	end

	# set the index for the next image
	def self.set_next_index(index, img_array)
		if (index + 1) <= (img_array.length - 1)
			index += 1
		else
			index = 0
		end
		return index
	end

	# set the index for the previous image
	def self.set_prev_index(index, img_array)
		if (index - 1) < 0
			index = img_array.length - 1
		else
			index -= 1
		end
		return index
	end

  # deactivate all buttons
	def self.deactivate_buttons (button_set)
    button_set.each do |button, sens_value|
      button_set[button].sensitive = false
    end
	end

  # action when the "Open file" menu option is clicked
  def self.open_file_action(window, img_parameters, button_set)
    dialog = Gtk::FileChooserDialog.new(:title => "Open file", :parent => window, :action => Gtk::FileChooserAction::OPEN, 
        :buttons => [[Gtk::Stock::OPEN, Gtk::ResponseType::ACCEPT], [Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL]])

    #img_parameters = Actions.define_img_parameters(win_width, win_height)

    if dialog.run == Gtk::ResponseType::ACCEPT
      filename = dialog.filename
      img_parameters[:dir_path] = File.dirname(filename)
      img_parameters[:pictureshow_path] = img_parameters[:dir_path] + "/Pictureshow"
      img_parameters[:deleted_path] = img_parameters[:dir_path] + "/Deleted"
      all_files = Dir.entries(img_parameters[:dir_path])
      accepted_formats = [".jpg", ".JPG", ".png", ".PNG", ".gif", ".GIF"]
      img_parameters[:is_landscape] = true
      
      all_files.each do |name|
        if accepted_formats.include? File.extname(name)
          img_parameters[:all_orig_img] << name
        end
      end
      img_parameters[:all_orig_img] = img_parameters[:all_orig_img].sort
      just_the_name = File.basename filename

      img_parameters[:all_orig_img].each_with_index do |name, index|
        if just_the_name == name
          img_parameters[:ind] = index
        end
      end

      if File.directory?(img_parameters[:pictureshow_path]) == false
        Dir.mkdir(img_parameters[:pictureshow_path])
        FileUtils.chmod 0777, img_parameters[:pictureshow_path]
      end

      if File.directory?(img_parameters[:deleted_path]) == false
        Dir.mkdir(img_parameters[:deleted_path])
        FileUtils.chmod 0777, img_parameters[:deleted_path]
      end

        # Prebuffer of all files
        img_parameters[:all_orig_img].each do |file|
          current_filename = img_parameters[:dir_path] + "/" + file
          img_parameters[:all_orig_pb], img_parameters[:is_landscape] = Actions.prepare_pixbuf(current_filename, img_parameters[:all_orig_pb], img_parameters[:img_max_w], img_parameters[:img_max_h], img_parameters[:reduction_factor])
        end
        img_parameters[:pb_current] = img_parameters[:all_orig_pb][img_parameters[:ind]]

        Actions.show_img(img_parameters[:img_current], img_parameters[:pb_current])
        window.set_title File.basename filename

        # Activate all buttons
        button_set.each do |button, sens_value|
          button_set[button].sensitive = true
        end

      end
      dialog.destroy

      return img_parameters
  end

  # action when the "previous image" button or the "next image" button is clicked
  def self.prev_next_btn_action(window, img_parameters, previous_or_next_button)
    if previous_or_next_button == "prev" # previous image
      img_parameters[:ind] = Actions.set_prev_index(img_parameters[:ind], img_parameters[:all_orig_img])
    elsif previous_or_next_button == "next" # next button
      img_parameters[:ind] = Actions.set_next_index(img_parameters[:ind], img_parameters[:all_orig_img])
    end    
    filename = img_parameters[:dir_path] + "/" + img_parameters[:all_orig_img][img_parameters[:ind]]
    img_parameters[:is_landscape] = Actions.img_dimensions_fi(filename)[0]
    img_parameters[:pb_current] = img_parameters[:all_orig_pb][img_parameters[:ind]]
    Actions.show_img(img_parameters[:img_current], img_parameters[:pb_current])
    window.set_title File.basename filename

    return img_parameters
  end

  # action when the rotate button is clicked
  def self.rotate_btn_action(img_parameters)
    if img_parameters[:is_landscape] == false # Original image in portrait format
      img_parameters[:pb_current] = img_parameters[:pb_current].rotate(:clockwise)
      
    else # Original image in landscape format
      if img_parameters[:rotation_case] == 'A'
        img_parameters[:pb_current] = img_parameters[:pb_current].rotate(:clockwise)
        width_pb = img_parameters[:pb_current].width
        height_pb = img_parameters[:pb_current].height
        if height_pb > img_parameters[:img_max_h]
          while height_pb > img_parameters[:img_max_h] do 
            height_pb *= img_parameters[:reduction_factor]
            width_pb *= img_parameters[:reduction_factor]
          end
          height_pb = height_pb.to_i
          width_pb = width_pb.to_i
          img_parameters[:pb_portrait] = img_parameters[:pb_current].scale(width_pb, height_pb, :bilinear)
          img_parameters[:pb_current] = img_parameters[:pb_portrait]
        else
          img_parameters[:pb_portrait] = img_parameters[:pb_current]
        end
        img_parameters[:rotation_case] = 'B'

      elsif img_parameters[:rotation_case] == 'B'
        img_parameters[:pb_current] = img_parameters[:all_orig_pb][img_parameters[:ind]].rotate(:upsidedown)
        img_parameters[:rotation_case] = 'C'

      elsif img_parameters[:rotation_case] == 'C'
        img_parameters[:pb_current] = img_parameters[:pb_portrait].rotate(:upsidedown)
        img_parameters[:rotation_case] = 'D'

      elsif img_parameters[:rotation_case] == 'D'
        img_parameters[:pb_current] = img_parameters[:all_orig_pb][img_parameters[:ind]]
        img_parameters[:rotation_case] = 'A'
      end
    end
    img_parameters[:img_current].set_pixbuf(img_parameters[:pb_current])

    return img_parameters
  end
  
  # action for the select and delete buttons
  def self.show_delete_btn_action(window, img_parameters, button_set, select_delete_par)
    if img_parameters[:all_orig_img].length > 0

      just_the_name = img_parameters[:all_orig_img][img_parameters[:ind]]
      current_location = img_parameters[:dir_path] + "/" + just_the_name
      if select_delete_par == "select"
        new_location = img_parameters[:pictureshow_path] + "/" + just_the_name
      elsif select_delete_par == "delete"
        new_location = img_parameters[:deleted_path] + "/" + just_the_name
      end
      FileUtils.mv(current_location, new_location) 

      img_parameters[:all_orig_img].delete_at(img_parameters[:ind])
      img_parameters[:all_orig_pb].delete_at(img_parameters[:ind])

      if img_parameters[:all_orig_img].length > 0
        if img_parameters[:ind] == img_parameters[:all_orig_img].length
          img_parameters[:ind] -= 1
        end

        just_the_name = img_parameters[:all_orig_img][img_parameters[:ind]]
        filename = img_parameters[:dir_path] + "/" + just_the_name
        img_parameters[:is_landscape] = Actions.img_dimensions_fi(filename)[0]
        img_parameters[:pb_current] = img_parameters[:all_orig_pb][img_parameters[:ind]]
        Actions.show_img(img_parameters[:img_current], img_parameters[:pb_current])
        window.set_title just_the_name

        if select_delete_par == "select"
          # Buffer the next image if not all loaded yet
          if img_parameters[:all_orig_pb].length != img_parameters[:all_orig_img].length
            current_filename = img_parameters[:dir_path] + "/" + img_parameters[:all_orig_img][img_parameters[:ind]+1]
            img_parameters[:all_orig_pb], img_parameters[:is_landscape]  = Actions.prepare_pixbuf(current_filename, img_parameters[:all_orig_pb], img_parameters[:img_max_w], img_parameters[:img_max_h], img_parameters[:reduction_factor])
          end
        end
      else
        img_parameters[:pb_current] = GdkPixbuf::Pixbuf.new :file => "empty_pic.png"
        img_parameters[:img_current].set_pixbuf(img_parameters[:pb_current])
        Actions.deactivate_buttons(button_set)
      end
    else 
      img_parameters[:pb_current] = GdkPixbuf::Pixbuf.new :file => "empty_pic.png"
      img_parameters[:img_current].set_pixbuf(img_parameters[:pb_current])
      Actions.deactivate_buttons(button_set)
    end
      return img_parameters
  end


end
