class JsonWebToken
  def self.decode(token)
    body = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
    HashWithIndifferentAccess.new(body)
  rescue
    nil
  end

  def self.encode(payload)
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end
end