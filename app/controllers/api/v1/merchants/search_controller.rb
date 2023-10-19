
class Api::V1::Merchants::SearchController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.find_all_merchants(params[:name]))
  end
  
  def show
    if Merchant.find_one_merchant(params[:name])[0] == nil
      render json: ErrorMerchantSerializer.new("data").serialized_json_search
    else 
      render json: MerchantSerializer.new(Merchant.find_one_merchant(params[:name])[0])
    end

  end
end
