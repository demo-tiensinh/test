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
        title: 'TODO Application API',
        version: 'v1',
        description: 'API for a responsive and user-friendly TODO application built with React.js and TypeScript.'
      },
      paths: {},
      servers: [
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'api.example.com/v1'
            }
          }
        }
      ],
      components: {
        schemas: {
          Task: {
            type: 'object',
            properties: {
              id: { type: 'string' },
              title: { type: 'string' },
              description: { type: 'string', nullable: true },
              due_date: { type: 'string', format: 'date-time' },
              priority: { type: 'integer', enum: [1, 2, 3] },
              status: { type: 'string', enum: ['incomplete', 'complete'] }
            },
            required: ['id', 'title', 'due_date', 'priority', 'status']
          },
          NewTask: {
            type: 'object',
            properties: {
              title: { type: 'string' },
              description: { type: 'string', nullable: true },
              due_date: { type: 'string', format: 'date-time' },
              priority: { type: 'integer', enum: [1, 2, 3] }
            },
            required: ['title', 'due_date', 'priority']
          },
          UpdateTask: {
            type: 'object',
            properties: {
              title: { type: 'string', nullable: true },
              description: { type: 'string', nullable: true },
              due_date: { type: 'string', format: 'date-time', nullable: true },
              priority: { type: 'integer', enum: [1, 2, 3], nullable: true },
              status: { type: 'string', enum: ['incomplete', 'complete'], nullable: true }
            }
          },
          Error: {
            type: 'object',
            properties: {
              code: { type: 'integer' },
              message: { type: 'string' }
            }
          }
        },
        responses: {
          BadRequest: {
            description: 'Bad request',
            content: {
              'application/json': {
                schema: {
                  '$ref': '#/components/schemas/Error'
                }
              }
            }
          },
          NotFound: {
            description: 'Resource not found',
            content: {
              'application/json': {
                schema: {
                  '$ref': '#/components/schemas/Error'
                }
              }
            }
          },
          InternalServerError: {
            description: 'Internal server error',
            content: {
              'application/json': {
                schema: {
                  '$ref': '#/components/schemas/Error'
                }
              }
            }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end

