class Picture
  include Mongoid::Document
  field :pictureUrl, type: String
  embedded_in :Item
end
