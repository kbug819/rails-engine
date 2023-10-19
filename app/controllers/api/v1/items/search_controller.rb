class Api::V1::Items::SearchController < ApplicationController
  def index
    items = Item.find_all_items(params)
    # if items = []
    #   render json: ItemSerializer.new(items), status: 400
    # else
      render json: ItemSerializer.new(items)
    # end
  end
  def show
    if Item.find_one_item(params[:name])[0] != nil
      render json: ItemSerializer.new(Item.find_one_item(params[:name])[0])
    else 
      render json: ErrorItemSerializer.new(ErrorItem.new("No items found", 'Not Found', 404)).serialized_json
    end

  end
end