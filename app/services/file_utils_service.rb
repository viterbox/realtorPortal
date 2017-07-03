require 'zlib'
require 'open-uri'

class FileUtilsService
    def self.download_file(fileUrl, targetFilePath)
        success = true
        if fileUrl.blank?
            raise "parameter fileUrl can not be blank"
        elsif targetFilePath.blank?
            raise "parameter targetFilePath can not be blank"
        end
        
        begin
            download = open(fileUrl)
            IO.copy_stream(download, targetFilePath)
        rescue
            raise "Error donwloading file"  
        end

        success
    end

    def self.uncompress_gz_file(gzFilePath, targetFilePath)
        success = true
        if gzFilePath.blank?
            raise "parameter gzFilePath can not be blank"
        elsif targetFilePath.blank?
            raise "parameter targetFilePath can not be blank"
        end
        
        begin
            Zlib::GzipReader.open(gzFilePath) do | input_stream |
                File.open(targetFilePath, "w") do |output_stream|
                    IO.copy_stream(input_stream, output_stream)
                end
            end
        rescue
            raise "Error uncompressing file"  
        end

        success
    end

    def self.open_file(targetFilePath)
        if targetFilePath.blank?
            raise "parameter targetFilePath can not be blank"
        end

        begin
            File.open(targetFilePath)
         rescue
            raise "Error openning file"  
        end
    end   

    def self.open_xml_file(targetFilePath)
         if targetFilePath.blank?
             raise "parameter targetFilePath can not be blank"
        end
        
        begin
            Nokogiri::XML(open_file(targetFilePath))
        rescue
            raise "Error openning xml file"  
        end
    end   

end