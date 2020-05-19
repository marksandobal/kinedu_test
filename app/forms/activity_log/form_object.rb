class ActivityLog::FormObject
  include ActiveModel::Model

  attr_accessor :activity_log, :baby_id, :activity_id, :assistant_id, :start_time, :stop_time, :comments

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

  def update!
    ActiveRecord::Base.transaction do
      validate_stop_time
      activity_log.update!(activity_log_update_attributes)

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

  def activity_log_update_attributes
    {
      stop_time: stop_time,
      comments: comments,
      duration: calculate_duration_in_minutes
    }
  end

  def validate_stop_time
    valid = activity_log.start_time > stop_time.to_datetime
    raise Kinedu::Exceptions::EndTimeError if valid
  end

  def calculate_duration_in_minutes
    start_time = activity_log.start_time
    stp_time   = stop_time.to_datetime
    start_date = format_date_time(start_time)
    end_date   = format_date_time(stp_time)

    result  = (end_date - start_date)
    minutes = (result * 24 * 60).to_i

    minutes
  end

  def format_date_time(date_time)
    DateTime.new(
      date_time.year,
      date_time.month,
      date_time.day,
      date_time.hour,
      date_time.min,
      date_time.sec
    )
  end
end