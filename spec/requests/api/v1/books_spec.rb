# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :request do
  path '/api/v1/books' do
    get 'Retrieves all books' do
      tags 'Books'
      produces 'application/json'

      response '200', 'books index' do
        schema type: :array, items: { '$ref' => '#/components/schemas/book' }

        before do
          create_list(:book, 3)
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.length).to eq(3)
          expect(response.status).to eq(200)
        end
      end
    end

    post 'Creates a book' do
      tags 'Books'
      consumes 'application/json'
      parameter name: :book, in: :body, schema: { '$ref' => '#/components/schemas/new_book' }

      response '201', 'book created' do
        let(:book) { { title: 'foo', author: 'bar', isbn: '1234567890', available: true } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['title']).to eq(book[:title])
          expect(data['author']).to eq(book[:author])
          expect(data['isbn']).to eq(book[:isbn])
          expect(data['available']).to eq(book[:available])
          expect(response.status).to eq(201)
        end
      end

      response '422', 'invalid request' do
        let(:book) { { title: 'foo', author: 'bar', isbn: '1234567890' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.status).to eq(422)
          expect(data['errors']).to eq('Validation failed: Available is not included in the list')
        end
      end
    end
  end

  path '/api/v1/books/{id}' do
    get 'Retrieves a book' do
      tags 'Books'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'book found' do
        schema '$ref' => '#/components/schemas/book'

        let(:existing_book) { create(:book) }
        let(:id) { existing_book.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to eq(existing_book.id)
          expect(data['title']).to eq(existing_book.title)
          expect(data['author']).to eq(existing_book.author)
          expect(data['isbn']).to eq(existing_book.isbn)
          expect(data['available']).to eq(existing_book.available)
          expect(response.status).to eq(200)
        end
      end

      response '404', 'book not found' do
        let(:id) { 'invalid' }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.status).to eq(404)
          expect(data['errors']).to eq('Book not found')
        end
      end
    end

    put 'Updates a book' do
      tags 'Books'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :updated_attributes, in: :body, schema: { '$ref' => '#/components/schemas/update_book' }

      response '200', 'book updated' do
        let(:existing_book) { create(:book) }
        let(:id) { existing_book.id }
        let(:updated_attributes) { { title: 'foo', author: 'bar', isbn: '1234567890', available: true } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['title']).to eq(updated_attributes[:title])
          expect(data['author']).to eq(updated_attributes[:author])
          expect(data['isbn']).to eq(updated_attributes[:isbn])
          expect(data['available']).to eq(updated_attributes[:available])
          expect(response.status).to eq(200)
        end
      end

      response '422', 'invalid request' do
        let(:existing_book) { create(:book) }
        let(:id) { existing_book.id }
        let(:updated_attributes) { { title: '' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.status).to eq(422)
          expect(data['errors']).to eq('Validation failed: Title can\'t be blank, Title is too short (minimum is 1 character)')
        end
      end

      response '404', 'book not found' do
        let(:id) { 'invalid' }
        let(:updated_attributes) { { title: 'foo', author: 'bar', isbn: '1234567890', available: true } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.status).to eq(404)
          expect(data['errors']).to eq('Book not found')
        end
      end
    end

    delete 'Deletes a book' do
      tags 'Books'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string

      response '204', 'book deleted' do
        let(:book) { create(:book) }
        let(:id) { book.id }
        run_test! do |response|
          expect(response.status).to eq(204)
        end
      end

      response '404', 'book not found' do
        let(:id) { 'invalid' }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.status).to eq(404)
          expect(data['errors']).to eq('Book not found')
        end
      end
    end
  end
end
