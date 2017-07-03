require 'rails_helper'
require 'updater_factory_service'

RSpec.describe UpdaterFactoryService do

    describe '.get_updater_service' do
        context 'type is not TROVIT' do
            it { expect{ UpdaterFactoryService.get_updater_service("MELI") }.to raise_error("Updater Type MELI not yet implemented") }
        end
        
        context 'type is TROVIT' do
            it { expect(UpdaterFactoryService.get_updater_service("TROVIT")).to be_kind_of(UpdaterService) }
        end

        context 'type is TROVIT' do
            it { expect(UpdaterFactoryService.get_updater_service("TROVIT")).to be_kind_of(TrovitUpdaterService) }
        end
    end
end