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

    def update_data
        
        trovitXmlFile = open_trovit_file

        adNodes = trovitXmlFile.xpath("//ad").map

        Item.destroy_all

        adNodes.each { |node| 
        itemCreated = Item.create(
            item_id:node.at_css("id").nil? ? "" : node.at_css("id").text, 
            property_type:node.at_css("property_type").nil? ? "" : node.at_css("property_type").text,
            url:node.at_css("url").nil? ? "" : node.at_css("url").text,
            title:node.at_css("title").nil? ? "" : node.at_css("title").text,
            content:node.at_css("content").nil? ? "" : node.at_css("content").text,
            type:node.at_css("type").nil? ? "" : node.at_css("type").text,
            agency:node.at_css("agency").nil? ? "" : node.at_css("agency").text,
            currency:node.at_css("price").nil? ? "" : node.at_css("price").attr("currency"),
            price:node.at_css("price").nil? ? "" : node.at_css("price").text,
            period:node.at_css("price").nil? ? "" : node.at_css("price").attr("period"),
            date:node.at_css("date").nil? ? "" : node.at_css("date").text,
            time:node.at_css("time").nil? ? "" : node.at_css("time").text
        )

        # Location management
        itemCreated.create_location(
            city:node.at_css("city").nil? ? "" : node.at_css("city").text,
            city_area:node.at_css("city_area").nil? ? "" : node.at_css("city_area").text,
            region:node.at_css("region").nil? ? "" : node.at_css("region").text,
            postalcode:node.at_css("postalcode").nil? ? "" : node.at_css("postalcode").text,
            longitude:node.at_css("longitude").nil? ? "" : node.at_css("longitude").text,
            latitude:node.at_css("latitude").nil? ? "" : node.at_css("latitude").text
        )

        # Attributes management
        attributeList = []
        if (!node.at_css("rooms").nil?)
            attributeList << {type:"integer",name:"rooms",value:node.at_css("rooms").text,decorated:""}
        end

        if (!node.at_css("bathrooms").nil?)
            attributeList << {type:"integer",name:"bathrooms",value:node.at_css("bathrooms").text,decorated:""}
        end

        if (!node.at_css("parking").nil?)
            attributeList << {type:"integer",name:"parking",value:node.at_css("parking").text,decorated:""}
        end

        if (!node.at_css("year").nil?)
            attributeList << {type:"integer",name:"year",value:node.at_css("year").text,decorated:""}
        end

        if (!node.at_css("is_new").nil?)
            attributeList << {type:"boolean",name:"is_new",value:node.at_css("is_new").text,decorated:""}
        end

        if (!node.at_css("floor_area").nil?)
            attributeList << {type:"number_unit",name:"floor_area",value:node.at_css("floor_area").text,decorated:node.at_css("floor_area").attr("unit")}
        end

        if (!node.at_css("plot_area").nil?)
            attributeList << {type:"number_unit",name:"plot_area",value:node.at_css("plot_area").text,decorated:node.at_css("plot_area").attr("unit")}
        end

        itemCreated.attribute.create(attributeList)

        
        # Picture management
        pictures = node.at_css("pictures").nil? ? [] : node.at_css("pictures").xpath("picture").map
        picturesList = []
        pictures.each{ |picture|
            picturesList << {picture_url:picture.at_css("picture_url").text}
        }

        itemCreated.picture.create(picturesList)
        }
    end
end
