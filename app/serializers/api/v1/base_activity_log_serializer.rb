class Api::V1::BaseActivityLogSerializer < ActiveModel::Serializer
  attributes :id

  attribute(:assistant) do
    if object.assistant
      {
        id: object.assistant.id,
        name: object.assistant.name
      }
    end
  end

  attribute(:baby) do
    if object.baby
      {
        id: object.baby.id,
        name: object.baby.name,
      }
    end
  end

  attribute(:activity) do
    if object.activity
      {
        id: object.activity.id,
        name: object.activity.name
      }
    end
  end

  attribute(:start_time) { object.start_time.iso8601 }

  attribute(:stop_time) { object.stop_time&.iso8601 }

  attribute(:duration) do
    if object.duration
      "#{object.duration} min"
    else
      "-"
    end
  end
end