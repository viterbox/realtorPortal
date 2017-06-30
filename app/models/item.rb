class Item
  include Mongoid::Document
  embeds_many :picture
  field :property_type, type: String
  field :item_id, type: String
  field :url, type: String
  field :title, type: String
  field :content, type: String
  field :type, type: String
  field :agency, type: String
  field :currency, type: String
  field :price, type: Float
  field :unit, type: String
  field :floor_area, type: Integer
  field :rooms, type: Integer
  field :bathrooms, type: Integer
  field :city, type: String
  field :city_area, type: String
  field :region, type: String
  field :longitude, type: Float
  field :latitude, type: Float
  field :main_picture, type: String
  field :date, type: String
  field :time, type: String
end
