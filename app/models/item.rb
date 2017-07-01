class Item
  include Mongoid::Document
  embeds_many :picture
  embeds_one :location
  embeds_many :attribute
  field :property_type, type: String
  field :item_id, type: String
  field :url, type: String
  field :title, type: String
  field :content, type: String
  field :type, type: String
  field :agency, type: String
  field :currency, type: String
  field :price, type: Float
  field :period, type: String
  field :date, type: String
  field :time, type: String
  field :status, type: String

  def self.get_by_item_id(itemId)
    Item.where(item_id:itemId)  
  end
end