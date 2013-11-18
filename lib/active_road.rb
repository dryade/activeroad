require "active_road/engine"
require 'erb'
require 'saxerator'
require "activerecord-postgres-hstore"
require "activerecord-import"
require "enumerize"
require "acts_as_list"
require "postgis_adapter"
require "georuby-ext"

module ActiveRoad

  def self.srid
    4326
  end

  def self.database_configuration
    YAML::load(ERB.new(IO.read( File.expand_path('../../config/database.yml', __FILE__))).result)
  end
  
end

require "active_road/shortest_path"
require "active_road/shortest_path/finder"
