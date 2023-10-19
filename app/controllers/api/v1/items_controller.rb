class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    @item = ItemFacade.new(params).find_item 
    if @item.class == Item
      render json: ItemSerializer.new(@item)
    else
      render json: ErrorItemSerializer.new(@item).serialized_json, status: 404
    end
  end


  def create
    new_item = Item.new(item_params)
    new_item.save
    if new_item.save
      render json: ItemSerializer.new(new_item), status: :created
    else
      render json: { errors: new_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if params["merchant_id"].present?
    merchant = MerchantFacade.new(params).find_merchant_for_update
      if merchant.class == Merchant
        render json: ItemSerializer.new(Item.update(params[:id], item_params)), status: :created
      else
        render json: ErrorMerchantSerializer.new(merchant).serialized_json, status: 404
      end
  else
    render json: ItemSerializer.new(Item.update(params[:id], item_params)), status: :created
  end
end

  def destroy
    if Item.delete(params[:id])
      head :no_content
    else
      head :not_found
    end
  end

private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

end