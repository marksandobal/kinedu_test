class Api::V1::ActivityLogSerializer < ActiveModel::Serializer
  attributes :id, :baby_id

  attribute(:start_time) { object.start_time.iso8601 }

  attribute(:stop_time) { object.stop_time&.iso8601 }

  attribute(:assistant) do
    if object.assistant
      {
        id: object.assistant.id,
        assistant: object.assistant.name
      }
    end
  end
end