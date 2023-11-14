# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  path '/api/v1/users' do
    get 'index all users' do
      tags 'Users'
      produces 'application/json'

      response '200', 'users index' do
        schema type: :array, items: { '$ref' => '#/components/schemas/user' }

        before do
          create_list(:user, 3)
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.length).to eq(3)
          expect(response.status).to eq(200)
        end
      end

      post 'Creates a user' do
        tags 'Users'
        consumes 'application/json'
        parameter name: :user, in: :body, schema: { '$ref' => '#/components/schemas/new_user' }

        response '201', 'user created' do
          let(:user) { { name: 'foo', email: 'bar' } }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['name']).to eq(user[:name])
            expect(data['email']).to eq(user[:email])
            expect(response.status).to eq(201)
          end
        end

        response '422', 'invalid request' do
          let(:user) { { name: 'foo' } }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response.status).to eq(422)
            expect(data['errors']).to eq('Validation failed: Email can\'t be blank')
          end
        end
      end
    end
  end

  path '/api/v1/users/{id}' do
    get 'Retrieves a user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'user found' do
        schema '$ref' => '#/components/schemas/user'

        let(:existent_user) { create(:user) }
        let(:id) { existent_user.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to eq(existent_user.id)
          expect(data['name']).to eq(existent_user.name)
          expect(data['email']).to eq(existent_user.email)
          expect(response.status).to eq(200)
        end
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.status).to eq(404)
          expect(data['errors']).to eq('User not found')
        end
      end
    end

    put 'Updates a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :update_attributes, in: :body, schema: { '$ref' => '#/components/schemas/update_user' }

      response '200', 'user updated' do
        let(:existent_user) { create(:user) }
        let(:id) { existent_user.id }
        let(:update_attributes) { { name: 'foo', email: 'bar' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq(update_attributes[:name])
          expect(data['email']).to eq(update_attributes[:email])
          expect(response.status).to eq(200)
        end
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        let(:update_attributes) { { name: 'foo', email: 'bar' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.status).to eq(404)
          expect(data['errors']).to eq('User not found')
        end
      end
    end
  end
end
