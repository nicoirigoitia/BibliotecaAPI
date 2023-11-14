# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { 'sample book title' }
    author { 'sample book author' }
    isbn { |n| "ISBN#{n}" }
    available { true }
  end
end
