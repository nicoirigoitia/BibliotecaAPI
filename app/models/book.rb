# frozen_string_literal: true

class Book < ApplicationRecord
  validates :title, presence: true, length: { minimum: 1 }
  validates :author, presence: true
  validates :isbn, presence: true, uniqueness: true
  validates :available, inclusion: { in: [true, false] }

end
