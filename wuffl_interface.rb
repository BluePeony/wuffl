require_relative 'basic_elements'
require_relative 'actions'
require 'gtk3'
require 'fileutils'
require 'fastimage'

class WufflInterface

  def initialize

    # determine the OS
    @operating_system = Actions.get_op_sys

    # get the screen resolution
    @win_width, @win_height = Actions.get_resolution(@operating_system)

    # define the window
    @window = BasicElements.define_window(@win_width, @win_height)

    # define the boxes
    @vbox, @hbox = BasicElements.define_boxes

    # prepare the pixel butter
    pb_current, pb_portrait = BasicElements.define_pixbuf

    @halign = Gtk::Alignment.new 0.5, 0, 0, 0

    # define image parameters
    @img_parameters = Actions.define_img_parameters(@win_width, @win_height)

    # define buttons
    @button_set = BasicElements.define_buttons

    # define menu
    @mb, @open_file, @quit = BasicElements.define_menu

    # define the set for the packing of boxes
    @box_set = {hbox: @hbox, vbox: @vbox, halign: @halign, mb: @mb}


  end


  def run

    # open file action
    @open_file.signal_connect("activate") do |w|
      @img_parameters = Actions.open_file_action(@window, @img_parameters, @button_set)
    end

    # previous button action
    @button_set[:prev_btn].signal_connect("clicked") do 
      @img_parameters = Actions.prev_next_btn_action(@window, @img_parameters, "prev")
    end

    # next button action
    @button_set[:next_btn].signal_connect("clicked") do   
      @img_parameters = Actions.prev_next_btn_action(@window, @img_parameters, "next")  
    end

    # rotate button action
    #----------------Rotate-Button------------------
    @button_set[:rotate_btn].signal_connect("clicked") do 
      @img_parameters = Actions.rotate_btn_action(@img_parameters)
    end

    # pictureshow button action
    @button_set[:show_btn].signal_connect("clicked") do
      @img_parameters = Actions.show_delete_btn_action(@window, @img_parameters, @button_set, "select")
      
    end

    # delete button action
    @button_set[:delete_btn].signal_connect("clicked") do
      @img_parameters = Actions.show_delete_btn_action(@window, @img_parameters, @button_set, "delete")
    end

    @quit.signal_connect("activate") {Gtk.main_quit}

     # pack the boxes
    puts "Before the packing of the boxes"
    @box_set = Actions.pack_boxes(@window, @img_parameters[:img_current], @box_set, @button_set)
    puts "After the packing of the boxes and before window.show_all"

    @window.show_all
    puts "After window.show_all and before Gtk.main"
    Gtk.main
  end
end