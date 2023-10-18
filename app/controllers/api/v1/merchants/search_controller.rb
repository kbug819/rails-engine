
class Api::V1::Merchants::SearchController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.find_all_merchants(params[:name]))
  end
  def show
    # if Item.find_one_item(params[:id])[0] != nil
      render json: MerchantSerializer.new(Merchant.find_one_merchant(params[:name])[0])
    # else 
      # render json: ErrorItemSerializer.new(ErrorItem.new.item_not_found)
    # end

  end
end