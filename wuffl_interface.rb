require 'gtk3'
require 'fileutils'
require 'fastimage'
require 'stringio'
require_relative 'basic_elements'
require_relative 'actions'

module Wuffl

  class WufflInterface

    def initialize

      # get the screen resolution
      @win_width, @win_height = Wuffl::Actions.get_resolution

      # define the window
      @window = Wuffl::BasicElements.define_window(@win_width*0.45, @win_height*0.45)

      # define the boxes
      @vbox, @hbox = Wuffl::BasicElements.define_boxes

      # prepare the current image
      @img_current = Gtk::Image.new

      @halign = Gtk::Alignment.new 0.5, 0, 0, 0

      # define image parameters
      @img_parameters = Wuffl::BasicElements.define_img_parameters(@win_width, @win_height, @img_current)

      # define buttons
      @button_set = Wuffl::BasicElements.define_buttons

      # define menu
      @mb, @open_file, @quit = Wuffl::BasicElements.define_menu

      # define the set for the packing of boxes
      @box_set = {hbox: @hbox, vbox: @vbox, halign: @halign, mb: @mb}


    end


    def run

      # open file action
      @open_file.signal_connect("activate") do |w|
        @img_parameters = Wuffl::BasicElements.define_img_parameters(@win_width, @win_height, @img_current)
        @img_parameters = Wuffl::Actions.open_file_action(@window, @img_parameters, @button_set)
      end

      # previous button action
      @button_set[:prev_btn].signal_connect("clicked") do 
        @img_parameters = Wuffl::Actions.prev_next_btn_action(@window, @img_parameters, "prev")
      end

      # next button action
      @button_set[:next_btn].signal_connect("clicked") do   
        @img_parameters = Wuffl::Actions.prev_next_btn_action(@window, @img_parameters, "next")  
      end

      # rotate button action
      #----------------Rotate-Button------------------
      @button_set[:rotate_btn].signal_connect("clicked") do 
        @img_parameters = Wuffl::Actions.rotate_btn_action(@img_parameters)
      end

      # select button action
      @button_set[:select_btn].signal_connect("clicked") do
        @img_parameters = Wuffl::Actions.select_delete_btn_action(@window, @img_parameters, @button_set, "select")
        
      end

      # delete button action
      @button_set[:delete_btn].signal_connect("clicked") do
        @img_parameters = Wuffl::Actions.select_delete_btn_action(@window, @img_parameters, @button_set, "delete")
      end

      @quit.signal_connect("activate") {Gtk.main_quit}

       # pack the boxes
      @box_set = Wuffl::Actions.pack_boxes(@window, @img_parameters[:img_current], @box_set, @button_set)

      @window.show_all
      Gtk.main
    end
  end
end