class Item
  include Mongoid::Document
  field :propertyType, type: String
  field :itemId, type: String
  field :url, type: String
  field :title, type: String
  field :content, type: String
  field :type, type: String
  field :agency, type: String
  field :currency, type: String
  field :price, type: Float
  field :unit, type: String
  field :floorArea, type: Integer
  field :rooms, type: Integer
  field :bathrooms, type: Integer
  field :city, type: String
  field :cityArea, type: String
  field :region, type: String
  field :longitude, type: Float
  field :latitude, type: Float
  field :mainPicture, type: String
  field :date, type: String
  field :time, type: String
end
