class Api::V1::AssistantsController < ApplicationController
  def index
    assistants = Assistant.all
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
end