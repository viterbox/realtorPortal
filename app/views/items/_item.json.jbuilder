json.extract! item, :id, :property_type, :item_id, :url, :title, :content, :type, :agency, :currency, :price, :unit, :floor_area, :rooms, :bathrooms, :city, :city_area, :region, :longitude, :latitude, :main_picture, :date, :time, :created_at, :updated_at
json.url item_url(item, format: :json)
