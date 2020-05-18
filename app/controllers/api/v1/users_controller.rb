class Api::V1::UsersController < ApplicationController
  def index
    users = User.all

    if params.key?('page')
      users = users.page(params[:page])

      render(
        json: users,
        each_serializer: Api::V1::UserSerializer,
        root: users,
        meta: pagination_meta(users),
        status: :ok
      )
    else
      render json: users, each_serializer: Api::V1::UserSerializer, status: :ok
    end
  end

  def show
    user = User.find(params[:id])

    render json: user, each_serializer: Api::V1::UserSerializer, status: :ok

  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: [e.message] }, status: :not_found
  end

  def create
    user_form = User::FormObject.new(user_params)
    if user_form.create!
      user = user_form.user
      render json: user, serializer: Api::V1::UserSerializer, status: :created
    else
      render json: { errors: user_form.errors.messages }, status: :bad_request
    end
  end

  def update
    user = User.find(params[:id])
    user_form = User::FormObject.new(user_params.merge!(user: user))
    if user_form.update!
      @user = user_form.user
      render json: @user, serializer: Api::V1::UserSerializer, status: :ok
    else
      render json: { errors: user_form.errors.messages }, status: :bad_request
    end

  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: [e.message] }, status: :not_found
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy!
      render json: users, serializer: Api::V1::UserSerializer, status: :ok
    else
      render json: { errors: [user.errors] }, status: :bad_request
    end

  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: [e.message] }, status: :not_found
  end

  private

  def user_params
    params
    .require(:user)
    .permit(
      :first_name,
      :last_name,
      :email
    )
  end
end