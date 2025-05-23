require 'swagger_helper'

RSpec.describe 'Tasks API', type: :request do
  path '/api/v1/tasks' do
    get 'Retrieves all tasks' do
      tags 'Tasks'
      produces 'application/json'
      parameter name: :status, in: :query, type: :string, required: false, 
                description: 'Filter tasks by status', schema: { type: :string, enum: ['incomplete', 'complete'] }
      parameter name: :sortBy, in: :query, type: :string, required: false, 
                description: 'Field to sort by', schema: { type: :string, enum: ['dueDate', 'priority'] }
      parameter name: :order, in: :query, type: :string, required: false, 
                description: 'Sort order', schema: { type: :string, enum: ['asc', 'desc'] }
      parameter name: :page, in: :query, type: :integer, required: false, 
                description: 'Page number for pagination'
      parameter name: :per_page, in: :query, type: :integer, required: false, 
                description: 'Number of items per page'

      response '200', 'tasks found' do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/Task' }

        let(:status) { 'incomplete' }
        let(:sortBy) { 'dueDate' }
        let(:order) { 'asc' }
        run_test!
      end

      response '400', 'bad request' do
        schema '$ref' => '#/components/responses/BadRequest'
        let(:status) { 'invalid' }
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
            '$ref' => '#/components/schemas/NewTask'
          }
        },
        required: ['task']
      }

      response '201', 'task created' do
        schema '$ref' => '#/components/schemas/Task'
        let(:task) do
          {
            task: {
              title: 'Learn Swagger',
              description: 'Learn how to use Swagger for API documentation',
              due_date: 1.week.from_now,
              priority: 2
            }
          }
        end
        run_test!
      end

      response '400', 'invalid request' do
        schema '$ref' => '#/components/responses/BadRequest'
        let(:task) do
          {
            task: {
              description: 'Missing required fields'
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/tasks/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'Task ID'

    get 'Retrieves a task' do
      tags 'Tasks'
      produces 'application/json'

      response '200', 'task found' do
        schema '$ref' => '#/components/schemas/Task'
        let(:id) { create(:task).id }
        run_test!
      end

      response '404', 'task not found' do
        schema '$ref' => '#/components/responses/NotFound'
        let(:id) { 'invalid' }
        run_test!
      end
    end

    patch 'Updates a task' do
      tags 'Tasks'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          task: {
            '$ref' => '#/components/schemas/UpdateTask'
          }
        },
        required: ['task']
      }

      response '200', 'task updated' do
        schema '$ref' => '#/components/schemas/Task'
        let(:id) { create(:task).id }
        let(:task) do
          {
            task: {
              title: 'Updated Task Title',
              status: 'complete'
            }
          }
        end
        run_test!
      end

      response '400', 'invalid request' do
        schema '$ref' => '#/components/responses/BadRequest'
        let(:id) { create(:task).id }
        let(:task) do
          {
            task: {
              priority: 5 # Invalid priority
            }
          }
        end
        run_test!
      end

      response '404', 'task not found' do
        schema '$ref' => '#/components/responses/NotFound'
        let(:id) { 'invalid' }
        let(:task) do
          {
            task: {
              title: 'Updated Task Title'
            }
          }
        end
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
        schema '$ref' => '#/components/responses/NotFound'
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end

