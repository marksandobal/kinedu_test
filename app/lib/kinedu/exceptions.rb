module Kinedu::Exceptions
  class Authentication < StandardError 
    def initialize(msg)
      super(msg)
    end;
  end
end