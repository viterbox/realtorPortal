require_relative '../services/updater_factory_service'

class UpdaterController < ApplicationController
  def index

    updaterType = 'TROVIT'

    if params[:type]
      updaterType = params[:type]
    end

    begin
      updaterService = UpdaterFactoryService.get_updater_service(updaterType)
      updaterService.execute
       @result = "Data updated"
    rescue Exception => e 
       @result = "Error updating data - error: #{e.message}"
    end
   
    @result
    
  end
end
