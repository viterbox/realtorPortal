require_relative 'updater_service'
require_relative 'file_utils_service'
require_relative '../dtos/property_dto'

class TrovitUpdaterService < UpdaterService

    TROVIT_GZ_FILE_URL = 'http://www.stagingeb.com/feeds/d420256874ddb9b6ee5502b9d54e773d8316a695/trovit_MX.xml.gz'
    TROVIT_GZ_FILE_PATH = '/tmp/trovit_MX.xml.gz'
    TROVIT_XML_FILE_PATH = '/tmp/trovit_MX.xml'

    trovitXmlFile = nil

    def get_properties
        propertyList = []

        FileUtilsService.download_file(TROVIT_GZ_FILE_URL, TROVIT_GZ_FILE_PATH)
        FileUtilsService.uncompress_gz_file(TROVIT_GZ_FILE_PATH, TROVIT_XML_FILE_PATH)
        trovitXmlFile = FileUtilsService.open_xml_file(TROVIT_XML_FILE_PATH)

        trovitAdNodes = get_properties_from_trovit(trovitXmlFile)
    
        build_property_list(trovitAdNodes)
    end

    def build_property_list(trovitAdNodes)
        propertyList = []

        trovitAdNodes.each { |adNode|
            
            property = PropertyDto.new
            
            property.item_id = get_property_field(adNode, "id")
            property.property_type = get_property_field(adNode, "property_type")
            property.url = get_property_field(adNode, "url")
            property.title = get_property_field(adNode, "title")
            property.content = get_property_field(adNode, "content")
            property.type = get_property_field(adNode, "type")
            property.agency = get_property_field(adNode, "agency")
            property.currency = get_property_field_attribute(adNode, "price", "currency")
            property.price = get_property_field(adNode, "price")
            property.period = get_property_field_attribute(adNode, "price", "period")
            property.date = get_property_field(adNode, "date")
            property.time = get_property_field(adNode, "time")

            property.city = get_property_field(adNode, "city")
            property.city_area = get_property_field(adNode, "city_area")
            property.region = get_property_field(adNode, "region")
            property.postalcode = get_property_field(adNode, "postalcode")
            property.longitude = get_property_field(adNode, "longitude")
            property.latitude = get_property_field(adNode, "latitude")

            property.attributes = get_attributes_list(adNode)
            property.pictures = get_picture_list(adNode)
            
            propertyList << property
        }

        propertyList
    end

    def get_properties_from_trovit(trovitXmlFile)
        trovitXmlFile.xpath("//ad").map
    end

    def get_property_field(adNode, fildName)
        adNode.at_css(fildName).nil? ? "" : adNode.at_css(fildName).text
    end

    def get_property_field_attribute(adNode, fildName, attributeName)
        adNode.at_css(fildName).nil? ? "" : (adNode.at_css(fildName).attr(attributeName).nil? ? "" : adNode.at_css(fildName).attr(attributeName))
    end

    def get_attributes_list(adNode)
         attributeList = []

        if (get_property_field(adNode, "rooms") != "")
            attributeList << {type:"integer", name:"rooms", value:get_property_field(adNode, "rooms"), decorated:""}
        end

        if (get_property_field(adNode, "bathrooms") != "")
            attributeList << {type:"integer", name:"bathrooms", value:adNode.at_css("bathrooms").text, decorated:""}
        end

        if (get_property_field(adNode, "parking") != "")
            attributeList << {type:"integer", name:"parking", value:get_property_field(adNode, "parking"), decorated:""}
        end

        if (get_property_field(adNode, "year") != "")
            attributeList << {type:"integer", name:"year", value:get_property_field(adNode, "year"), decorated:""}
        end

        if (get_property_field(adNode, "is_new") != "")
            attributeList << {type:"boolean", name:"is_new", value:get_property_field(adNode, "is_new"), decorated:""}
        end

        if (get_property_field(adNode, "floor_area") != "")
            attributeList << {type:"number_unit", name:"floor_area", value:get_property_field(adNode, "floor_area"), decorated:get_property_field_attribute(adNode, "floor_area", "unit")}
        end

        if (get_property_field(adNode, "plot_area") != "")
            attributeList << {type:"number_unit", name:"plot_area", value:get_property_field(adNode, "plot_area"), decorated:get_property_field_attribute(adNode, "plot_area", "unit")}
        end

        attributeList
    end

    def get_picture_list(adNode)
        picturesList = []
        pictures = adNode.at_css("pictures").nil? ? [] : adNode.at_css("pictures").xpath("picture").map
        pictures.each{ |picture|
            picturesList << {picture_url:picture.at_css("picture_url").text}
        }

        picturesList
    end
end
