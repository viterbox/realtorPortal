require_relative 'trovit_updater_service'

class UpdaterFactoryService
    def self.get_updater_service(type)
        case type
            when "TROVIT" then TrovitUpdaterService.new
        else
             raise "Type not yet implemented"
        end  
    end
end