require 'rails_helper'

describe "item search api" do
  describe "find one item by name" do
    it "searches and finds one item based on a search of a fragment, case insensitive" do
      merchant_id = create(:merchant).id
      item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 12.5, merchant_id: merchant_id)
      item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 12.5, merchant_id: merchant_id)
      item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)

      get "/api/v1/items/find?name=MiR"

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

    it "returns an error message if nothing is found" do
      merchant_id = create(:merchant).id
      item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 12.5, merchant_id: merchant_id)
      item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 12.5, merchant_id: merchant_id)
      item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)

      get "/api/v1/items/find?name=NOMATCH"

      expect(response).to be_successful
      error = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)
      expect(error[:data]).to eq({})
    end
  end

  describe "find all items by name" do
    it "searches and finds ALL item based on a search of a fragment, case insensitive" do
      merchant_id = create(:merchant).id
      item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 12.5, merchant_id: merchant_id)
      item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 12.5, merchant_id: merchant_id)
      item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
      item_4 = Item.create!(name: "Mirage Wall", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
      item_5 = Item.create!(name: "Art: Mired Pond", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)

      get "/api/v1/items/find_all?name=MiR"

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

    it "returns  blank if no fragment matched" do
      merchant_id = create(:merchant).id
      item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 12.5, merchant_id: merchant_id)
      item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 12.5, merchant_id: merchant_id)
      item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
      item_4 = Item.create!(name: "Mirage Wall", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
      item_5 = Item.create!(name: "Art: Mired Pond", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)

      get "/api/v1/items/find_all?name=NOMATCH"

      expect(response).to be_successful
      error = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)
      expect(error[:data]).to eq([])
    end
  end

  describe "find all items by min_price" do
    it "searches and finds ALL item whose minimum price is 999" do
      merchant_id = create(:merchant).id
      item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 1000, merchant_id: merchant_id)
      item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 10001, merchant_id: merchant_id)
      item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
      item_4 = Item.create!(name: "Mirage Wall", description: "To drink water", unit_price: 998, merchant_id: merchant_id)
      item_5 = Item.create!(name: "Art: Mired Pond", description: "To drink water", unit_price: 999, merchant_id: merchant_id)

      get "/api/v1/items/find_all?min_price=999"

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

    it "finds all by maximum price" do
      merchant_id = create(:merchant).id
      item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 1000, merchant_id: merchant_id)
      item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 10001, merchant_id: merchant_id)
      item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
      item_4 = Item.create!(name: "Mirage Wall", description: "To drink water", unit_price: 998, merchant_id: merchant_id)
      item_5 = Item.create!(name: "Art: Mired Pond", description: "To drink water", unit_price: 999, merchant_id: merchant_id)

      get "/api/v1/items/find_all?max_price=999"

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
      expect(items[2][:id].to_i).to eq(item_3.id)
    end

    it "cannot pass in name and price" do
      merchant_id = create(:merchant).id
      item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 1000, merchant_id: merchant_id)
      item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 10001, merchant_id: merchant_id)
      item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
      item_4 = Item.create!(name: "Mirage Wall", description: "To drink water", unit_price: 998, merchant_id: merchant_id)
      item_5 = Item.create!(name: "Art: Mired Pond", description: "To drink water", unit_price: 999, merchant_id: merchant_id)

      get "/api/v1/items/find_all?name=ring&min_price=-5"

      expect(response).to have_http_status(400)
      error = JSON.parse(response.body, symbolize_names: true)[:errors][0]
      expect(error[:status]).to eq("Cannot Find")
      expect(error[:message]).to eq("Either min/max is below 0, or you cannot pass name and price params together")
      expect(error[:code]).to eq(400)

      get "/api/v1/items/find_all?name=ring&max_price=-5"

      expect(response).to have_http_status(400)
      error = JSON.parse(response.body, symbolize_names: true)[:errors][0]
      expect(error[:status]).to eq("Cannot Find")
      expect(error[:message]).to eq("Either min/max is below 0, or you cannot pass name and price params together")
      expect(error[:code]).to eq(400)
    end

    it "cannot pass min_price or max_price less than 0" do
      merchant_id = create(:merchant).id
      item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 1000, merchant_id: merchant_id)
      item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 10001, merchant_id: merchant_id)
      item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
      item_4 = Item.create!(name: "Mirage Wall", description: "To drink water", unit_price: 998, merchant_id: merchant_id)
      item_5 = Item.create!(name: "Art: Mired Pond", description: "To drink water", unit_price: 999, merchant_id: merchant_id)

      get "/api/v1/items/find_all?max_price=-5"

      expect(response).to have_http_status(400)
      error = JSON.parse(response.body, symbolize_names: true)[:errors][0]
      expect(error[:status]).to eq("Cannot Find")
      expect(error[:message]).to eq("Either min/max is below 0, or you cannot pass name and price params together")
      expect(error[:code]).to eq(400)

      get "/api/v1/items/find_all?min_price=-5"

      expect(response).to have_http_status(400)
      error = JSON.parse(response.body, symbolize_names: true)[:errors][0]
      expect(error[:status]).to eq("Cannot Find")
      expect(error[:message]).to eq("Either min/max is below 0, or you cannot pass name and price params together")
      expect(error[:code]).to eq(400)
    end

    it "searches and finds ALL items with minimum and maximum price" do
      merchant_id = create(:merchant).id
      item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 1000, merchant_id: merchant_id)
      item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 10001, merchant_id: merchant_id)
      item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
      item_4 = Item.create!(name: "Mirage Wall", description: "To drink water", unit_price: 998, merchant_id: merchant_id)
      item_5 = Item.create!(name: "Art: Mired Pond", description: "To drink water", unit_price: 999, merchant_id: merchant_id)

      get "/api/v1/items/find_all?max_price=999&min_price=900"

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
    end

    it "returns happy path if min or max number is too big that nothing matches" do
      merchant_id = create(:merchant).id
      item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 12.5, merchant_id: merchant_id)
      item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 12.5, merchant_id: merchant_id)
      item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
      item_4 = Item.create!(name: "Mirage Wall", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
      item_5 = Item.create!(name: "Art: Mired Pond", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)

      get "/api/v1/items/find_all?min_price=999999999999"

      expect(response).to be_successful
      error = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)
      expect(error[:data]).to eq([])
    end
  end
end