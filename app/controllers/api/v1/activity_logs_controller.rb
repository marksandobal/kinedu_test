class Api::V1::ActivityLogsController < ApplicationController
  def index
    activity_logs = ActivityLog.all.order(start_time: :desc)
    activity_logs = Filter::FilterMethod.new(
      array_list: activity_logs,
      filters: params
    ).filtering

    if params.key?('page')
      activity_logs = activity_logs.page(params[:page])
      render(
        json: activity_logs,
        each_serializer: Api::V1::BaseActivityLogSerializer,
        meta: pagination_meta(activity_logs),
        status: :ok
      )
    else
      render json: activity_logs, each_serializer: Api::V1::BaseActivityLogSerializer, status: :ok
    end
  end

  def baby_activity_logs
    baby = Baby.find(params[:id])
    activity_logs = baby.activity_logs
    if params.key?('page')
      activity_logs = activity_logs.page(params[:page])
      render(
        json: activity_logs,
        each_serializer: Api::V1::ActivityLogSerializer,
        root: :activity_logs,
        meta: pagination_meta(activity_logs),
        status: :ok
      )
    else
      render json: activity_logs, each_serializer: Api::V1::ActivityLogSerializer, status: :ok
    end

  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: [e.message] }, status: :not_found
  end

  def create
    activity_log_form = ActivityLog::FormObject.new(activity_log_params)

    if activity_log_form.create!
      activity_log = activity_log_form.activity_log
      render json: activity_log, serializer: Api::V1::ActivityLogSerializer, status: :ok
    else
      render json: { errors: user_form.errors.messages }, status: :bad_request
    end
  end

  def update
    activity_log = ActivityLog.find(params[:id])
    activity_log_form = ActivityLog::FormObject.new(
      activity_log_update_params.merge!(
        activity_log: activity_log
      )
    )

    if activity_log_form.update!
      render json: activity_log, serializer: Api::V1::ActivityLogSerializer, status: :ok
    else
      render json: { errors: user_form.errors.messages }, status: :bad_request
    end

  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: [e.message] }, status: :not_found
  end

  private

  def activity_log_params
    params
    .require(:activity_log)
    .permit(
      :activity_id,
      :assistant_id,
      :baby_id,
      :start_time
    )
  end

  def activity_log_update_params
    params
    .require(:activity_log)
    .permit(
      :stop_time,
      :comments
    )
  end
end