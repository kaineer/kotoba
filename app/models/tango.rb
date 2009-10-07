# -*- coding: utf-8 -*-
require 'ostruct'

class Tango < OpenStruct
  #
  #
  def self.[]( key )
    index = key.to_i
    return nil if index < 0
    return nil if index >= JLPT.size
    self.new( JLPT[ index ].merge( :index => index ) )
  end

  def next
    Tango[ self.index + 1 ]
  end

  def prev
    Tango[ self.index - 1 ]
  end

  def self.select( &block )
    JLPT.select( &block )
  end

  load File.join( File.dirname( __FILE__ ), "tango_jlpt.rb" )
end

