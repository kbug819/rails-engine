class ErrorItemSerializer
  def initialize(error)
    @error = error
  end

  def serialized_json
    {
      errors: [
        {
          status: @error.status,
          message: @error.error_message,
          code: @error.code
        }
      ]
    }
  end

  def serialized_json_search
    if @error == "data"
    {
      data: {}
    }
    end
  end

  def serialized_json_min_max
    if @error == "error"
      {
        errors: [
          {
            status: "Cannot Find",
            message: "Either min/max is below 0, or you cannot pass name and price params together",
            code: 400
          }
        ]
      }
    end
  end
end