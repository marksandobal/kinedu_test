class Api::V1::ActivitiesController < ApplicationController
  def index
    activities = Activity.all
    if params.key?('page')
      activities = activities.page(params[:page])

      render(
        json: activities,
        each_serializer: Api::V1::ActivitySerializer,
        meta: pagination_meta(activities),
        status: :ok
      )
    else
      render json: activities, each_serializer: Api::V1::ActivitySerializer, status: :ok
    end

  end

  def show
    activity = Activity.find(params[:id])

    render(
      json: activity,
      serializer: Api::V1::ActivitySerializer,
      status: :ok
    )

  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: [e.message] }, status: :not_found
  end
end