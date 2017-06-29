class UpdaterController < ApplicationController
  def index
    require 'zlib'
    require 'open-uri'
    
    # Download file xml.gz
    download = open('http://www.stagingeb.com/feeds/d420256874ddb9b6ee5502b9d54e773d8316a695/trovit_MX.xml.gz')
    IO.copy_stream(download, '/tmp/trovit_MX.xml.gz')

    @result = "Data updated"
  end
end
