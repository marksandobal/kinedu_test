require "#{Rails.root}/lib/json_web_token"

module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user
  end

  private

  def authenticate_user
    decoded_jwt   = JsonWebToken.decode(jwt)
    @user_id      = decoded_jwt['id']
    @current_user = User.find(@user_id)
  end

  def jwt
    unless request.headers.include?(:Authorization)
      raise Kinedu::Exceptions::MissingToken
    end

    request.headers.fetch(:Authorization)
  end
end
