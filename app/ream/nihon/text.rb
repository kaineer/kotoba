#
#
#

require 'ream/nihon/kana'

module Ream
  module Nihon
    class Text
      class Kanji
        def initialize( data )
          @data = data
          @furigana = nil
        end

        attr_writer :furigana

        def inspect
          if @furigana.nil?
            "Kanji(#{@data.join(',')})"
          else
            "Kanji(#{@data.join(',')}:#{@furigana.inspect})"
          end
        end

        def to_html
          if @furigana.nil?
            @data.map do |e|
              "&#x#{e};"
            end.join( '' )
          else
            "<span title='#{@furigana.to_html}'>" +
              @data.map do |e|
              "&#x#{e};"
            end.join( '' ) +
              "</span>"
          end
        end
      end

      class CantParse < Exception
        def initialize( text )
          super( text )
        end
      end

      def initialize( source )
        @parts = []
        hira = true

        while source.size > 0
          case source
          when Ream::Nihon::Dots::PATTERN
            text = $~[0]
            source = source[ (text.size)..-1 ]
            @parts << Ream::Nihon::Dots.new( text )
            hira = true
          when /^\w+/
            text = $~[0]
            source = source[ (text.size)..-1 ]

            part = Ream::Nihon::Kana.new( text, !hira )
            @parts << part
          when /^\//
            hira = !hira
            source = source[ 1..-1 ]
          when /^\{([0-9a-fA-F]{4}(,[0-9a-fA-F]{4})*)(:(\w+))?\}/
            md = $~
            source = source[ (md[0].size)..-1 ]
            text = md[1]
            data = text.split(',')
            kanji = Kanji.new( data )
            kanji.furigana =
              Ream::Nihon::Kana.new( md[ 4 ] ) unless md[4].nil?
            @parts << kanji
            hira = true
          else
            raise( CantParse, source[ 0..40 ] )
          end
        end
      end

      def to_s
        @parts.map{|e|e.inspect}.join(';')
      end

      def to_html
        @parts.map{|e|e.to_html}.join('')
      end

      def self.scan( source )
        arr = source.unpack( "U*" )
        if arr.all?{|c| c < ?z}
          kana = Ream::Nihon::Kana.try( source )
          if kana.ok? && kana.rest.empty?
            return :romaji
          else
            return :meaning
          end
        else
          return Ream::Nihon::Kana.scan( source )
        end
      end
    end
  end
end
