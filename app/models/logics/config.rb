#
class Property

  def self.[]=( name, value )
    parts = name.split( "/" )

    config = get_config( parts, nil, true )

    config.update_attributes( :value => value )
  end

  def self.[]( name )
    parts = name.split( "/" )

    get_config( parts ).value rescue nil
  end

  def self.get_config( parts, parent_id = nil, create = false )
    part_name = parts.shift
    conditions = { :name.eql => part_name }
    conditions[ :parent_id ] = parent_id if parent_id
    config = Config.first( conditions )
    
    if create && !config
      config = Config.
        create( :name => part_name,
                :parent_id => parent_id )
    end
    
    if config && !parts.empty?
      get_config( parts, config.id )
    else
      config
    end
  end
  

end
