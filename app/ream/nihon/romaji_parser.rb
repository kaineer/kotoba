#---------------------------------------------------------------
#   Date: 2008.03.27 -- 10:13:06
# Author: kaineer
#  Brief: Romaji parser
#   Desc: This class incapsulates rules to parse romaji
#         and returns array of kana keys:
#         for example 'shogun' --> %w( SHI yo GU N ),
#---------------------------------------------------------------

=begin

Use cases:

1. When romaji is correct:

  res = Ream::Nihon::RomajiParser.parse( 'shogun' )
  puts res.arr * ", " # => SHI, yo, GU, N


2. When something is wrong:

  res = Ream::Nihon::RomajiParser.parse( 'kudas' )
  puts res.failure?   # => true
  puts res.arr * ", " # => KU, DA
  puts res.str        # => s

=end


module Ream
  module Nihon
    module RomajiParser
      # Class to keep parsing result
      # :str - used to keep rest of parsed string
      # :arr - used to keep result characters
      class ParseResult
        #
        def initialize( str )
          @str, @arr = str, []
          @result = :unknown
        end

        attr_reader :str, :arr

        def failure?; @result == :failure; end
        def success?; @result == :success; end
        def unknown?; @result == :unknown; end

        def >>( char_number )
          @str = @str[ char_number..-1 ]
          self
        end

        def <<( *char_keys )
          @arr += char_keys
          self
        end

        def []( *args )
          @str[ *args ]
        end

        def stop!
          @result = :success
          @result = :failure if @str.nil?
          @str ||= "" # when @str is nil
          @result = :failure unless @str.empty?
          @str.downcase!
          self
        end
      end

      # Main module method
      #
      def self.parse( str )
        res = ParseResult.new( str.upcase )
        unless str.empty?

          # Stop processing when text is finished
          until res.success?

            # Find rule for text
            rule = @@rules.find{|r| r.accept?( res )}

            # Break parsing on error found
            break if rule.nil?

            # Process parse result
            rule.process( res )
          end
        end
        res.stop!

        # Now it can be used
        res
      end

    protected
      # Container for single rule
      #
      class Rule
        def initialize( re, block )
          @re, @block = re, block
        end

        def accept?( pr )
          @re === pr.str
        end

        # pr - parse result
        def process( pr )
          @block.call( pr )
        end
      end

      # :nodoc: Describing rules here:
      #
      def self.rule( re, &block )
        @@rules << Rule.new( re, Proc.new( &block ) )
      end

      @@rules = []

      # --- little vowels
      rule( /^X[AIUEO]/ ) {|pr|
        pr << pr[1, 1].downcase >> 2
      }

      # --- little tsu
      rule( /^XTSU/ ) {|pr|
        pr << 'tsu' >> 4
      }

      # --- vowels
      rule( /^[AIUEO]/ ) {|pr|
        pr << pr[0, 1] >> 1
      }

      # --- : as U replacement
      rule( /^\:/ ) { |pr|
        pr << 'U' >> 1
      }

      # --- ki*n*youbi: not KI-NI-yo-BI, but KI-N-YO-BI
      rule( /^N\'/ ) {|pr|
        pr << 'N' >> 2
      }

      # --- kyo, rya, nyo etc.
      rule( /^[KGNHBPMR]Y[AUO]/ ) {|pr|
        pr << pr[0, 1]+'I' << 'y'+pr[2, 1].downcase >> 3
      }

      # --- n before not vowel
      rule( /^N([^AIUEO]|\s|$)/ ) {|pr|
        pr << pr[0, 1] >> 1
      }

      # --- 3-letter's exceptions: chi, dzu, tsu
      rule( /^([CS]HI|DZ[IU]|TSU)/ ) {|pr|
        pr << pr[0, 3] >> 3
      }

      # --- di-du, as in wakan
      rule( /^D[IU]/ ) {|pr|
        pr << "DZ" + pr[1,1] >> 2
      }

      # --- sho --> SHI+yo
      rule( /^[CS]H[AUO]/ ) {|pr|
        pr << pr[0, 2]+'I' << 'y'+pr[2, 1].downcase >> 3
      }

      # --- ja --> JI+ya
      rule( /^J[AUO]/ ) {|pr|
        pr << 'JI' << 'y' + pr[1,1].downcase >> 2
      }

      # --- fi --> FU+i
      rule( /^F[AIEO]/ ) {|pr|
        pr << 'FU' << pr[ 1, 1 ].downcase >> 2
      }
      
      rule( /^FU/ ) {|pr|
        pr << 'FU' >> 2
      }

      # --- tsu on double consonant
      # C included for 'cchi'
      rule( /^(TC|([CKGSZTDHBPMR])\2)/ ) {|pr|
        pr << 'tsu' >> 1
      }

      # --- all the rest
      # TODO: remove some cases 2008-03-28 09:55:45
      rule( /^[KGSZTDNHBPMYRW][AIUEO]/ ) {|pr|
        pr << pr[0, 2] >> 2
      }
    end
  end
end

