require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships" do
    it {should belong_to :merchant}
  end

  describe "Class methods" do
    describe "#find_one_item" do
      it "searches and finds one item based on a search of a fragment, case insensitive" do
        merchant_id = create(:merchant).id
        item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 12.5, merchant_id: merchant_id)
        item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 12.5, merchant_id: merchant_id)
        item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)

        query = Item.find_one_item("mirrOR")
        expect(query[0]).to eq(item_2)

        query_2 = Item.find_one_item("dOG")
        expect(query_2[0]).to eq(nil)
      end
    end

    describe "#find_all_items" do
      it "searches and finds one item based on a search of a fragment, case insensitive" do
        merchant_id = create(:merchant).id
        item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 12.5, merchant_id: merchant_id)
        item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 12.5, merchant_id: merchant_id)
        item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
        item_4 = Item.create!(name: "Mirage Wall", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
        item_5 = Item.create!(name: "Art: Mired Pond", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)

        query = Item.find_all_items({"name"=>"miR"})
        expect(query[0]).to eq(item_5)
        expect(query[1]).to eq(item_4)
        expect(query[2]).to eq(item_2)

        query_2 = Item.find_all_items({"name"=>"doG"})
        expect(query_2[0]).to eq(nil)
      end
    end

    describe "#find_all_items_by_min_price_unit" do
      it "returns all items that have at least a price of 999" do
        merchant_id = create(:merchant).id

        item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 1000, merchant_id: merchant_id)
        item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 10001, merchant_id: merchant_id)
        item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
        item_4 = Item.create!(name: "Mirage Wall", description: "To drink water", unit_price: 998, merchant_id: merchant_id)
        item_5 = Item.create!(name: "Art: Mired Pond", description: "To drink water", unit_price: 999, merchant_id: merchant_id)

        query = Item.find_all_items({"min_price"=>999})
        expect(query[0]).to eq(item_2)
        expect(query[1]).to eq(item_1)
        expect(query[2]).to eq(item_5)
      end
    end

    describe "#find_all_items_by_min_price_unit" do
    it "returns all items that have at least a price of 999" do
      merchant_id = create(:merchant).id

      item_1 = Item.create!(name: "Mouse Pad", description: "A pad to user your mouse", unit_price: 1000, merchant_id: merchant_id)
      item_2 = Item.create!(name: "Mirror", description: "To see yourself", unit_price: 10001, merchant_id: merchant_id)
      item_3 = Item.create!(name: "Water Bottle", description: "To drink water", unit_price: 12.5, merchant_id: merchant_id)
      item_4 = Item.create!(name: "Mirage Wall", description: "To drink water", unit_price: 998, merchant_id: merchant_id)
      item_5 = Item.create!(name: "Art: Mired Pond", description: "To drink water", unit_price: 999, merchant_id: merchant_id)

      query = Item.find_all_items({"jhfjijgf"=>999})
      expect(query).to eq([])
    end
  end
  end
end
