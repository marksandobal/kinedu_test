class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email

  attribute(:created_at) { object.created_at.iso8601 }
end