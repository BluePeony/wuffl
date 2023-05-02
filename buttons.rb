require 'gtk3'

module Buttons
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

    return [prev_btn, next_btn, rotate_btn, show_btn, delete_btn]
  end


end