class UpdaterController < ApplicationController
  def index
    require 'zlib'
    require 'open-uri'
    
    # Download file xml.gz
    download = open('http://www.stagingeb.com/feeds/d420256874ddb9b6ee5502b9d54e773d8316a695/trovit_MX.xml.gz')
    IO.copy_stream(download, '/tmp/trovit_MX.xml.gz')

    # Uncompress file xml.gz
    Zlib::GzipReader.open('/tmp/trovit_MX.xml.gz') do | input_stream |
      File.open("/tmp/trovit_MX.xml", "w") do |output_stream|
        IO.copy_stream(input_stream, output_stream)
      end
    end

    # Open file XML with Nokogiri gem
    doc = File.open("/tmp/trovit_MX.xml") { |f| Nokogiri::XML(f) }

    adNodes = doc.xpath("//ad").map

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
        price:node.at_css("price").nil? ? "" : node.at_css("price").text
      )
    }
    
    @result = "Data updated"
  end
end
