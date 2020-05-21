require 'rails_helper'

RSpec.describe ActivityLog, type: :model do
  it { should belong_to(:assistant) }
  it { should belong_to(:baby) }
  it { should belong_to(:activity) }
end