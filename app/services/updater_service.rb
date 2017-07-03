class UpdaterService
    def get_datasource
        raise 'must implement get_datasource() method in subclass'
    end

    def update_data
        raise 'must implement update_data() method in subclass'
    end
end