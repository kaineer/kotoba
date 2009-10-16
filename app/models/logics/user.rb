#
#
#
#
#

require File.join( File.dirname( __FILE__ ), "authentication" )

class User
  def name
    self.login
  end

  def self.current_id
    Session[ "user_id" ]
  end

  def self.current
    user_id = self.current_id

    user_id ? User.get!( self.current_id ) : nil
  end

  def self.admin?
    User.logged_in? && User.current.admin?
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

  def self.create_with( login, password, email, admin = false )
    User.create( :login => login, 
                 :password => Authentication.garble( login + password ), 
                 :email => email,
                 :admin => admin )
  end

  def self.validate_username?( login )
    return true if /^\w+(\.\w+)*$/ === login
    false
  end

  def self.find_admin
    User.first( :login.eql => "admin" )
  end

  def self.ensure( login, password, email, admin = false )
    unless User.first( :login.eql => login )
      admin = !admin.nil? ### NOTE: Should be (true|false) only
      User.create_with( login, password, email, admin )
    end
  end
end

#
# Bookmarks logic
#
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

  def admin?
    self.admin
  end
end

#
# Score logic
#
class User
  def score
    @score = self.user_score
    unless @score
      @score = UserScore.create( :user_id => self.id )
    end
    @score
  end
end
