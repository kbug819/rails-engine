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
      end
    end

  it "sends a list of one specific item" do
    
    id = create(:item).id

    get "/api/v1/items/#{id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(item).to have_key(:id)
    expect(item[:id]).to be_a (String)

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a (String)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_a (String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to be_a (Float)

    expect(item[:attributes]).to have_key(:merchant_id)
    expect(item[:attributes][:merchant_id]).to be_a (Integer)
  end

  it "sends an error code if id does not exist for item" do

    get "/api/v1/items/4454646544"

    expect(response).to have_http_status(404)
    error = JSON.parse(response.body, symbolize_names: true)[:errors][0]
    expect(error[:status]).to eq("Not Found")
    expect(error[:message]).to eq("No merchants found")
    expect(error[:code]).to eq(404)
  end

  it "sends an error code if id does not exist for item" do

    get "/api/v1/items/'4454646544'"
    
    expect(response).to have_http_status(404)
    error = JSON.parse(response.body, symbolize_names: true)[:errors][0]
    expect(error[:status]).to eq("Not Found")
    expect(error[:message]).to eq("No merchants found")
    expect(error[:code]).to eq(404)
  end

  it "can create a new item" do
    merchant_id = create(:merchant).id

    item_params = ({
                    name: "Mouse Pad",
                    description: "Something to use a mouse on",
                    unit_price: 12.5,
                    merchant_id: "#{merchant_id}"
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last 

    expect(response).to have_http_status(201)
    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id].to_i)
  end

  it "should not take non-approved attributes" do
    merchant_id = create(:merchant).id

    item_params = ({
                    name: "Mouse Pad",
                    unit_price: 12.5,
                    description: "Something to use a mouse on",
                    merchant_id: "#{merchant_id}",
                    average_bought: 34
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last 

    expect(response).to have_http_status(201)
    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id].to_i)
    expect(created_item).not_to respond_to(:average_bought)
  end

  it "should return an error message if an attribute is missing" do
    merchant_id = create(:merchant).id

    item_params = ({
                    name: "Mouse Pad",
                    unit_price: 12.5,
                    merchant_id: "#{merchant_id}",
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last 

    expect(response).to have_http_status(422)
  end

  it "can update an existing item" do
    merchant_id = create(:merchant).id
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: "Kaylee's Item"}

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)
    item = Item.find_by(id: id)

    expect(response).to have_http_status(201)
    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Kaylee's Item")
  end

  it "can update an existing item, but returns error with incorrect merchant id" do
    merchant_id = 20000000
    id = create(:item).id
    item_params = { merchant_id: merchant_id }

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item_params)
    item = Item.find_by(id: id)
    expect(response).to have_http_status(404)
    error = JSON.parse(response.body, symbolize_names: true)[:errors][0]
    expect(error[:status]).to eq("Not Found")
    expect(error[:message]).to eq("No merchants found")
    expect(error[:code]).to eq(404)
  end

  it "can destroy an item" do
    item = create(:item)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(response).to have_http_status(204)

    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "should return the merchant of an item" do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)

    id = item.id

    get "/api/v1/items/#{id}/merchant"
    expect(response).to be_successful

    item_merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(item_merchant).to have_key(:id)
    expect(item_merchant[:id]).to be_a (String)

    expect(item_merchant).to have_key(:type)
    expect(item_merchant[:type]).to eq("merchant")

    expect(item_merchant[:attributes]).to have_key(:name)
    expect(item_merchant[:attributes][:name]).to be_a (String)
  end
end

# if params["merchant_id"].present?
#   merchant = MerchantFacade.new(params).find_merchant
#     if merchant.class == Merchant
#       render json: ItemSerializer.new(Item.update(params[:id], item_params)), status: :created
#     else
#       render json: ErrorMerchantSerializer.new(merchant).serialized_json, status: 404
#     end
# else
#   render json: ItemSerializer.new(Item.update(params[:id], item_params)), status: :created
# end
# end

# render json: ItemSerializer.new(Item.update(params[:id], item_params)), status: :created
