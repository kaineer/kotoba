#
#
#
#
#

require File.join( File.dirname( __FILE__ ), "authentication" )

class User
  include DataMapper::Resource

  property :id,       Serial
  property :login,    String
  property :email,    String
  property :password, String

  has n, :user_bookmarks
end # of properties


class User
  def self.current_id
    Session[ "user_id" ]
  end

  def self.current
    user_id = self.current_id

    user_id ? User.get!( self.current_id ) : nil
  end

  def self.logged_in?
    self.current
  end

  def self.current=( user )
    Session[ "user_id" ] = user ? user.id : nil
  end

  def self.login( login, password )
    if validate_username?( login )
      user = User.first( :login.eql => login )
      if user && Authentication.authenticate?( user, password )
        User.current = user
      end
    end
    User.current
  end

  def self.logout
    if self.current_id
      self.current = nil
    end
  end

  def self.username
    user = self.current
    user ? user.login : nil
  end

  def self.create_with( login, password, email )
    User.create( :login => login, 
                 :password => Authentication.garble( password ), 
                 :email => email )
  end

  def self.validate_username?( login )
    return true if /^\w+$/ === login
    false
  end

  def self.find_admin
    User.first( :login.eql => "admin" )
  end

  def self.ensure_admin_existance
    unless self.find_admin
      User.create_with( "admin", "greencheese", "kaineer@gmail.com" )
    end
  end
end

class User
  def mark( tango_id )
    self.user_bookmarks.first( :tango_id.eql => tango_id ) || 
      UserBookmark.create( :user_id => self.id, :tango_id => tango_id )
  end

  def unmark( tango_id )
    if ( mark = self.user_bookmarks.first( :tango_id.eql => tango_id ) )
      mark.destroy
    end
  end

  def clear_bookmarks
    self.user_bookmarks.all.each do |bmk|
      bmk.destroy
    end
  end
end

