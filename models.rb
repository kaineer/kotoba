#
#
require 'dm-core'

#
# memory models
#
require 'models/jlpt'
require 'models/visited'
require 'models/words'
require 'models/session'


DataMapper.setup( :default, "sqlite3:///#{Dir.pwd}/db/tango.db" )
DataMapper::Logger.new(STDOUT, :debug)

#
# database models
#
require 'models/user'
require 'models/user_score'
require 'models/user_bookmark'

DataMapper::AutoMigrator.auto_upgrade

User.ensure_admin_existance
