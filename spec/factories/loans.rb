# frozen_string_literal: true

FactoryBot.define do
  factory :loan do
    association :user
    association :book
    loaned_on { Date.today }
    due_on { Date.today + 30.days }
    returned_on { nil }
  end
end
