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
end