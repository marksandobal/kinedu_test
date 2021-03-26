class User::FormObject
  include ActiveModel::Model

  attr_accessor :user, :first_name, :last_name, :email

  def create!
    ActiveRecord::Base.transaction do
      @user = User.create!(user_attributes)

      true
    end

  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    e.record.errors.messages.each do |attribute, message|
      errors.add(e.record.class.human_attribute_name(attribute).to_s, message.first)
    end

    false
  end

  def update!
    ActiveRecord::Base.transaction do
      user.update!(user_attributes)

      true
    end

  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    e.record.errors.messages.each do |attribute, message|
      errors.add(e.record.class.human_attribute_name(attribute).to_s, message.first)
    end

    false
  end

  private

  def user_attributes
    {
      first_name: first_name,
      last_name:  last_name,
      email:      email
    }.compact
  end
end