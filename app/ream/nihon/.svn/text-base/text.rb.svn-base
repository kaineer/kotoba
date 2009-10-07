#
#
#

require 'ream/nihon/kana'
require 'ream/nihon/symbols'

module Ream; module Nihon; class Text

	class Block
		def initialize( data )
			@data = data
		end
		
		def loc_name; self.class.name[ /\w+$/ ]; end
		
		def to_s
			"%s(%s)" % [ loc_name, @data.join(',') ]
		end
	end
	
	class Katakana < Block 
		def to_html
			@data.map do |e|
				Kana.entity( e, true )
			end.join( '' )
		end
	end
	class Hiragana < Block
		def to_html
			@data.map do |e|
				Kana.entity( e, false )
			end.join( '' )
		end
	end
	class Kanji < Block
		def initialize( data )
			super( data )
			@furigana = nil
		end
		
		attr_writer :furigana
		
		def to_s
			return super if @furigana.nil?
			"Kanji(#{@data.join(',')}:#{@furigana.to_s})"
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
	class Dots < Block
		def initialize( data )
			super( data )
		end
		def to_s
			"#{loc_name}(#{@data})"
		end
		def to_html
			Symbols.translate( @data )
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
			when Symbols.keys
				text = $~[0]
				source = source[ (text.size)..-1 ]
				@parts << Dots.new( text )
			when /^\w+/
				text = $~[0]
				source = source[ (text.size)..-1 ]
				data = Kana.romaji2array( text )
				if hira
					@parts << Hiragana.new( data )
				else
					@parts << Katakana.new( data )
				end
			when /^\//
				hira = !hira
				source = source[ 1..-1 ]
			when /^\{([0-9a-fA-F]{4}(,[0-9a-fA-F]{4})*)(\|(\w+))?\}/
				md = $~
				source = source[ (md[0].size)..-1 ]
				text = md[1]
				data = text.split(',')
				kanji = Kanji.new( data )
				kanji.furigana = Hiragana.new( 
					Kana.romaji2array( md[4] ) ) unless 
						md[4].nil?
				@parts << kanji
				hira = true
			else
				raise( CantParse, source[ 0..40 ] )
			end
		end
	end
	
	def to_s
		@parts.map{|e|e.to_s}.join(';')
	end
	
	def to_html
		@parts.map{|e|e.to_html}.join('')
	end

end; end; end
