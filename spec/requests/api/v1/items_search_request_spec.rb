require 'rails_helper'

describe "Items search API" do
  it "searches and finds one item based on a search of a fragment, case insensitive" do
    merchant_id = create(:merchant).id
    item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 12.5, merchant_id: merchant_id)
    item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 12.5, merchant_id: merchant_id)
    item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
    # search_keyword = "Mirror"

    # headers = {"CONTENT_TYPE" => "application/json"}

    get "/api/v1/items/find?name=MiR"
    #params: JSON.generate(item: item_params)
    # get api_v1_item_find_index_path, params: JSON.generate(name: search_keyword) #(name: "#{search_keyword}")

    expect(response).to be_successful
    item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(item).to have_key(:id)
    expect(item[:id]).to be_a (String)

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to eq(item_2.name)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to eq(item_2.description)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to eq(item_2.unit_price)

    expect(item[:attributes]).to have_key(:merchant_id)
    expect(item[:attributes][:merchant_id]).to eq(item_2.merchant_id)
  end

  xit "returns an error message if nothing is found" do
    merchant_id = create(:merchant).id
    item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 12.5, merchant_id: merchant_id)
    item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 12.5, merchant_id: merchant_id)
    item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
    # search_keyword = "Mirror"

    # headers = {"CONTENT_TYPE" => "application/json"}

    get "/api/v1/items/find?name=NOMATCH"
    #params: JSON.generate(item: item_params)
    # get api_v1_item_find_index_path, params: JSON.generate(name: search_keyword) #(name: "#{search_keyword}")

    expect(response).to be_successful
    item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(item).to have_key(:id)
    expect(item[:id]).to be_a (String)

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to eq(item_2.name)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to eq(item_2.description)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to eq(item_2.unit_price)

    expect(item[:attributes]).to have_key(:merchant_id)
    expect(item[:attributes][:merchant_id]).to eq(item_2.merchant_id)
  end

  it "searches and finds ALL item based on a search of a fragment, case insensitive" do
    merchant_id = create(:merchant).id
    item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 12.5, merchant_id: merchant_id)
    item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 12.5, merchant_id: merchant_id)
    item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
    item_4 = Item.create!(name: "Mirage Wall", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
    item_5 = Item.create!(name: "Art: Mired Pond", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
    # search_keyword = "Mirror"

    # headers = {"CONTENT_TYPE" => "application/json"}

    get "/api/v1/items/find_all?name=MiR"
    #params: JSON.generate(item: item_params)
    # get api_v1_item_find_index_path, params: JSON.generate(name: search_keyword) #(name: "#{search_keyword}")

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)[:data]
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
    expect(items[0][:id].to_i).to eq(item_5.id)
    expect(items[1][:id].to_i).to eq(item_4.id)
    expect(items[2][:id].to_i).to eq(item_2.id)
  end

  it "searches and finds ALL item whose minimum price is 999" do
    merchant_id = create(:merchant).id
    item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 1000, merchant_id: merchant_id)
    item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 10001, merchant_id: merchant_id)
    item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
    item_4 = Item.create!(name: "Mirage Wall", description: "To drink water", unit_price: 998, merchant_id: merchant_id)
    item_5 = Item.create!(name: "Art: Mired Pond", description: "To drink water", unit_price: 999, merchant_id: merchant_id)
    # search_keyword = "Mirror"

    # headers = {"CONTENT_TYPE" => "application/json"}

    get "/api/v1/items/find_all?min_price=999"
    #params: JSON.generate(item: item_params)
    # get api_v1_item_find_index_path, params: JSON.generate(name: search_keyword) #(name: "#{search_keyword}")

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)[:data]
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
    expect(items[0][:id].to_i).to eq(item_2.id)
    expect(items[1][:id].to_i).to eq(item_1.id)
    expect(items[2][:id].to_i).to eq(item_5.id)
  end

  it "searches and finds ALL item whose minimum price is 999" do
    merchant_id = create(:merchant).id
    item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 1000, merchant_id: merchant_id)
    item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 10001, merchant_id: merchant_id)
    item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
    item_4 = Item.create!(name: "Mirage Wall", description: "To drink water", unit_price: 998, merchant_id: merchant_id)
    item_5 = Item.create!(name: "Art: Mired Pond", description: "To drink water", unit_price: 999, merchant_id: merchant_id)
    # search_keyword = "Mirror"

    # headers = {"CONTENT_TYPE" => "application/json"}

    get "/api/v1/items/find_all?min_price=999"
    #params: JSON.generate(item: item_params)
    # get api_v1_item_find_index_path, params: JSON.generate(name: search_keyword) #(name: "#{search_keyword}")

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)[:data]
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
    expect(items[0][:id].to_i).to eq(item_2.id)
    expect(items[1][:id].to_i).to eq(item_1.id)
    expect(items[2][:id].to_i).to eq(item_5.id)
  end

  it "cannot pass in name and price" do
    merchant_id = create(:merchant).id
    item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 1000, merchant_id: merchant_id)
    item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 10001, merchant_id: merchant_id)
    item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
    item_4 = Item.create!(name: "Mirage Wall", description: "To drink water", unit_price: 998, merchant_id: merchant_id)
    item_5 = Item.create!(name: "Art: Mired Pond", description: "To drink water", unit_price: 999, merchant_id: merchant_id)
    # search_keyword = "Mirror"

    # headers = {"CONTENT_TYPE" => "application/json"}

    get "/api/v1/items/find_all?name=ring&min_price=-5"

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(items).to eq([])
  end
end