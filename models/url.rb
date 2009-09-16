#
#
#
#
#

module Url
  def self.tango( id = 0 )
    "/tango/#{id}"
  end

  def self.bookmark_set( id = 0 )
    "/bookmark/#{id}/set"
  end

  def self.bookmark_unset( id = 0 )
    "/bookmark/#{id}/unset"
  end

  def self.print_bookmarks
    "/print"
  end

  def self.clear_bookmarks
    "/clear"
  end

  def self.user
    score = UserScore.find_or_create( User.current_id )
    Url.tango( ( score && score.tango_id ).to_i )
  end
end
