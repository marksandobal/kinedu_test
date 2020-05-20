class Api::V1::BabiesController < ApplicationController
  def index
    babies = Baby.all

    if params.key?('page')
      babies = babies.page(params[:page])

      render(
        json: babies,
        each_serializer: Api::V1::BabySerializer,
        root: :babies,
        meta: pagination_meata(babies),
        status: :ok
      )
    else
      render json: babies, each_serializer: Api::V1::BabySerializer, status: :ok
    end
  end

  def show
    baby = Baby.find(params[:id])

    render(
      json: baby,
      serializer: Api::V1::BabySerializer,
      status: :ok
    )

  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: [e.message] }, status: :not_found
  end
end