# frozen_string_literal: true

class Api::V1::LoansController < Api::ApiController
  def create
    result = Api::V1::CreateLoans.call(loan_params: loan_params)
    if result.success?
      render json: result.loans.map { |loan| serialize(loan) }, status: :created
    else
      render json: { errors: result.error }, status: :unprocessable_entity
    end
  end

  def update
    result = Api::V1::ReturnLoans.call(loan_ids: update_loan_params[:loan_ids])
    if result.success?
      head :no_content
    else
      render json: { errors: result.error }, status: :unprocessable_entity
    end
  end

  private

  def loan_params
    params.require(:loan).permit(:user_id, :loaned_on, book_ids: [])
  end

  def update_loan_params
    params.require(:loan).permit(loan_ids: [])
  end
end

