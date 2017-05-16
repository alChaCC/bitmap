module Exceptions
  class ValidationError < StandardError
    def initialize(msg=nil, title=nil)
      @title         = title || 'ValidationError'
      @error_code    = 100
      super(msg)
    end
  end
end
