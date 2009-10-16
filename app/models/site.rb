#
#
#

class Site
  @@config = YAML.
    load_file( File.
          join( File.dirname( __FILE__ ), 
                "../../config/site.yml" ) 
          )
  
  def self.base
    @@config[ 'base' ]
  end

  def self.email
    @@config[ 'email' ]
  end
end
