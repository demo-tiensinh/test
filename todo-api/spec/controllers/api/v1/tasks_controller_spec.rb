require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
  # Initialize test data
  let!(:tasks) { create_list(:task, 10) }
  let(:task_id) { tasks.first.id }
  let(:user) { create(:user) }
  let(:auth_token) { Base64.strict_encode64({ user_id: user.id, exp: 1.day.from_now.to_i }.to_json) }

  # Helper method to set auth headers
  def set_auth_headers
    request.headers['Authorization'] = "Bearer #{auth_token}"
  end

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
      let!(:to_do_tasks) { create_list(:task, 3, status: 'to_do') }
      let!(:in_progress_tasks) { create_list(:task, 2, status: 'in_progress') }
      let!(:done_tasks) { create_list(:task, 1, status: 'done') }

      before { get :index, params: { status: 'to_do' } }

      it 'returns only to_do tasks' do
        json_response = JSON.parse(response.body)
        statuses = json_response.map { |task| task['status'] }
        expect(statuses).to all(eq('to_do'))
      end
    end

    context 'with sorting' do
      let!(:early_task) { create(:task, due_date: 1.day.from_now) }
      let!(:late_task) { create(:task, due_date: 10.days.from_now) }

      context 'by due date ascending' do
        before { get :index, params: { sort: 'due_date_asc' } }

        it 'returns tasks sorted by due date in ascending order' do
          json_response = JSON.parse(response.body)
          expect(Time.parse(json_response.first['due_date'])).to be <= Time.parse(json_response.last['due_date'])
        end
      end

      context 'by due date descending' do
        before { get :index, params: { sort: 'due_date_desc' } }

        it 'returns tasks sorted by due date in descending order' do
          json_response = JSON.parse(response.body)
          expect(Time.parse(json_response.first['due_date'])).to be >= Time.parse(json_response.last['due_date'])
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
        expect(json_response['id']).to eq(task_id)
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
          status: 'to_do'
        }
      }
    end

    context 'when the request is valid' do
      before do
        set_auth_headers
        post :create, params: valid_attributes
      end

      it 'creates a task' do
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq('Learn Rails')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before do
        set_auth_headers
        post :create, params: { task: { description: 'Invalid task' } }
      end

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'returns a validation failure message' do
        expect(JSON.parse(response.body)['message']).to match(/can't be blank/i)
      end
    end

    context 'when not authenticated' do
      before { post :create, params: valid_attributes }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns an authentication error message' do
        expect(JSON.parse(response.body)['message']).to match(/authentication token is missing/i)
      end
    end
  end

  # Test suite for PATCH /api/v1/tasks/:id
  describe 'PATCH #update' do
    let(:valid_attributes) do
      {
        task: {
          title: 'Updated Task',
          status: 'done'
        }
      }
    end

    context 'when the record exists' do
      before do
        set_auth_headers
        patch :update, params: { id: task_id }.merge(valid_attributes)
      end

      it 'updates the record' do
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq('Updated Task')
        expect(json_response['status']).to eq('done')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      before do
        set_auth_headers
        patch :update, params: { id: 999 }.merge(valid_attributes)
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(JSON.parse(response.body)['message']).to match(/not found/i)
      end
    end

    context 'when the request is invalid' do
      before do
        set_auth_headers
        patch :update, params: { id: task_id, task: { status: 'invalid_status' } }
      end

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'returns a validation failure message' do
        expect(JSON.parse(response.body)['message']).to match(/inclusion/i)
      end
    end

    context 'when not authenticated' do
      before { patch :update, params: { id: task_id }.merge(valid_attributes) }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns an authentication error message' do
        expect(JSON.parse(response.body)['message']).to match(/authentication token is missing/i)
      end
    end
  end

  # Test suite for DELETE /api/v1/tasks/:id
  describe 'DELETE #destroy' do
    context 'when authenticated' do
      before do
        set_auth_headers
        delete :destroy, params: { id: task_id }
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'removes the task from the database' do
        expect { Task.find(task_id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the record does not exist' do
      before do
        set_auth_headers
        delete :destroy, params: { id: 999 }
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(JSON.parse(response.body)['message']).to match(/not found/i)
      end
    end

    context 'when not authenticated' do
      before { delete :destroy, params: { id: task_id } }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns an authentication error message' do
        expect(JSON.parse(response.body)['message']).to match(/authentication token is missing/i)
      end
    end
  end
end
