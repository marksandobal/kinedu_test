class ActivityLog::FormObject
  include ActiveModel::Model

  attr_accessor :activity_log, :baby_id, :activity_id, :assistant_id, :start_time

  def create!
    ActiveRecord::Base.transaction do
      @activity_log = ActivityLog.create!(activity_log_attributes)

      true
    end

  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    e.record.errors.messages.each do |attribute, message|
      errors.add(e.record.class.human_attribute_name(attribute).to_s, message.first)
    end

    false
  end

  private

  def activity_log_attributes
    {
      activity_id:  activity_id,
      baby_id:      baby_id,
      assistant_id: assistant_id,
      start_time:   start_time
    }
  end
end