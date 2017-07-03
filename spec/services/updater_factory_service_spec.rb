require 'rails_helper'
require 'updater_factory_service'

RSpec.describe UpdaterFactoryService do

    describe '.get_updater_service' do
        context 'type is blank' do
            it { expect{ UpdaterFactoryService.get_updater_service("") }.to raise_error("Type not yet implemented") }
        end
        
        context 'type is TROVIT' do
            it { expect(UpdaterFactoryService.get_updater_service("TROVIT")).to be_kind_of(UpdaterService) }
        end

        context 'type is TROVIT' do
            it { expect(UpdaterFactoryService.get_updater_service("TROVIT")).to be_kind_of(TrovitUpdaterService) }
        end
    end
end