class Assistant::FormObject
  include ActiveModel::Model

  attr_accessor :assistant, :name, :group, :address, :phone

  def create!
    ActiveRecord::Base.transaction do
      @assistant = Assistant.create!(assistant_attributes)

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
      assistant.update!(assistant_attributes)

      true
    end

  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    e.record.errors.messages.each do |attribute, message|
      errors.add(e.record.class.human_attribute_name(attribute).to_s, message.first)
    end

    false
  end

  private

  def assistant_attributes
    {
      name:    name,
      group:   group,
      address: address,
      phone:   phone
    }
  end
end