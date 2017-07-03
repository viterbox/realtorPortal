require 'rails_helper'
require 'updater_service'
require_relative '../../app/dtos/property_dto'

RSpec.describe UpdaterService do
    context "setup" do
        before do
            @service = UpdaterService.new
            @property = PropertyDto.new

            @property.item_id = "ABS123"
            @property.property_type = "Casa"
            @property.url = "https://www.stagingeb.com/mx/inmueble/1483-casa-en-cuauhtemoc-hipodromo-condesa?utm_source=Trovit"
            @property.title = "Exclusiva casa"
            @property.content = "Casa exclusiva en Santa Fe"
            @property.type = "For rent"
            @property.agency = "Century21"
            @property.currency = "USD"
            @property.price = "20000.0"
            @property.period = ""
            @property.date = "03/07/2017"
            @property.time = "00:00"

            @property.city = "Mexico"
            @property.city_area = "Santa Fe"
            @property.region = "Cuajimalpa"
            @property.postalcode = "0000"
            @property.longitude = "0.11"
            @property.latitude = "0.25544"

            @property.attributes = [{type:"integer", name:"rooms", value:"4", decorated:""},{type:"integer", name:"bathrooms", value:"3", decorated:""},{type:"number_unit", name:"floor_area", value:"500", decorated:"meters"}]
            @property.pictures = []

            @updatedProperty = PropertyDto.new

            @updatedProperty.item_id = "ABS123"
            @updatedProperty.property_type = "Departamento"
            @updatedProperty.url = "https://www.stagingeb.com/mx/inmueble/1483-casa-en-cuauhtemoc-hipodromo-condesa?utm_source=Trovit"
            @updatedProperty.title = "Exclusivo Departamento"
            @updatedProperty.content = "Departamento exclusivo en Polanco"
            @updatedProperty.type = "For sell"
            @updatedProperty.agency = "Century21"
            @updatedProperty.currency = "USD"
            @updatedProperty.price = "120000.0"
            @updatedProperty.period = ""
            @updatedProperty.date = "03/07/2017"
            @updatedProperty.time = "00:00"

            @updatedProperty.city = "Mexico"
            @updatedProperty.city_area = "Polanco"
            @updatedProperty.region = "Migule Hidalgo"
            @updatedProperty.postalcode = "0000"
            @updatedProperty.longitude = "0.11"
            @updatedProperty.latitude = "0.25544"

            @updatedProperty.attributes = [{type:"integer", name:"rooms", value:"4", decorated:""},{type:"integer", name:"bathrooms", value:"3", decorated:""},{type:"number_unit", name:"floor_area", value:"500", decorated:"meters"},{type:"number_unit", name:"plot_area", value:"800", decorated:"meters"}]
            @updatedProperty.pictures = [{picture_url:"http://s3.amazonaws.com/assets.stagingmg.com/property_images/1483/2967/kitchen.jpg"}]
        end

        it "#build_item" do
            expect{@service.build_item(@property)}.to change { Item.count }.by(1)
        end

        it "#build_item_location" do
            newItem = @service.build_item(@property)
            @service.build_item_location(newItem,@property)
            expect(newItem.location).not_to be_nil          
        end

        it "#build_item_attributes" do
            newItem = @service.build_item(@property)
            @service.build_item_attributes(newItem,@property.attributes)
            expect(newItem.attribute).not_to be_nil
            expect(newItem.attribute.count).to eq(3)       
        end

        it "#build_item_pictures" do
            newItem = @service.build_item(@property)
            @service.build_item_pictures(newItem,@property.pictures)
            expect(newItem.picture).not_to be_nil 
            expect(newItem.picture.count).to eq(0)         
        end

        it "#update_item" do
            newItem = @service.build_item(@property)
            @service.update_item(newItem,@updatedProperty)
            expect(newItem).not_to be_nil
            expect(newItem.property_type).to eq(@updatedProperty.property_type)
            expect(newItem.title).to eq(@updatedProperty.title)
            expect(newItem.type).to eq(@updatedProperty.type)
            expect(newItem.price).to eq(120000.0)
        end
    end
end