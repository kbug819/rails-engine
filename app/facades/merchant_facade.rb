class MerchantFacade
  def initialize(params)
    @params = params
  end

  def find_merchant
    if Merchant.pluck(:id).include?(@params[:id].to_i)
      merchant = Merchant.find(@params[:id])
    else
      result = ErrorMerchant.new("No merchants found", 'Not Found', 404)
    end
  end

  def find_merchant_for_items
    if Merchant.pluck(:id).include?(@params[:merchant_id].to_i)
      merchant = Merchant.find(@params[:merchant_id])
    else
      result = ErrorMerchant.new("No merchants found", 'Not Found', 404)
    end
  end

  def find_merchant_for_update
    if Merchant.pluck(:id).include?(@params.fetch(:merchant_id).to_i)
      merchant = Merchant.find(@params.fetch(:merchant_id))
    else
      result = ErrorMerchant.new("No merchants found", 'Not Found', 404)
    end
  end
end