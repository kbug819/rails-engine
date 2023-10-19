require 'rails_helper'

describe "Merchants API" do
  it "sends a list of all merchants" do
    
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a (String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq("merchant")

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a (String)
    end
  end

  it "sends a list of one specific merchant" do
    
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"
    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a (String)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a (String)
  end

  it "sends an error code if wrong id is used" do
    id = create(:merchant).id

    get "/api/v1/merchants/45"
    expect(response).to have_http_status(404)
    error = JSON.parse(response.body, symbolize_names: true)[:errors][0]
    expect(error[:status]).to eq("Not Found")
    expect(error[:message]).to eq("No merchants found")
    expect(error[:code]).to eq(404)
  end
  

  it "should return all items associated with a merchant" do
    merchant = create(:merchant)
    create(:item, merchant: merchant)
    create(:item, merchant: merchant)
    create(:item, merchant: merchant)
    id = merchant.id

    get "/api/v1/merchants/#{id}/items"
    # get api_v1_
    expect(response).to be_successful

    merchant_items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant_items.count).to eq(3)
    merchant_items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a (String)

      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a (String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a (String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a (Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a (Integer)
      expect(item[:attributes][:merchant_id]).to eq(id)
    end
  end

  it "sends an error code if wrong id is used to pull merchants items" do
    id = create(:merchant).id

    get "/api/v1/merchants/4454646544/items"
    expect(response).to have_http_status(404)
    error = JSON.parse(response.body, symbolize_names: true)[:errors][0]
    expect(error[:status]).to eq("Not Found")
    expect(error[:message]).to eq("No merchants found")
    expect(error[:code]).to eq(404)
  end
end