# frozen_string_literal: true

class Api::V1::ReturnLoans
  include Interactor

  def call
    context.loan_ids.each do |loan_id|
      begin
        loan = Loan.find(loan_id)
        loan.update!(returned_on: Date.today)
        loan.book.update!(available: true)
      rescue ActiveRecord::RecordNotFound
        context.fail!(error: "Loan with ID #{loan_id} not found")
        break
      rescue ActiveRecord::RecordInvalid => e
        context.fail!(error: e.message)
        break
      end
    end
  end
end





