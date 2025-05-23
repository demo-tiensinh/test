require 'swagger_helper'

RSpec.describe 'API V1', type: :request do
  path '/api/v1/tasks' do
    get 'Lists all tasks' do
      tags 'Tasks'
      produces 'application/json'
      parameter name: :status, in: :query, type: :string, required: false, 
                description: 'Filter tasks by status', 
                schema: { type: :string, enum: ['to_do', 'in_progress', 'done'] }
      parameter name: :sort, in: :query, type: :string, required: false, 
                description: 'Sort tasks by due date', 
                schema: { type: :string, enum: ['due_date_asc', 'due_date_desc'] }

      response '200', 'tasks found' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   title: { type: :string },
                   description: { type: :string, nullable: true },
                   due_date: { type: :string, format: 'date-time' },
                   status: { type: :string, enum: ['to_do', 'in_progress', 'done'] },
                   created_at: { type: :string, format: 'date-time' },
                   updated_at: { type: :string, format: 'date-time' }
                 },
                 required: ['id', 'title', 'due_date', 'status', 'created_at', 'updated_at']
               }

        let(:status) { 'to_do' }
        run_test!
      end
    end

    post 'Creates a task' do
      tags 'Tasks'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          task: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string, nullable: true },
              due_date: { type: :string, format: 'date-time' },
              status: { type: :string, enum: ['to_do', 'in_progress', 'done'] }
            },
            required: ['title', 'due_date', 'status']
          }
        }
      }

      response '201', 'task created' do
        let(:task) { { task: { title: 'Test Task', due_date: 1.day.from_now, status: 'to_do' } } }
        run_test!
      end

      response '400', 'invalid request' do
        let(:task) { { task: { title: nil } } }
        run_test!
      end
    end
  end

  path '/api/v1/tasks/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieves a task' do
      tags 'Tasks'
      produces 'application/json'

      response '200', 'task found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 title: { type: :string },
                 description: { type: :string, nullable: true },
                 due_date: { type: :string, format: 'date-time' },
                 status: { type: :string, enum: ['to_do', 'in_progress', 'done'] },
                 created_at: { type: :string, format: 'date-time' },
                 updated_at: { type: :string, format: 'date-time' }
               },
               required: ['id', 'title', 'due_date', 'status', 'created_at', 'updated_at']

        let(:id) { create(:task).id }
        run_test!
      end

      response '404', 'task not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a task' do
      tags 'Tasks'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          task: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string, nullable: true },
              due_date: { type: :string, format: 'date-time' },
              status: { type: :string, enum: ['to_do', 'in_progress', 'done'] }
            }
          }
        }
      }

      response '200', 'task updated' do
        let(:id) { create(:task).id }
        let(:task) { { task: { title: 'Updated Task', status: 'done' } } }
        run_test!
      end

      response '400', 'invalid request' do
        let(:id) { create(:task).id }
        let(:task) { { task: { status: 'invalid' } } }
        run_test!
      end

      response '404', 'task not found' do
        let(:id) { 'invalid' }
        let(:task) { { task: { title: 'Updated Task' } } }
        run_test!
      end
    end

    delete 'Deletes a task' do
      tags 'Tasks'
      produces 'application/json'

      response '204', 'task deleted' do
        let(:id) { create(:task).id }
        run_test!
      end

      response '404', 'task not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/auth/login' do
    post 'Authenticates user and returns a token' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :login, in: :body, schema: {
        type: :object,
        properties: {
          login: {
            type: :object,
            properties: {
              username: { type: :string },
              password: { type: :string }
            },
            required: ['username', 'password']
          }
        }
      }

      response '200', 'user authenticated' do
        let(:user) { create(:user, username: 'testuser', password: 'password123') }
        let(:login) { { login: { username: 'testuser', password: 'password123' } } }
        run_test!
      end

      response '401', 'authentication failed' do
        let(:login) { { login: { username: 'testuser', password: 'wrong_password' } } }
        run_test!
      end
    end
  end
end

