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

    def build_item(trovitPropery)
        itemCreated = Item.create(
            item_id:trovitPropery.at_css("id").nil? ? "" : trovitPropery.at_css("id").text, 
            property_type:trovitPropery.at_css("property_type").nil? ? "" : trovitPropery.at_css("property_type").text,
            url:trovitPropery.at_css("url").nil? ? "" : trovitPropery.at_css("url").text,
            title:trovitPropery.at_css("title").nil? ? "" : trovitPropery.at_css("title").text,
            content:trovitPropery.at_css("content").nil? ? "" : trovitPropery.at_css("content").text,
            type:trovitPropery.at_css("type").nil? ? "" : trovitPropery.at_css("type").text,
            agency:trovitPropery.at_css("agency").nil? ? "" : trovitPropery.at_css("agency").text,
            currency:trovitPropery.at_css("price").nil? ? "" : trovitPropery.at_css("price").attr("currency"),
            price:trovitPropery.at_css("price").nil? ? "" : trovitPropery.at_css("price").text,
            period:trovitPropery.at_css("price").nil? ? "" : trovitPropery.at_css("price").attr("period"),
            date:trovitPropery.at_css("date").nil? ? "" : trovitPropery.at_css("date").text,
            time:trovitPropery.at_css("time").nil? ? "" : trovitPropery.at_css("time").text
        )
    end

    def build_item_location(item, trovitPropery)
        item.create_location(
            city:trovitPropery.at_css("city").nil? ? "" : trovitPropery.at_css("city").text,
            city_area:trovitPropery.at_css("city_area").nil? ? "" : trovitPropery.at_css("city_area").text,
            region:trovitPropery.at_css("region").nil? ? "" : trovitPropery.at_css("region").text,
            postalcode:trovitPropery.at_css("postalcode").nil? ? "" : trovitPropery.at_css("postalcode").text,
            longitude:trovitPropery.at_css("longitude").nil? ? "" : trovitPropery.at_css("longitude").text,
            latitude:trovitPropery.at_css("latitude").nil? ? "" : trovitPropery.at_css("latitude").text
        )
    end

    def update_data
        
        trovitXmlFile = open_trovit_file

        trovitProperties = get_properties_from_trovit(trovitXmlFile)

        Item.destroy_all

        trovitProperties.each { |trovitPropery| 
        itemCreated = build_item(trovitPropery)
        build_item_location(itemCreated, trovitPropery)

        # Attributes management
        attributeList = []
        if (!trovitPropery.at_css("rooms").nil?)
            attributeList << {type:"integer",name:"rooms",value:trovitPropery.at_css("rooms").text,decorated:""}
        end

        if (!trovitPropery.at_css("bathrooms").nil?)
            attributeList << {type:"integer",name:"bathrooms",value:trovitPropery.at_css("bathrooms").text,decorated:""}
        end

        if (!trovitPropery.at_css("parking").nil?)
            attributeList << {type:"integer",name:"parking",value:trovitPropery.at_css("parking").text,decorated:""}
        end

        if (!trovitPropery.at_css("year").nil?)
            attributeList << {type:"integer",name:"year",value:trovitPropery.at_css("year").text,decorated:""}
        end

        if (!trovitPropery.at_css("is_new").nil?)
            attributeList << {type:"boolean",name:"is_new",value:trovitPropery.at_css("is_new").text,decorated:""}
        end

        if (!trovitPropery.at_css("floor_area").nil?)
            attributeList << {type:"number_unit",name:"floor_area",value:trovitPropery.at_css("floor_area").text,decorated:trovitPropery.at_css("floor_area").attr("unit")}
        end

        if (!trovitPropery.at_css("plot_area").nil?)
            attributeList << {type:"number_unit",name:"plot_area",value:trovitPropery.at_css("plot_area").text,decorated:trovitPropery.at_css("plot_area").attr("unit")}
        end

        itemCreated.attribute.create(attributeList)

        
        # Picture management
        pictures = trovitPropery.at_css("pictures").nil? ? [] : trovitPropery.at_css("pictures").xpath("picture").map
        picturesList = []
        pictures.each{ |picture|
            picturesList << {picture_url:picture.at_css("picture_url").text}
        }

        itemCreated.picture.create(picturesList)
        }
    end
end
