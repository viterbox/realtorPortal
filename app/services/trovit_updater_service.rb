require_relative 'updater_service'
require 'zlib'
require 'open-uri'

class TrovitUpdaterService < UpdaterService
    def get_datasource
         download_trovit_file
         uncompress_trovit_file
    end

    def download_trovit_file
        download = open('http://www.stagingeb.com/feeds/d420256874ddb9b6ee5502b9d54e773d8316a695/trovit_MX.xml.gz')
        IO.copy_stream(download, '/tmp/trovit_MX.xml.gz')
    end

    def uncompress_trovit_file
        Zlib::GzipReader.open('/tmp/trovit_MX.xml.gz') do | input_stream |
            File.open("/tmp/trovit_MX.xml", "w") do |output_stream|
                IO.copy_stream(input_stream, output_stream)
            end
        end
    end

    def open_trovit_file
        File.open("/tmp/trovit_MX.xml") { |f| Nokogiri::XML(f) }
    end

    def get_properties_from_trovit(trovitXmlFile)
        trovitXmlFile.xpath("//ad").map
    end

    def get_property_field(trovitProperty, fildName)
        trovitProperty.at_css(fildName).nil? ? "" : trovitProperty.at_css(fildName).text
    end

    def get_property_field_attribute(trovitProperty, fildName, attributeName)
        trovitProperty.at_css(fildName).nil? ? "" : (trovitProperty.at_css(fildName).attr(attributeName).nil? ? "" : trovitProperty.at_css(fildName).attr(attributeName))
    end

    def build_item(trovitProperty)
        newItem = Item.create(
            item_id:get_property_field(trovitProperty, "id"), 
            property_type:get_property_field(trovitProperty, "property_type"),
            url:get_property_field(trovitProperty, "url"),
            title:get_property_field(trovitProperty, "title"),
            content:get_property_field(trovitProperty, "content"),
            type:get_property_field(trovitProperty, "type"),
            agency:get_property_field(trovitProperty, "agency"),
            currency:get_property_field_attribute(trovitProperty, "price", "currency"),
            price:get_property_field(trovitProperty, "price"),
            period:get_property_field_attribute(trovitProperty, "price", "period"),
            date:get_property_field(trovitProperty, "date"),
            time:get_property_field(trovitProperty, "time"),
            status:"active"
        )
    end

    def build_item_location(item, trovitProperty)
        item.create_location(
            city:get_property_field(trovitProperty, "city"),
            city_area:get_property_field(trovitProperty, "city_area"),
            region:get_property_field(trovitProperty, "region"),
            postalcode:get_property_field(trovitProperty, "postalcode"),
            longitude:get_property_field(trovitProperty, "longitude"),
            latitude:get_property_field(trovitProperty, "latitude"),
        )
    end

    def get_attributes_list(trovitProperty)
         attributeList = []

        if (get_property_field(trovitProperty, "rooms") != "")
            attributeList << {type:"integer", name:"rooms", value:get_property_field(trovitProperty, "rooms"), decorated:""}
        end

        if (get_property_field(trovitProperty, "bathrooms") != "")
            attributeList << {type:"integer", name:"bathrooms", value:trovitProperty.at_css("bathrooms").text, decorated:""}
        end

        if (get_property_field(trovitProperty, "parking") != "")
            attributeList << {type:"integer", name:"parking", value:get_property_field(trovitProperty, "parking"), decorated:""}
        end

        if (get_property_field(trovitProperty, "year") != "")
            attributeList << {type:"integer", name:"year", value:get_property_field(trovitProperty, "year"), decorated:""}
        end

        if (get_property_field(trovitProperty, "is_new") != "")
            attributeList << {type:"boolean", name:"is_new", value:get_property_field(trovitProperty, "is_new"), decorated:""}
        end

        if (get_property_field(trovitProperty, "floor_area") != "")
            attributeList << {type:"number_unit", name:"floor_area", value:get_property_field(trovitProperty, "floor_area"), decorated:get_property_field_attribute(trovitProperty, "floor_area", "unit")}
        end

        if (get_property_field(trovitProperty, "plot_area") != "")
            attributeList << {type:"number_unit", name:"plot_area", value:get_property_field(trovitProperty, "plot_area"), decorated:get_property_field_attribute(trovitProperty, "plot_area", "unit")}
        end

        attributeList
    end

    def build_item_attributes(item, trovitProperty)
       attributeList = get_attributes_list(trovitProperty)
       item.attribute.create(attributeList)     
    end

    def get_picture_list(trovitProperty)
        picturesList = []
        pictures = trovitProperty.at_css("pictures").nil? ? [] : trovitProperty.at_css("pictures").xpath("picture").map
        pictures.each{ |picture|
            picturesList << {picture_url:picture.at_css("picture_url").text}
        }

        picturesList
    end

    def build_item_pictures(item, trovitProperty)
        picturesList = get_picture_list(trovitProperty)
        item.picture.create(picturesList)     
    end

    def update_item(currentItem, trovitProperty)

         currentItem.update(
            item_id:get_property_field(trovitProperty, "id"), 
            property_type:get_property_field(trovitProperty, "property_type"),
            url:get_property_field(trovitProperty, "url"),
            title:get_property_field(trovitProperty, "title"),
            content:get_property_field(trovitProperty, "content"),
            type:get_property_field(trovitProperty, "type"),
            agency:get_property_field(trovitProperty, "agency"),
            currency:get_property_field_attribute(trovitProperty, "price", "currency"),
            price:get_property_field(trovitProperty, "price"),
            period:get_property_field_attribute(trovitProperty, "price", "period"),
            date:get_property_field(trovitProperty, "date"),
            time:get_property_field(trovitProperty, "time"),
            status:"active",
            last_updated:DateTime.now
        )
    end

    def update_item_location(currentItem, trovitProperty)

        currentItem.update( 
            'location.city':get_property_field(trovitProperty, "city"),
            'location.city_area':get_property_field(trovitProperty, "city_area"),
            'location.region':get_property_field(trovitProperty, "region"),
            'location.postalcode':get_property_field(trovitProperty, "postalcode"),
            'location.longitude':get_property_field(trovitProperty, "longitude"),
            'location.latitude':get_property_field(trovitProperty, "latitude")    
        )
        
    end

    def update_item_attributes(currentItem, trovitProperty)
        attributeList = get_attributes_list(trovitProperty)
        currentItem.update(attribute:attributeList)      
    end

    def update_data
        
        trovitXmlFile = open_trovit_file

        trovitProperties = get_properties_from_trovit(trovitXmlFile)

        Item.destroy_all

        trovitProperties.each { |trovitProperty| 
            
            itemId = get_property_field(trovitProperty, "id")

            item = Item.get_by_item_id(itemId)
          
            if !item.exists?
                newItem = build_item(trovitProperty)
                build_item_location(newItem, trovitProperty)
                build_item_attributes(newItem, trovitProperty)
                build_item_pictures(newItem,trovitProperty)
            else
                update_item(item,trovitProperty)
                update_item_location(item, trovitProperty)
                update_item_attributes(item, trovitProperty)
            end
        }
    end
end
