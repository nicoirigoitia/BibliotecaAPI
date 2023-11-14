# frozen_string_literal: true

class Api::V1::LoanSerializer < ActiveModel::Serializer
  attributes :id, :loaned_on, :due_on, :returned_on, :book_id, :user_id

  belongs_to :book, serializer: Api::V1::BookSerializer
  belongs_to :user, serializer: Api::V1::UserSerializer
end

