# frozen_string_literal: true

class Api::V1::BooksController < Api::ApiController
  before_action :set_book, only: %i[show update destroy]

  def index
    @books = Book.all
    render json: serialize(@books)
  end

  def show
    render json: serialize(@book)
  end

  def create
    @book = Book.create!(book_params)
    render json: serialize(@book), status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e }, status: :unprocessable_entity
  end

  def update
    @book.update!(book_params)
    render json: serialize(@book)
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e }, status: :unprocessable_entity
  end

  def destroy
    @book.destroy!
    head :no_content
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { errors: e.record&.errors }, status: :conflict
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :isbn, :available)
  end

  def set_book
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Book not found' }, status: :not_found
  end
end
