module Ream; module Nihon; module Symbols
	#
	@@CHARS = {
		'-' => 0x30fc,
		'.' => 0x3002,
		',' => 0x3001,
		'(' => 0x300c,
		')' => 0x300d,
		'[' => 0x300e,
		']' => 0x300f,
		'~' => 0x301c,
		'"' => 0x301e
	}
	
	@@KEYS = /^[-.,()\[\]~"\s\d]+/
	
	def self.keys
		@@KEYS
	end
	
	def self.translate( str )
		syms = str.scan( /./ )
		syms.map{|c|
			d = @@CHARS[ c ]
			if d.nil?
				c
			else
				"&#%d;" % d #"
			end
		}.join('')
	end
	
	def self.match( str )
		str[ @@KEYS ]
	end

end; end; end
