require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
  # Initialize test data
  let!(:tasks) { create_list(:task, 10) }
  let(:task_id) { tasks.first.id }

  # Test suite for GET /api/v1/tasks
  describe 'GET #index' do
    before { get :index }

    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'returns all tasks' do
      expect(JSON.parse(response.body).size).to eq(10)
    end

    context 'with status filter' do
      let!(:incomplete_tasks) { create_list(:task, 3, status: 'incomplete') }
      let!(:complete_tasks) { create_list(:task, 2, status: 'complete') }

      before { get :index, params: { status: 'incomplete' } }

      it 'returns only incomplete tasks' do
        json_response = JSON.parse(response.body)
        statuses = json_response.map { |task| task['status'] }
        expect(statuses).to all(eq('incomplete'))
      end
    end

    context 'with sorting' do
      let!(:early_task) { create(:task, due_date: 1.day.from_now, priority: 3) }
      let!(:late_task) { create(:task, due_date: 10.days.from_now, priority: 1) }

      context 'by due date' do
        before { get :index, params: { sortBy: 'dueDate', order: 'asc' } }

        it 'returns tasks sorted by due date in ascending order' do
          json_response = JSON.parse(response.body)
          expect(Time.parse(json_response.first['due_date'])).to be <= Time.parse(json_response.last['due_date'])
        end
      end

      context 'by priority' do
        before { get :index, params: { sortBy: 'priority', order: 'desc' } }

        it 'returns tasks sorted by priority in descending order' do
          json_response = JSON.parse(response.body)
          priorities = json_response.map { |task| task['priority'] }
          expect(priorities).to eq(priorities.sort.reverse)
        end
      end
    end
  end

  # Test suite for GET /api/v1/tasks/:id
  describe 'GET #show' do
    before { get :show, params: { id: task_id } }

    context 'when the record exists' do
      it 'returns a successful response' do
        expect(response).to be_successful
      end

      it 'returns the task' do
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(task_id.to_s)
      end
    end

    context 'when the record does not exist' do
      let(:task_id) { 999 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(JSON.parse(response.body)['message']).to match(/not found/i)
      end
    end
  end

  # Test suite for POST /api/v1/tasks
  describe 'POST #create' do
    let(:valid_attributes) do
      {
        task: {
          title: 'Learn Rails',
          description: 'Build a Rails API',
          due_date: 1.week.from_now,
          priority: 1
        }
      }
    end

    context 'when the request is valid' do
      before { post :create, params: valid_attributes }

      it 'creates a task' do
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq('Learn Rails')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post :create, params: { task: { description: 'Invalid task' } } }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'returns a validation failure message' do
        expect(JSON.parse(response.body)['message']).to match(/can't be blank/)
      end
    end
  end

  # Test suite for PATCH /api/v1/tasks/:id
  describe 'PATCH #update' do
    let(:valid_attributes) do
      {
        task: {
          title: 'Updated Task',
          status: 'complete'
        }
      }
    end

    context 'when the record exists' do
      before { patch :update, params: { id: task_id }.merge(valid_attributes) }

      it 'updates the record' do
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq('Updated Task')
        expect(json_response['status']).to eq('complete')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      before { patch :update, params: { id: 999 }.merge(valid_attributes) }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(JSON.parse(response.body)['message']).to match(/not found/i)
      end
    end

    context 'when the request is invalid' do
      before { patch :update, params: { id: task_id, task: { priority: 5 } } }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'returns a validation failure message' do
        expect(JSON.parse(response.body)['message']).to match(/inclusion/i)
      end
    end
  end

  # Test suite for DELETE /api/v1/tasks/:id
  describe 'DELETE #destroy' do
    before { delete :destroy, params: { id: task_id } }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the task from the database' do
      expect { Task.find(task_id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    context 'when the record does not exist' do
      before { delete :destroy, params: { id: 999 } }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(JSON.parse(response.body)['message']).to match(/not found/i)
      end
    end
  end
end

