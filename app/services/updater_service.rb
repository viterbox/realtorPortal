class UpdaterService

    def get_properties
        raise 'must implement get_properties() method in subclass'
    end

    def turn_off_properties(properties)

        itemIdList = []
        properties.each{|property|
            itemIdList << property.item_id
        }

        Item.all.each{|item|   
            if !itemIdList.include? item.item_id
                item.update(status:"closed", last_updated:DateTime.now)
            end
        }
    end

    def build_item(property)
        newItem = Item.create(
            item_id:property.item_id, 
            property_type:property.property_type,
            url:property.url,
            title:property.title,
            content:property.content,
            type:property.type,
            agency:property.agency,
            currency:property.currency,
            price:property.price,
            period:property.period,
            date:property.date,
            time:property.time,
            status:"active"
        )
    end

     def build_item_location(item, property)
        item.create_location(
            city:property.city,
            city_area:property.city_area,
            region:property.region,
            postalcode:property.postalcode,
            longitude:property.longitude,
            latitude:property.latitude,
        )
    end

    def build_item_attributes(item, attributeList)
       item.attribute.create(attributeList)     
    end

    def build_item_pictures(item, picturesList)
        item.picture.create(picturesList)     
    end

    def update_item(currentItem, property)
         currentItem.update(
            item_id:property.item_id, 
            property_type:property.property_type,
            url:property.url,
            title:property.title,
            content:property.content,
            type:property.type,
            agency:property.agency,
            currency:property.currency,
            price:property.price,
            period:property.period,
            date:property.date,
            time:property.time,
            status:"active",
            last_updated:DateTime.now
        )
    end

    def update_item_location(currentItem, property)
        currentItem.update( 
            'location.city':property.city,
            'location.city_area':property.city_area,
            'location.region':property.region,
            'location.postalcode':property.postalcode,
            'location.longitude':property.longitude,
            'location.latitude':property.latitude    
        )      
    end

    def update_item_attributes(currentItem, attributeList)
        currentItem.update(attribute:attributeList)      
    end

     def update_item_pictures(currentItem, picturesList)
        currentItem.update(picture:picturesList)     
    end


    def execute
        properties = get_properties
        properties.each{ |property|
            item = Item.get_by_item_id(property.item_id)
            if !item.exists?
                newItem = build_item(property)
                build_item_location(newItem, property)
                build_item_attributes(newItem, property.attributes)
                build_item_pictures(newItem, property.pictures)
            else
                update_item(item, property)
                update_item_location(item, property)
                update_item_attributes(item, property.attributes)
                update_item_pictures(item,  property.pictures)
            end
        }
        turn_off_properties(properties)
    end
end