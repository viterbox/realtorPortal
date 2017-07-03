require 'rails_helper'
require 'file_utils_service'

RSpec.describe FileUtilsService do

    describe '.download_file' do
        context 'fileUrl parameter is blank' do
            it { expect{ FileUtilsService.download_file("","targetFilePath") }.to raise_error("parameter fileUrl can not be blank") }
        end

        context 'targetFilePath parameter is blank' do
            it { expect{ FileUtilsService.download_file("fileUrl","") }.to raise_error("parameter targetFilePath can not be blank") }
        end

        context 'parameters are not blank but files does not exists' do
            it { expect{ FileUtilsService.download_file("fileUrl","targetFilePath") }.to raise_error("Error donwloading file") }
        end

        context 'parameters are valid' do
            before do
                @fileUrl = "http://www.stagingeb.com/feeds/d420256874ddb9b6ee5502b9d54e773d8316a695/trovit_MX.xml.gz"
                @targetFilePath = "/tmp/trovit_MX.xml.gz"
            end
            it { expect(FileUtilsService.download_file(@fileUrl,@targetFilePath)).to eq(true) }
        end

    end
    
    describe '.uncompress_gz_file' do
        context 'gzFilePath parameter is blank' do
            it { expect{ FileUtilsService.uncompress_gz_file("","targetFilePath") }.to raise_error("parameter gzFilePath can not be blank") }
        end

        context 'targetFilePath parameter is blank' do
            it { expect{ FileUtilsService.uncompress_gz_file("gzFilePath","") }.to raise_error("parameter targetFilePath can not be blank") }
        end

        context 'parameters are not blank but files does not exists' do
            it { expect{ FileUtilsService.uncompress_gz_file("gzFilePath","targetFilePath") }.to raise_error("Error uncompressing file") }
        end

         context 'parameters are valid' do
            before do
                @gzFilePath = "/tmp/trovit_MX.xml.gz"
                @targetFilePath = "/tmp/trovit_MX.xml"
            end
            it { expect(FileUtilsService.uncompress_gz_file(@gzFilePath,@targetFilePath)).to eq(true) }
        end
    end

    describe '.open_file' do
        context 'targetFilePath parameter is blank' do
            it { expect{ FileUtilsService.open_file("") }.to raise_error("parameter targetFilePath can not be blank") }
        end

        context 'targetFilePath parameter is not blank but file does not exists' do
            it { expect{ FileUtilsService.open_file("targetFilePath") }.to raise_error("Error openning file") }
        end

        context 'targetFilePath is valid' do
            before do
                @targetFilePath = "/tmp/trovit_MX.xml"
            end
            it { expect(FileUtilsService.open_file(@targetFilePath)).not_to be_nil }
        end
    end

    describe '.open_xml_file' do
        context 'targetFilePath parameter is blank' do
            it { expect{ FileUtilsService.open_xml_file("") }.to raise_error("parameter targetFilePath can not be blank") }
        end

        context 'targetFilePath parameter is not blank but file does not exists' do
            it { expect{ FileUtilsService.open_xml_file("targetFilePath") }.to raise_error("Error openning xml file") }
        end

        context 'targetFilePath is valid' do
            before do
                @targetFilePath = "/tmp/trovit_MX.xml"
            end
            it { expect(FileUtilsService.open_xml_file(@targetFilePath)).not_to be_nil }
        end
    end
end