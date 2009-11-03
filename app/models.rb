#
#
require 'rubygems'
require 'dm-core'
require 'yaml'

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

  FILES = [ "user", "user_score", "user_bookmark", "user_registration" ] #, "user_ui" ]

  def self.require_from( dir, files = FILES )
    files.each do |name|
      filename = File.join( dir, name )
      puts "Loading from #{filename}.."
      require filename
    end
  end

  def self.datamapper_startup
    result = self.config_datamapper_startup

    if result.nil?
      DataMapper.setup( :default,
                        ENV[ "DATABASE_URL" ] || 
                        local_datamapper_startup )
    end

    if result == :failure
      exit
    end
  end

  def self.local_datamapper_startup
    Dir.mkdir( "db" ) unless File.directory?( "db" )

    "sqlite3:///#{Dir.pwd}/db/tango.db"  
  end

  def self.config_datamapper_startup
    config_filename = File.join( File.dirname( __FILE__ ), "../config/database.yml" )

    if File.exist?( config_filename )
      begin
        database_config = YAML.load_file( config_filename ).inject( {} ) do |hash, ( key, value )|
          hash.merge( key.to_sym => value )
        end
        
        DataMapper.setup( :default, database_config )

        return true
      rescue Exception => e
        puts "WARNING: Can't perform config setup"
        puts "Filename: #{config_filename}"
        puts "Content: #{IO.read( config_filename )}"
        puts e.inspect
        puts e.backtrace * $/

        return :failure
      end
    else
      return nil
    end
  end

  def self.in_memory_logic
    require_from( "models", 
         %w( tango visited words session url register site ) )
  end

  def self.load_logic
    require_from( "models/logics" )
  end

  def self.ensure_user_logic
    require 'models/logics/user'
  end

  def self.default_users
    default_users = YAML.load_file( 
      File.join( File.dirname( __FILE__ ), "../config/default_users.yml" )
    )

    default_users.each do |u|
      User.ensure( u[ 'login'], u[ 'password' ], u[ 'email' ], u[ 'admin' ] )
    end
  end
end
