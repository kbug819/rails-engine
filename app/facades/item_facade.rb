class ItemFacade
  def initialize(params)
    @params = params
  end

  def find_item
    if Item.pluck(:id).include?(@params[:id].to_i)
      item = Item.find(@params[:id])
    else
      result = ErrorItem.new("No merchants found", 'Not Found', 404)
    end
  end

  def find_item_for_merchant
    if Item.pluck(:id).include?(@params[:item_id].to_i)
      item = Item.find(@params[:item_id])
    else
      result = ErrorItem.new("No items found", 'Not Found', 404)
    end
  end

end