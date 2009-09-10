require File.join( File.dirname( __FILE__ ), "session" )

#
#
#
class BaseStorage
  def initialize
  end

  def []( key )
    @config[ key ]
  end

  def []=( key, value )
    @config[ key ] = value
  end

protected
  #
  def config
    @config ||= load
  end

  #
  def load
  end

  #
  def store
  end
end

class SessionStorage < BaseStorage
  #
  def []( key )
    session[ key ]
  end

  #
  def []=( key, value )
    session[ key ] = value
  end

protected
  #
  def load
    Session.instance
  end
end

class FileStorage < BaseStorage
end
