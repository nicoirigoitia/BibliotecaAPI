# frozen_string_literal: true

class Api::V1::CreateLoans
  include Interactor

  def call
    errors = {}
    errors[:user_id] = ["can't be blank"] if context.loan_params[:user_id].blank?
    errors[:book_ids] = ["can't be blank"] if context.loan_params[:book_ids].blank?
    errors[:loaned_on] = ["can't be blank"] if context.loan_params[:loaned_on].blank?

    if errors.present?
      context.fail!(error: errors)
      return
    end

    context.loans = context.loan_params[:book_ids].map do |book_id|
      loan = Loan.create!(user_id: context.loan_params[:user_id], book_id: book_id, loaned_on: Date.today)
      loan.book.update!(available: false)
      LoanMailer.loan_created_email(loan.user, loan).deliver_later
      loan
    rescue ActiveRecord::RecordInvalid => e
      context.fail!(error: e.record&.errors)
      break
    end
  end
end

