module Wuffl 
  module ImageActions

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
      fi_infos = img_dimensions_fi(filename)
      pixbuf_infos = GdkPixbuf::Pixbuf.get_file_info(filename)
      is_landscape = fi_infos[0]
      pixbuf_width = pixbuf_infos[1]
      pixbuf_height = pixbuf_infos[2]

      img_width = pixbuf_width
      img_height = pixbuf_height

      pb_orig = GdkPixbuf::Pixbuf.new :file => filename, :width => img_width, :height => img_height
      if fi_infos[1] > fi_infos[2] #landscape format
        pb_orig = landscape_pic(pb_orig, img_width, img_height, img_max_w, img_max_h, reduction_factor)
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
  end
end