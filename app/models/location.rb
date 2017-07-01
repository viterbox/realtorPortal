class Location
  include Mongoid::Document
  field :city, type: String
  field :city_area, type: String
  field :region, type: String
  field :postalcode, type: String
  field :longitude, type: Float
  field :latitude, type: Float
  embedded_in :Item
end
