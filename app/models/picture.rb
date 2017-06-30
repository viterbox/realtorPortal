class Picture
  include Mongoid::Document
  field :picture_url, type: String
  embedded_in :Item
end
