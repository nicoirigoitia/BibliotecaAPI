# frozen_string_literal: true

class Api::V1::BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :author, :isbn, :available
end
