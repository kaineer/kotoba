#
#
require 'dm-core'

$:.unshift( File.dirname( __FILE__ ) )

module Models
  def self.migrate
    datamapper_startup
    require_from( "models/scheme" )

    DataMapper::AutoMigrator.auto_upgrade
  end

  def self.reset
    datamapper_startup
    require_from( "models/scheme" )

    DataMapper.auto_migrate!

    ensure_user_logic
    default_users
  end

  def self.startup
    migrate
    in_memory_logic
    load_logic
    default_users
  end

  FILES = [ "user", "user_score", "user_bookmark", "user_registration" ]

  def self.require_from( dir, files = FILES )
    files.each do |name|
      filename = File.join( dir, name )
      puts "Loading from #{filename}.."
      require filename
    end
  end

  def self.datamapper_startup
    DataMapper.setup( :default,
                      ENV[ "DATABASE_URL" ] || 
                      local_datamapper_startup )
  end

  def self.local_datamapper_startup
    Dir.mkdir( "db" ) unless File.directory?( "db" )

    "sqlite3:///#{Dir.pwd}/db/tango.db"  
  end

  def self.in_memory_logic
    require_from( "models", 
         %w( jlpt visited words session url register ) )
  end

  def self.load_logic
    require_from( "models/logics" )
  end

  def self.ensure_user_logic
    require 'models/logics/user'
  end

  def self.default_users
    User.ensure_admin_existance
    User.ensure_demo_existance
  end
end