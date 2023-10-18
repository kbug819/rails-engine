require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it {should have_many :items}
  end

  describe "Class methods" do
    describe "#find_one_merchant" do
      it "searches and finds one item based on a search of a fragment, case insensitive" do
        merchant_1 = Merchant.create!(name: "Billy's Store")
        merchant_2 = Merchant.create!(name: "Josephine's Market")
        merchant_3 = Merchant.create!(name: "Jackson's Dodge")
        merchant_4 = Merchant.create!(name: "Jackfer's Emporium")
  
        query = Merchant.find_one_merchant("JaCK")
        expect(query[0]).to eq(merchant_4)
  
        query_2 = Item.find_one_item("dOG")
        expect(query_2[0]).to eq(nil)
      end
    end

    describe "#find_all_merchants" do
      it "searches and finds one item based on a search of a fragment, case insensitive" do
        merchant_1 = Merchant.create!(name: "Billy's Store")
        merchant_2 = Merchant.create!(name: "Josephine's Market")
        merchant_3 = Merchant.create!(name: "Jackson's Dodge")
        merchant_4 = Merchant.create!(name: "Jackfer's Emporium")

        query = Merchant.find_all_merchants("JaCK")
        expect(query[0]).to eq(merchant_4)
        expect(query[1]).to eq(merchant_3)

        query_2 = Item.find_one_item("dOG")
        expect(query_2[0]).to eq(nil)
      end
    end
  end
end
