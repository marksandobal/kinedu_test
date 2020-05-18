module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from Kinedu::Exceptions::Authentication do |e|
      render json: { errors: [e] }, status: :bad_request
    end

    rescue_from Kinedu::Exceptions::MissingToken do |e|
      render json: { errors: ["Token not found"] }, status: :bad_request
    end
  end
end