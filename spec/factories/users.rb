# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { "MyString" }
    sequence(:email) { |n| "user#{n}@example.com" }
  end
end
