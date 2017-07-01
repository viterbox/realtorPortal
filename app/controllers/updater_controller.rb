require_relative '../services/updater_factory_service'

class UpdaterController < ApplicationController
  def index

    updaterType = 'TROVIT'

    if params[:type]
      updaterType = params[:type]
    end

    updaterFactoryService = UpdaterFactoryService.new

    updaterService = updaterFactoryService.get_updater_service(updaterType)
    updaterService.get_datasource
    updaterService.update_data
    
    @result = "Data updated"
  end
end
