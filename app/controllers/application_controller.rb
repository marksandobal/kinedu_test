class ApplicationController < ActionController::API
  include Authentication
  include ExceptionHandler
  include Pagination
end
