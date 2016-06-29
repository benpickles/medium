module Medium
  class ApiError < StandardError
    DEFAULT_MESSAGE = 'Unknown error'

    def initialize(data)
      super data.fetch('errors', [])
        .fetch(0, {})
        .fetch('message', DEFAULT_MESSAGE)
    end
  end

  BadRequestError = Class.new(ApiError)
  UnauthorizedError = Class.new(ApiError)
end
