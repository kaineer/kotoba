#-------------------------------------------------------------------------------
#   Date: 2008.03.31 -- 10:19:06
# Author: kaineer
#  Brief: Replacement for symbols.rb
#   Desc: Contains some characters' codes, like punctuation and such
#-------------------------------------------------------------------------------

require 'ream/nihon/base'

module Ream
  module Nihon
    class Dots < Base
      #
      def initialize( string )
        @str = string
        @arr = nil
        @res = nil

        translate()
      end

      #
      def pattern
        PATTERN
      end

      #
      def to_s
        @res ||= @arr.pack( "U*" )
      end

      #
      def to_html
        to_s
      end

      #
      def inspect
        "Dots(#{@str})"
      end

      #
      def self.try( string )
        PATTERN === string ? TryResult.success( $' ) : TryResult.failure( string )
      end

    protected
      #
      def translate
        @arr = @str.unpack( "C*" ).map{|ch| XLAT[ ch ] || ch }
      end

      # Translation from ascii-code to japanese symbol code
      XLAT = {
        ?- => 0x30fc,
        ?. => 0x3002,
        ?, => 0x3001,
        ?( => 0x300c,
        ?) => 0x300d,
        ?[ => 0x300e,
        ?] => 0x300f,
        ?~ => 0x301c,
        ?" => 0x301e
      }

      # symbols to accept
      PATTERN = /^[-.,()\[\]~"\s\d]+/ #"'
    end
  end
end

