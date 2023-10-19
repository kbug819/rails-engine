class Api::V1::Items::MerchantController < ApplicationController
  def index
    @item = ItemFacade.new(params).find_item_for_merchant
    if @item.class == Item
      render json: MerchantSerializer.new(@item.merchant)
    else
      render json: ErrorItemSerializer.new(@item).serialized_json, status: 404
    end
  end
end
