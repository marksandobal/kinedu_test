require "#{Rails.root}/lib/json_web_token"

class Auth::CreateSession
  Result = ImmutableStruct.new(:session_created?, :jwt, :errors)

  def self.call(session_params)
    email = session_params[:email]
    @user = User.find_by(email: email)

    raise Kinedu::Exceptions::Authentication.new("#{email} not found") unless @user

    unless @user.password_digest && @user.authenticate(session_params[:password])
      raise Kinedu::Exceptions::Authentication.new(
        "password of #{email} not found"
        )
    end

    token = @user.to_token
    Result.new(session_created?: true, jwt: JsonWebToken.encode(token))
  end
end