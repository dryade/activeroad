class ActiveRoad::StreetNumber < ActiveRoad::ActiveRecord
  validates_presence_of :number, :stored_geometry

  belongs_to :road, :class_name => "ActiveRoad::Base", :foreign_key => "road_id"

  before_validation :compute_locate_on_road, :on => :create

  def stored_geometry
    read_attribute :geometry
  end

  def geometry
    stored_geometry or computed_geometry
  end

  def computed_geometry
    road.at computed_location_on_road
  end

  def location_on_road
    stored_location_on_road or computed_location_on_road
  end

  def stored_location_on_road
    read_attribute :location_on_road
  end

  def compute_locate_on_road
    if stored_location_on_road.nil? and stored_geometry 
      self.location_on_road = road.geometry.locate_point(stored_geometry) 
    end
  end

  # TODO rename into estimated_location_on_road
  def computed_location_on_road
    if previous and self.next
      number_ratio = (number.to_i - previous.number.to_i) / (self.next.number.to_i - previous.number.to_i).to_f
      previous.location_on_road + number_ratio * (self.next.location_on_road - previous.location_on_road)
    end
  end

  def previous
    road.numbers.find :first, :conditions => ["number < ?", number], :limit => 1, :order => "number desc"
  end

  def next
    road.numbers.find :first, :conditions => ["number > ?", number], :limit => 1, :order => "number"
  end

  def number
    Number.new read_attribute(:number)
  end

  class Number < String

    alias_method :numeric_value, :to_i

    def suffix
      gsub(/^[0-9]+/,'')
    end

    def +(value)
      self.class.new "#{numeric_value+value}#{suffix}"
    end

    def -(value)
      self.class.new "#{numeric_value-value}#{suffix}"
    end

  end

end