# -*- coding: utf-8 -*-
require 'ostruct'
require 'ream/nihon/text'

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

  def self.select_by_source( source )
    result = {}
    @kana_result = @meaning_result = @kanji_result = nil
    case Ream::Nihon::Text.scan( source )
    when :romaji
      @kana_result = select_romaji( source )
      @meaning_result = select_meaning( source )
    when :meaning
      @meaning_result = select_meaning( source )
    when :kana
      @kana_result = select_kana( source )
    when :kanji
      @kanji_result = select_kanji( source )
    end

    result[ :kanji ]   = @kanji_result if @kanji_result && !@kanji_result.empty?
    result[ :kana ]    = @kana_result if @kana_result && !@kana_result.empty?
    result[ :meaning ] = @meaning_result if @meaning_result && !@meaning_result.empty?

    result
  end
end

