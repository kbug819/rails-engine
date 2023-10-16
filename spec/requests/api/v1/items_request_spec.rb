require 'rails_helper'

describe "Items API" do
  it "sends a list of all items" do
        
      create_list(:item, 3)
  
      get '/api/v1/items'
  
      expect(response).to be_successful
  
      items = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(items.count).to eq(3)
  
      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a (String)
  
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a (String)
      end
    end
end