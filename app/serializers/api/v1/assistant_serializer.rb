class Api::V1::AssistantSerializer < ActiveModel::Serializer
  attributes :id, :name, :group, :address, :phone
end