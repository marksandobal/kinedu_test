module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from Kinedu::Exceptions::Authentication do |e|
      render json: { errors: [e] }, status: :bad_request
    end

    rescue_from Kinedu::Exceptions::MissingToken do |e|
      render json: { errors: I18n.t('controller.application_controller.missing_token') }, status: :bad_request
    end

    rescue_from Kinedu::Exceptions::EndTimeError do |e|
      render json: {
        errors: [ I18n.t('controller.application_controller.end_time_error')]
        },
        status: :bad_request
    end
  end
end