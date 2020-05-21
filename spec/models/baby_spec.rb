require 'rails_helper'

RSpec.describe Baby, type: :model do
  it { should have_many(:activity_logs) }
end