#
# Recently visited tangos
#
#
#
module Visited
  #
  def self.store( tango_id )
    visited = get_ids

    visited = visited.reject{|i|i==tango_id}
    visited << tango_id
    visited = visited[ (-MAX_COUNT)..(-1) ] if visited.size > MAX_COUNT
    
    Session[ "visited" ] = visited
  end

  def self.ids
    get_ids.sort
  end

  def self.clear
    Session[ "visited" ] = []
  end

protected
  #
  def self.get_ids
    Session[ "visited" ] || []
  end

  #
  @@visited = []
  MAX_COUNT = 10
end
