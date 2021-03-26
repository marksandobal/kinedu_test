class Api::V1::BabySerializer < ActiveModel::Serializer
  attributes :id, :name, :father_name, :mother_name, :phone

  attribute(:age_in_months) do
    if object.birthday 
      calculate_birthday_in_month(object.birthday)
    end
  end

  def calculate_birthday_in_month(birthday)
    (Time.zone.now.year * 12 + Time.zone.now.month) - (birthday.year * 12 + birthday.month)
  end
end