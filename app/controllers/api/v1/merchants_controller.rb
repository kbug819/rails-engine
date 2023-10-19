class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    @merchant = MerchantFacade.new(params).find_merchant
    if @merchant.class == Merchant
      render json: MerchantSerializer.new(@merchant)
    else
      render json: ErrorMerchantSerializer.new(@merchant).serialized_json, status: 404
    end
  end
end

