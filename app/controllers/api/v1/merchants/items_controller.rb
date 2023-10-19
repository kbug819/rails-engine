
class Api::V1::Merchants::ItemsController < ApplicationController

  def index
    @merchant = MerchantFacade.new(params).find_merchant_for_items
    if @merchant.class == Merchant
      render json: ItemSerializer.new(@merchant.items)
    else
      render json: ErrorMerchantSerializer.new(@merchant).serialized_json, status: 404
    end
  end
end

