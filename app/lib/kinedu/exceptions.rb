module Kinedu::Exceptions
  class MissingToken < StandardError; end
  class EndTimeError < StandardError; end
  class Authentication < StandardError 
    def initialize(msg)
      super(msg)
    end;
  end
end