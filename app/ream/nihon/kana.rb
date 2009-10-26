#-------------------------------------------------------------------------------
#   Date: 2008.03.27 -- 16:49:59
# Author: kaineer
#  Brief: Hiragana/katakana translation
#   Desc: This class should take romaji, parse it using romaji parser
#         and then give utf8 strings of hiragana or katakana
#-------------------------------------------------------------------------------

require 'ream/nihon/base'
require 'ream/nihon/romaji_parser'

module Ream
  module Nihon
    class Kana < Base
      #
      #
      def initialize( romaji, kata = false )
        @kata = kata
        @base = @kata ? KATAKANA : HIRAGANA
        @res = RomajiParser.parse( romaji )
        @parsed = @res.arr
        @unparsed = @res.str
        @success = @res.success?
        @res = nil
      end

      def to_s
        @parsed.map{|k| @base + @@index[ k ]}.pack( "U*" )
      end

      def to_html
        str = to_s
        str << "<u>#{@unparsed}</u>" unless @success
        str
      end

      def inspect
        "#{@kata ? 'Katakana' : 'Hiragana'}(#{@parsed * ','}#{@success ? '' : '/' + @unparsed})"
      end

      def self.try( string )
        # TODO 2008-04-03 10:16:30 It would be better to create result in parser
        res = RomajiParser.parse( string )
        unparsed = res.str.to_s
        unparsed == string ? TryResult.failure( string ) : TryResult.success( unparsed )
      end

      def self.scan( source )
        arr = source.unpack( "U*" )
        return :kanji if arr.find{|v| v > LAST_KANA }
        :kana
      end

    protected
      # Bases
      HIRAGANA = 12353
      KATAKANA = 12449

      def self.mkindex( arr )
        res = {}
        arr.each_with_index{|e,i| res[ e ] = i }
        res
      end

      # This is the order of syllables
      # in codepage. So it can be transformed
      # into hash, like { :a => 0, :A => 1 ... }
      #
      @@index = mkindex( %w(
        a  A  i  I  u  U  e  E  o  O

        KA GA KI GI KU GU KE GE KO GO

        SA ZA SHI JI SU ZU SE ZE SO ZO

        TA DA CHI DZI tsu TSU DZU TE DE TO DO

        NA NI NU NE NO

        HA BA PA  HI BI PI
        FU BU PU  HE BE PE
        HO BO PO

        MA MI MU ME MO

        ya YA yu YU yo YO

        RA RI RU RE RO

        wa WA WI WE WO
        N
      ) )

      LAST_KANA = KATAKANA + @@index.size

    end
  end
end

