class Attribute
  include Mongoid::Document
  field :type, type: String
  field :name, type: String
  field :value, type: String
  field :decorated, type: String
  embedded_in :Item
end
