# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build :user }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to allow_value('bar').for(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end
end
