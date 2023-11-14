# frozen_string_literal: true

class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :book

  before_validation :set_due_on

  validates :user_id, :book_id, :loaned_on, :due_on, presence: true
  validate :valid_loan_dates
  validate :book_not_already_loaned, on: :create

  private

  def set_due_on
    self.due_on ||= loaned_on + 30.days if loaned_on.present?
  end

  def book_not_already_loaned
    book = Book.find_by(id: book_id)
    if book.nil?
      errors.add(:book_id, 'does not exist')
      return
    end

    unless book.available
      errors.add(:book_id, 'is already loaned out')
    end
  end


  def valid_loan_dates
    errors.add(:due_on, 'must be after the loaned date') if loaned_on.present? && due_on.present? && due_on <= loaned_on
    errors.add(:returned_on, "can't be before the loaned date") if loaned_on.present? && returned_on.present? && returned_on < loaned_on
  end
end
