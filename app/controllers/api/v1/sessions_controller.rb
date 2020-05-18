class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: [:create]

  def create
    result = Auth::CreateSession.call(session_params)

    render json: { session: { token: result.jwt } }, status: :created
  end

  def destroy
    result = Session::DestroySession.call(@session_token)

    render json: {}
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
