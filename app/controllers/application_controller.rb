class ApplicationController < ActionController::API
  include Authentication
  include ExceptionHandler
end
