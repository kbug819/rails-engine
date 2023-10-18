class ErrorItem
  def initialize
    @error_message = error_message
    @status = status
    @code = code
  end

  def item_not_found
    @error_message = "Item not found"
    @status = "Not Found"
    @code = 200
  end
end