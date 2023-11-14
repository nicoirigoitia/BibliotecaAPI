# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::LoansController, type: :request do
  path '/api/v1/loans' do
    post 'Creates a loan' do
      tags 'Loans'
      consumes 'application/json'
      parameter name: :loans, in: :body, schema: { '$ref' => '#/components/schemas/new_loan' }
      produces 'application/json'

      response '201', 'loans created' do
        let(:user) { create :user }
        let(:books) { create_list :book, 3 }
        let(:loans) { { loan: { user_id: user.id, book_ids: books.map(&:id), loaned_on: Date.today.to_s } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.size).to eq(3)
          data.each do |loan_data|
            expect(loan_data['user_id']).to eq(user.id)
            expect(books.map(&:id)).to include(loan_data['book_id'])
            expect(loan_data['loaned_on']).to eq(Date.today.to_s)
          end
        end
      end

      response '422', 'invalid request' do
        let(:loans) { { loan: { user_id: nil, book_ids: [], loaned_on: nil } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.status).to eq(422)
          expect(data['errors']['user_id']).to include("can't be blank")
          expect(data['errors']['book_ids']).to include("can't be blank")
          expect(data['errors']['loaned_on']).to include("can't be blank")
        end
      end

    end
  end

  path '/api/v1/loans/return' do
    put 'Returns multiple loans' do
      tags 'Loans'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :loan_ids, in: :body, schema: {
        type: :array,
        items: { type: :integer }
      }

      response '204', 'loans returned' do
        let(:user) { create(:user) }

        before do
          @book1 = Book.create!(title: 'Libro 1', author: 'Autor 1', isbn: 'ISBN1', available: true)
          @book2 = Book.create!(title: 'Libro 2', author: 'Autor 2', isbn: 'ISBN2', available: true)

          Loan.where(book: [@book1, @book2]).delete_all

          @loan1 = Loan.create!(user: user, book: @book1, loaned_on: Date.today, due_on: Date.today + 30.days)
          @loan2 = Loan.create!(user: user, book: @book2, loaned_on: Date.today, due_on: Date.today + 30.days)
        end

        let(:loan_ids) { { loan: { loan_ids: [@loan1.id, @loan2.id] } } }

        run_test! do
          [@loan1, @loan2].each do |loan|
            expect(Loan.find(loan.id).returned_on).to eq(Date.today)
            expect(loan.book.reload.available).to be true
          end
        end
      end

      response '422', 'loan not found' do
        let(:loan_ids) { { loan: { loan_ids: ['invalid'] } } }

        run_test! do
          expect(response).to have_http_status(422)
        end
      end
    end
  end
end
