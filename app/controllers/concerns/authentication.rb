require "#{Rails.root}/lib/json_web_token"

module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user
  end

  private

  def authenticate_user
    debugger
    decoded_jwt = JsonWebToken.decode(jwt)
    @session_token = decoded_jwt[:token]
    @current_user = Token.find_by!(content: @session_token).user
  end

  def jwt
    request.headers.fetch(:Authorization)
  end
end
