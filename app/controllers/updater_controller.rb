require_relative '../services/updater_factory_service'

class UpdaterController < ApplicationController
  def index

    updaterType = 'TROVIT'

    if params[:type]
      updaterType = params[:type]
    end

    updaterService = UpdaterFactoryService.get_updater_service(updaterType)
    updaterService.get_datasource
    updaterService.update_data
    
    @result = "Data updated"
  end
end
