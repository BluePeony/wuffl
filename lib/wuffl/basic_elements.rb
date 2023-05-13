module Wuffl
  module BasicElements

    # define the interface window
    def self.define_window(win_width, win_height)
      window = Gtk::Window.new
      window.set_title "Wuffl"
      window.set_window_position :center
      window.set_default_size win_width, win_height
      window.signal_connect("destroy") {Gtk.main_quit}

      return window
    end

    # define the boxes which are parts of the window
    def self.define_boxes
      vbox = Gtk::Box.new :vertical, 5
      hbox = Gtk::Box.new :horizontal, 10

      return [vbox, hbox]
    end

    # define the pixel buffers
    def self.define_pixbuf
      pb_current = GdkPixbuf::Pixbuf.new #current pixbuf
      pb_portrait = GdkPixbuf::Pixbuf.new #pixbuf in portrait format (relevant only for rotations)

      return [pb_current, pb_portrait]
    end

    # define the necessary buttons
    def self.define_buttons
      #-----------Definition of Buttons ----------

      #-----------Previous-Button----------------------
      prev_btn = Gtk::Button.new 
      prev_btn.label = "Previous"
      prev_btn.set_tooltip_text "Previous image"
      prev_btn.sensitive = false

      #-----------Next-Button-----------------------
      next_btn = Gtk::Button.new
      next_btn.label = "Next"
      next_btn.set_tooltip_text "Next image"
      next_btn.sensitive = false

      #-----------Rotate-Button----------------------
      rotate_btn = Gtk::Button.new
      rotate_btn.label = "Rotate"
      rotate_btn.set_tooltip_text "Rotate image"
      rotate_btn.sensitive = false

      #-----------Select-Button-----------------
      select_btn = Gtk::Button.new
      select_btn.label = "Move to \"Selected\""
      select_btn.set_tooltip_text "Move the image to the \"Selected\" folder"
      select_btn.sensitive = false

      #-----------Delete-Button---------------------
      delete_btn = Gtk::Button.new
      delete_btn.label = "Move to \"Deleted\""
      delete_btn.set_tooltip_text "Move the image to the \"Deleted\" folder"
      delete_btn.sensitive = false

      return {prev_btn: prev_btn, next_btn: next_btn, rotate_btn: rotate_btn, select_btn: select_btn, delete_btn: delete_btn}
    end

    # define the menu
    def self.define_menu
      mb = Gtk::MenuBar.new
      file = Gtk::MenuItem.new :label => "File"
      filemenu = Gtk::Menu.new
      file.set_submenu filemenu

      open_file = Gtk::MenuItem.new :label => "Open file"
      quit = Gtk::MenuItem.new :label => "Exit"

      filemenu.append open_file
      filemenu.append quit
      mb.append file

      return [mb, open_file, quit]
    end

    # define the image parameters
    def self.define_img_parameters(win_width, win_height, img_current)
      pb_current, pb_portrait = define_pixbuf

      img_parameters = {
        dir_path: "", # path of the image folder
        selected_path: "", 
        deleted_path: "", 
        name: "",
        rotation_case: 'A',
        ind: 0,      
        is_landscape: true, 
        all_orig_img: [],
        all_orig_pb: [],
        pb_current: pb_current,
        pb_portrait: pb_portrait,
        img_current: img_current, # current image
        img_max_w: (win_width * 0.37).to_i, # max width for each image
        img_max_h: (win_height * 0.37).to_i , # max height for each image
        reduction_factor: 0.95
      }
      return img_parameters
    end
  end
end