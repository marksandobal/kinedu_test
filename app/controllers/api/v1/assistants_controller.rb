class Api::V1::AssistantsController < ApplicationController
  def index
    assistants = Assistant.all.order(:name)
    if params.key?('page')
      assistants = assistants.page(params[:page])
      render(
        json: assistants,
        each_serializer: Api::V1::AssistantSerializer,
        meta: pagination_meta(assistants),
        status: :ok
      )
    else
      render json: assistants, each_serializer: Api::V1::AssistantSerializer, status: :ok
    end
  end

  def show
    assistant = Assistant.find(params[:id])

    render(
      json: assistant,
      serializer: Api::V1::AssistantSerializer,
      status: :ok
    )

  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: [e.message] }, status: :not_found
  end

  def create
    assistant_form = Assistant::FormObject.new(assistant_params)
    if assistant_form.create!
      assistant = assistant_form.assistant
      render json: assistant, serializer: Api::V1::AssistantSerializer, status: :created
    else
      render json: { errors: user_form.errors.messages }, status: :bad_request
    end
  end

  def update
    assistant = Assistant.find(params[:id])
    assistant_form = Assistant::FormObject.new(
      assistant_params.merge!(assistant: assistant)
    )

    if assistant_form.update!
      assistant = assistant_form.assistant
      render json: assistant, serializer: Api::V1::AssistantSerializer, status: :ok
    else
      render json: { errors: user_form.errors.messages }, status: :bad_request
    end

  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: [e.message] }, status: :not_found
  end

  def destroy
    assistant = Assistant.find(params[:id])
    if assistant.destroy!
      render json: {}, status: :no_content
    else
      render json: { errors: assistant.errors }, status: :bad_request
    end

  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: [e.message] }, status: :not_found
  end

  private

  def assistant_params
    params
    .require(:assistant)
    .permit(
      :name,
      :group,
      :address,
      :phone
    )
  end
end