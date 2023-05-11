require 'gtk3'
require 'fileutils'
require 'fastimage'
require 'stringio'
require_relative 'basic_elements'
require_relative 'actions'

class WufflInterface

  def initialize

    # get the screen resolution
    @win_width, @win_height = Actions.get_resolution

    # define the window
    @window = BasicElements.define_window(@win_width*0.45, @win_height*0.45)

    # define the boxes
    @vbox, @hbox = BasicElements.define_boxes

    # prepare the current image
    @img_current = Gtk::Image.new

    @halign = Gtk::Alignment.new 0.5, 0, 0, 0

    # define image parameters
    @img_parameters = BasicElements.define_img_parameters(@win_width, @win_height, @img_current)

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
      @img_parameters = BasicElements.define_img_parameters(@win_width, @win_height, @img_current)
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

    # select button action
    @button_set[:select_btn].signal_connect("clicked") do
      @img_parameters = Actions.select_delete_btn_action(@window, @img_parameters, @button_set, "select")
      
    end

    # delete button action
    @button_set[:delete_btn].signal_connect("clicked") do
      @img_parameters = Actions.select_delete_btn_action(@window, @img_parameters, @button_set, "delete")
    end

    @quit.signal_connect("activate") {Gtk.main_quit}

     # pack the boxes
    @box_set = Actions.pack_boxes(@window, @img_parameters[:img_current], @box_set, @button_set)

    @window.show_all
    Gtk.main
  end
end