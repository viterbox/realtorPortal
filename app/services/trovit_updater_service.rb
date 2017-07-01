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

    def build_item(trovitProperty)
        itemCreated = Item.create(
            item_id:trovitProperty.at_css("id").nil? ? "" : trovitProperty.at_css("id").text, 
            property_type:trovitProperty.at_css("property_type").nil? ? "" : trovitProperty.at_css("property_type").text,
            url:trovitProperty.at_css("url").nil? ? "" : trovitProperty.at_css("url").text,
            title:trovitProperty.at_css("title").nil? ? "" : trovitProperty.at_css("title").text,
            content:trovitProperty.at_css("content").nil? ? "" : trovitProperty.at_css("content").text,
            type:trovitProperty.at_css("type").nil? ? "" : trovitProperty.at_css("type").text,
            agency:trovitProperty.at_css("agency").nil? ? "" : trovitProperty.at_css("agency").text,
            currency:trovitProperty.at_css("price").nil? ? "" : trovitProperty.at_css("price").attr("currency"),
            price:trovitProperty.at_css("price").nil? ? "" : trovitProperty.at_css("price").text,
            period:trovitProperty.at_css("price").nil? ? "" : trovitProperty.at_css("price").attr("period"),
            date:trovitProperty.at_css("date").nil? ? "" : trovitProperty.at_css("date").text,
            time:trovitProperty.at_css("time").nil? ? "" : trovitProperty.at_css("time").text
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
        itemCreated = build_item(trovitProperty)
        build_item_location(itemCreated, trovitProperty)
        build_item_attributes(itemCreated, trovitProperty)
        build_item_pictures(itemCreated,trovitProperty)
        }
    end
end
