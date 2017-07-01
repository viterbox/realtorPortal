json.extract! item, :id, :property_type, :item_id, :url, :title, :content, :type, :agency, :currency, :price, :date, :time, :created_at, :updated_at
json.url item_url(item, format: :json)
