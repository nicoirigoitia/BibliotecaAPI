# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      components: {
        schemas: {
          error_object: {
            type: :object,
            properties: {
              code: { type: :integer },
              message: { type: :string }
            }
          },
          book: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              author: { type: :string },
              isbn: { type: :string },
              available: { type: :boolean }
            },
            required: %w[id title author isbn available]
          },
          new_book: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              author: { type: :string },
              isbn: { type: :string },
              available: { type: :boolean }
            },
            required: %w[title author isbn available]
          },
          update_book: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              author: { type: :string },
              isbn: { type: :string },
              available: { type: :boolean }
            }
          },
          user: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              email: { type: :string }
            },
            required: %w[id name email]
          },
          new_user: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              email: { type: :string }
            },
            required: %w[name email]
          },
          update_user: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              email: { type: :string }
            }
          },
          loan: {
            type: :object,
            properties: {
              id: { type: :integer },
              loaned_on: { type: :string },
              due_on: { type: :string },
              returned_on: { type: :string, nullable: true },
              book: { '$ref' => '#/components/schemas/book' },
              user: { '$ref' => '#/components/schemas/user' }
            },
            required: %w[id book user loaned_on due_on]
          },
          new_loan: {
            type: :object,
            properties: {
              user_id: { type: :integer },
              book_ids: {
                type: :array,
                items: { type: :integer }
              },
              loaned_on: { type: :string, format: 'date' }
            },
            required: %w[user_id book_ids loaned_on]
          },
          update_loan: {
            type: :object,
            properties: {
              id: { type: :integer },
              loaned_on: { type: :string },
              due_on: { type: :string },
              returned_on: { type: :string, nullable: true },
              book_ids: {
                type: :array,
                items: { type: :integer }
              },
              user_id: { type: :integer }
            }
          }
        }
      },
      servers: [
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'www.example.com'
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
