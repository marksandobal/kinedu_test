require 'rails_helper'

RSpec.describe Assistant, type: :model do
  it { should have_many(:activity_logs) }
end