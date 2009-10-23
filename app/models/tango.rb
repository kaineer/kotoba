# -*- coding: utf-8 -*-
require 'ostruct'
require 'ream/nihon/kana'

class Tango < OpenStruct
  #
  load File.join( File.dirname( __FILE__ ), "tango_jlpt.rb" )

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

  INDEX = 0...(JLPT.size)

  def self.select( &block )
    INDEX.select{|i|block.call( JLPT[ i ] )}.map{|i|Tango[i]}
  end

  def self.select_field( field, value )
    self.select do |t|
      t[ field ].include?( value )
    end
  end

  def self.select_kanji( kanji )
    select_field( :kanji, kanji )
  end

  def self.select_kana( kana )
    select_field( :kana, kana )
  end

  def self.select_romaji( romaji )
    kana = Ream::Nihon::Kana.new( romaji )
    if kana.to_s.empty?
      []
    else
      select_kana( kana.to_s ) 
    end
  end

  def self.select_meaning( meaning )
    select_field( :meaning, meaning )
  end
end

