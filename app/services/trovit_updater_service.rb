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

    def get_property_fied(trovitProperty, fildName)
        trovitProperty.at_css(fildName).nil? ? "" : trovitProperty.at_css(fildName).text
    end

    def build_item(trovitProperty)
        newItem = Item.create(
            item_id:get_property_fied(trovitProperty, "id"), 
            property_type:get_property_fied(trovitProperty, "property_type"),
            url:get_property_fied(trovitProperty, "url"),
            title:get_property_fied(trovitProperty, "title"),
            content:get_property_fied(trovitProperty, "content"),
            type:get_property_fied(trovitProperty, "type"),
            agency:get_property_fied(trovitProperty, "agency"),
            currency:trovitProperty.at_css("price").nil? ? "" : trovitProperty.at_css("price").attr("currency"),
            price:get_property_fied(trovitProperty, "price"),
            period:trovitProperty.at_css("price").nil? ? "" : trovitProperty.at_css("price").attr("period"),
            date:get_property_fied(trovitProperty, "date"),
            time:get_property_fied(trovitProperty, "time"),
        )
    end

    def build_item_location(item, trovitProperty)
        item.create_location(
            city:trovitProperty.at_css("city").nil? ? "" : trovitProperty.at_css("city").text,
            city_area:trovitProperty.at_css("city_area").nil? ? "" : trovitProperty.at_css("city_area").text,
            region:trovitProperty.at_css("region").nil? ? "" : trovitProperty.at_css("region").text,
            postalcode:trovitProperty.at_css("postalcode").nil? ? "" : trovitProperty.at_css("postalcode").text,
            longitude:trovitProperty.at_css("longitude").nil? ? "" : trovitProperty.at_css("longitude").text,
            latitude:trovitProperty.at_css("latitude").nil? ? "" : trovitProperty.at_css("latitude").text
        )
    end

    def build_item_attributes(item, trovitProperty)
        attributeList = []

        if (!trovitProperty.at_css("rooms").nil?)
            attributeList << {type:"integer",name:"rooms",value:trovitProperty.at_css("rooms").text,decorated:""}
        end

        if (!trovitProperty.at_css("bathrooms").nil?)
            attributeList << {type:"integer",name:"bathrooms",value:trovitProperty.at_css("bathrooms").text,decorated:""}
        end

        if (!trovitProperty.at_css("parking").nil?)
            attributeList << {type:"integer",name:"parking",value:trovitProperty.at_css("parking").text,decorated:""}
        end

        if (!trovitProperty.at_css("year").nil?)
            attributeList << {type:"integer",name:"year",value:trovitProperty.at_css("year").text,decorated:""}
        end

        if (!trovitProperty.at_css("is_new").nil?)
            attributeList << {type:"boolean",name:"is_new",value:trovitProperty.at_css("is_new").text,decorated:""}
        end

        if (!trovitProperty.at_css("floor_area").nil?)
            attributeList << {type:"number_unit",name:"floor_area",value:trovitProperty.at_css("floor_area").text,decorated:trovitProperty.at_css("floor_area").attr("unit")}
        end

        if (!trovitProperty.at_css("plot_area").nil?)
            attributeList << {type:"number_unit",name:"plot_area",value:trovitProperty.at_css("plot_area").text,decorated:trovitProperty.at_css("plot_area").attr("unit")}
        end

        item.attribute.create(attributeList)     
    end

    def build_item_pictures(item, trovitProperty)
        pictures = trovitProperty.at_css("pictures").nil? ? [] : trovitProperty.at_css("pictures").xpath("picture").map
        picturesList = []
        pictures.each{ |picture|
            picturesList << {picture_url:picture.at_css("picture_url").text}
        }

        item.picture.create(picturesList)     
    end

    def update_data
        
        trovitXmlFile = open_trovit_file

        trovitProperties = get_properties_from_trovit(trovitXmlFile)

        Item.destroy_all

        trovitProperties.each { |trovitProperty| 
            newItem = build_item(trovitProperty)
            build_item_location(newItem, trovitProperty)
            build_item_attributes(newItem, trovitProperty)
            build_item_pictures(newItem,trovitProperty)
        }
    end
end
