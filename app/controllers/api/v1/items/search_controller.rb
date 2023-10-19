class Api::V1::Items::SearchController < ApplicationController
  def index
    items = Item.find_all_items(params)
    if items == "error" 
      render json: ErrorItemSerializer.new(items).serialized_json_min_max, status: 400
    else
      render json: ItemSerializer.new(items)
    end
  end
  def show
    if Item.find_one_item(params[:name])[0] == nil
      render json: ErrorItemSerializer.new("data").serialized_json_search
    else 
      render json: ItemSerializer.new(Item.find_one_item(params[:name])[0])
    end

  end
end