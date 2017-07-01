class UpdaterService
    def get_datasource
        raise 'must implement draw() method in subclass'
    end

    def update_data
        raise 'must implement draw() method in subclass'
    end
end