# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Loan, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:book) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:book_id) }
    it { should validate_presence_of(:loaned_on) }
    it { should validate_presence_of(:due_on) }
  end

  describe 'valid_loan_dates' do
    let(:user) { create(:user) }
    let(:book) { create(:book) }

    it 'is valid when due_on is after loaned_on' do
      loan = Loan.new(user: user, book: book, loaned_on: Date.today, due_on: Date.today + 30.days)
      expect(loan).to be_valid
    end

    it 'is invalid when due_on is before or same as loaned_on' do
      loan = Loan.new(user: user, book: book, loaned_on: Date.today, due_on: Date.today)
      expect(loan).not_to be_valid
    end
  end

  describe 'book_not_already_loaned' do
    let(:user) { create(:user) }
    let(:book) { create(:book, available: true) }
    let(:other_user) { create(:user) }

    before do
      create(:loan, book: book, user: user, returned_on: nil)
      book.update!(available: false)
    end

    it 'does not allow a book to be loaned if it is already loaned out' do
      new_loan = Loan.new(book: book, user: other_user, loaned_on: Date.today)
      expect(new_loan).not_to be_valid
      expect(new_loan.errors[:book_id]).to include("is already loaned out")
    end
  end
end
