#   Date: 2008.03.27 -- 10:06:43
# Author: kaineer
#  Brief: Base for other Ream::Nihon classes
#   Desc: Yet not decided what it should be
#

#
module Ream
  module Nihon
    class TryResult
      # Readers
      def ok?; @result == :success; end
      def rest; @rest; end
  
      # Create failure result
      def self.failure( string )
        new( :failure, string )
      end      

      # Create success result
      def self.success( rest )
        new( :success, rest )
      end

    protected
      # Shouldn't be used outside
      def initialize( result, rest )
        @result, @rest = result, rest
      end
    end

    class Base
      # Plain text representation
      def to_s; ""; end

      # Ready to insert into html
      def to_html; to_s; end

      # Show what's inside text block      
      def inspect; super; end

      # Should return parsing possibility 
      # for specified string. When string can be parsed,
      # the rest of string may be get through TryResult#get method
      #
      # Should be used in Text parsing cycle
      #
      def self.try( string )
        # In base class just failure for anything
        TryResult.failure( string )
      end
    end
  end
end

