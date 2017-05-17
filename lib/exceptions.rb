module Exceptions
# Namespace for classes that handle error
  class ValidationError < StandardError
    # Class for validation failure

    # Method to initialize error
    #
    # @param msg [String] error message
    # @param title [String] error title
    # @return [Exceptions::ValidationError]
    def initialize(msg=nil, title=nil)
      @title         = title || 'ValidationError'
      @error_code    = 100
      super(msg)
    end
  end
end
