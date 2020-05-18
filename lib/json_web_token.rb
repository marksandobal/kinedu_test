class JsonWebToken
  def self.decode(token)
    body = JWT.decode(token, Rails.application.credentials.jwt_secret_token)[0]
    HashWithIndifferentAccess.new(body)
  rescue
    nil
  end

  def self.encode(payload)
    JWT.encode(payload, Rails.application.credentials.jwt_secret_token)
  end
end