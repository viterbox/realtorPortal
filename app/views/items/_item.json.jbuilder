json.extract! item, :id, :propertyType, :itemId, :url, :title, :content, :type, :agency, :currency, :price, :unit, :floorArea, :rooms, :bathrooms, :city, :cityArea, :region, :longitude, :latitude, :mainPicture, :date, :time, :created_at, :updated_at
json.url item_url(item, format: :json)
