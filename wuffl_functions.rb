def img_dimensions_fi (filename)
	#determine the dimensions of the given image with FastImage-gem
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

def landscape_pic(pb_orig, img_width, img_height)
	#resize the image if too big
	if img_width > IMG_MAX_W || img_height > IMG_MAX_H

			while img_width > IMG_MAX_W || img_height > IMG_MAX_H do
				img_width *= REDUCTION_FACTOR
				img_height *= REDUCTION_FACTOR
			end
	end

	img_width = img_width.to_i
	img_height = img_height.to_i

	pb_orig = pb_orig.scale(img_width, img_height, :bilinear)
	return pb_orig
end

def portrait_pic(pb_orig, rotate_pic, img_width, img_height)
	#resize the image if too big
	if rotate_pic == true
		pb_orig = pb_orig.rotate(:clockwise)
		z = img_width
		img_width = img_height
		img_height = z
	end

	if img_height > IMG_MAX_H
		while img_height > IMG_MAX_H do
			img_width *= REDUCTION_FACTOR
			img_height *= REDUCTION_FACTOR
		end
	end	
	
		img_height = img_height.to_i
		img_width = img_width.to_i

		pb_orig = pb_orig.scale(img_width, img_height, :bilinear)
		return pb_orig
end

def prepare_pixbuf(filename, array_of_orig_pixbufs)
	fi_infos = img_dimensions_fi(filename)
	pixbuf_infos = GdkPixbuf::Pixbuf.get_file_info(filename)
	is_landscape = fi_infos[0]
	pixbuf_width = pixbuf_infos[1]
	pixbuf_height = pixbuf_infos[2]

	img_width = pixbuf_width
	img_height = pixbuf_height

	pb_orig = GdkPixbuf::Pixbuf.new :file => filename, :width => img_width, :height => img_height

	if fi_infos[1] > fi_infos[2] #landscape format
		pb_orig = landscape_pic(pb_orig, img_width, img_height)
	else #portrait format
		if (fi_infos[1] == pixbuf_infos[1]) && (fi_infos[2] == pixbuf_infos[2])
			rotate_pic = false
		else
			rotate_pic = true
		end 
		pb_orig = portrait_pic(pb_orig, rotate_pic, img_width, img_height)
	end

	array_of_orig_pixbufs << pb_orig

	return array_of_orig_pixbufs
end

def show_img(img_curr, pb_curr)
	#display current image
	img_curr.set_pixbuf(pb_curr)
	
end

def set_next_index(index, img_array)
	if (index + 1) <= (img_array.length - 1)
		index += 1
	else
		index = 0
	end
	return index
end

def set_prev_index(index, img_array)
	if (index - 1) < 0
		index = img_array.length - 1
	else
		index -= 1
	end
	return index
end

def deactivate_buttons (but1, but2, but3, but4, but5)
	but1.sensitive = false
	but2.sensitive = false
	but3.sensitive = false
	but4.sensitive = false
	but5.sensitive = false
end