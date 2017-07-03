class PropertyDto
    attr_accessor :property_type, :item_id, :url, :title, :content, :type, :agency, :currency, :price, :period, :date, :time, :city, :city_area, :region, :postalcode, :longitude, :latitude, :attributes, :pictures

    def initialize
        @property_type, @item_id, @url, @title, @content, @type, @agency, @currency = ""
        @period, @date, @time, @city, @city_area, @region, @postalcode = ""
        @price = 0
        @longitude, @latitude = 0
        @attributes, @pictures = []
    end

end