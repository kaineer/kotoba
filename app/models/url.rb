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
    "/bookmarks/print"
  end

  def self.clear_bookmarks
    "/bookmarks/clear"
  end

  def self.user
    score = UserScore.find_or_create( User.current_id )
    Url.tango( ( score && score.tango_id ).to_i )
  end

  def self.webmail( to, subj, body )
    "http://mail.google.com/mail/?view=cm&ui=1&fs=1&to=%s&su=%s&body=%s" % [ to, subj, body ]
  end

  def self.validation( message )
    webmail( "kaineer@gmail.com", "[kotoba.validation]", message )
  end

  def self.login
    "/login"
  end

  def self.logout
    "/logout"
  end

  def self.register
    "/register"
  end

  def self.verify
    "/verify"
  end

  def self.do_verify
    "/do/verify"
  end

  def self.admin_registrations
    "/admin/registrations"
  end

  def self.admin_verify
    "/admin/verify"
  end
end
