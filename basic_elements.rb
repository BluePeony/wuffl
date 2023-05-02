require 'gtk3'
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

    return {prev_btn: prev_btn, next_btn: next_btn, rotate_btn: rotate_btn, show_btn: show_btn, delete_btn: delete_btn}
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
end