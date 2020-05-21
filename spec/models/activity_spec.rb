require 'rails_helper'

RSpec.describe Activity, type: :model do
  it { should have_many(:activity_logs) }
end