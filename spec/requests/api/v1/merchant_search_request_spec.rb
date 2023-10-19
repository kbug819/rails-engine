require 'rails_helper'

describe "Merchant search API" do
  it "searches and finds one merchant based on a search of a fragment, case insensitive" do
    merchant_1 = Merchant.create!(name: "Billy's Store")
    merchant_2 = Merchant.create!(name: "Josephine's Market")
    merchant_3 = Merchant.create!(name: "Jackson's Dodge")
    merchant_4 = Merchant.create!(name: "Jackfer's Emporium")

    get "/api/v1/merchants/find?name=JAck"
    # get merchant_search(name: 'JAck')

    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a (String)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to eq(merchant_4.name)
  end

  xit "it returns proper error code if merchant is not found" do
    merchant_1 = Merchant.create!(name: "Billy's Store")
    merchant_2 = Merchant.create!(name: "Josephine's Market")
    merchant_3 = Merchant.create!(name: "Jackson's Dodge")
    merchant_4 = Merchant.create!(name: "Jackfer's Emporium")

    get "/api/v1/merchants/find?name=JAck"

    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a (String)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to eq(merchant_4.name)
  end

  it "it returns an array of all merchants with specific name" do
    merchant_1 = Merchant.create!(name: "Billy's Store")
    merchant_2 = Merchant.create!(name: "Josephine's Market")
    merchant_3 = Merchant.create!(name: "Jackson's Dodge")
    merchant_4 = Merchant.create!(name: "Jackfer's Emporium")

    get "/api/v1/merchants/find_all?name=JAck"

    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchants[0]).to have_key(:id)
    expect(merchants[0][:id].to_i).to eq(merchant_4.id)
    expect(merchants[0][:attributes]).to have_key(:name)
    expect(merchants[0][:attributes][:name]).to eq(merchant_4.name)

    expect(merchants[1]).to have_key(:id)
    expect(merchants[1][:id].to_i).to eq(merchant_3.id)
    expect(merchants[1][:attributes]).to have_key(:name)
    expect(merchants[1][:attributes][:name]).to eq(merchant_3.name)
  end
end