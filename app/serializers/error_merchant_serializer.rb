class ErrorMerchantSerializer
  def initialize(error_object)
    @error_object = error_object
  end

  def serialized_json
    {
      errors: [
        {
          status: @error_object.status,
          message: @error_object.error_message,
          code: @error_object.code
        }
      ]
    }
  end

  def serialized_json_search
    if @error_object == "data"
    {
      data: {}
    }
    end
  end
end