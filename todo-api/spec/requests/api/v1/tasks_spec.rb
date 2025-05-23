require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
  # Initialize test data
  let!(:tasks) { create_list(:task, 10) }
  let(:task_id) { tasks.first.id }

  # Test suite for GET /api/v1/tasks
  describe 'GET /api/v1/tasks' do
    before { get '/api/v1/tasks' }

    it 'returns tasks' do
      expect(JSON.parse(response.body)).not_to be_empty
      expect(JSON.parse(response.body).size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    context 'with filters' do
      before do
        create_list(:task, 3, status: 'incomplete')
        create_list(:task, 2, status: 'complete')
        get '/api/v1/tasks', params: { status: 'complete' }
      end

      it 'returns filtered tasks' do
        json_response = JSON.parse(response.body)
        expect(json_response).not_to be_empty
        expect(json_response.all? { |task| task['status'] == 'complete' }).to be true
      end
    end

    context 'with sorting' do
      before do
        create(:task, due_date: 1.day.from_now)
        create(:task, due_date: 10.days.from_now)
        get '/api/v1/tasks', params: { sortBy: 'dueDate', order: 'asc' }
      end

      it 'returns sorted tasks' do
        json_response = JSON.parse(response.body)
        due_dates = json_response.map { |task| Time.parse(task['due_date']) }
        expect(due_dates).to eq(due_dates.sort)
      end
    end
  end

  # Test suite for GET /api/v1/tasks/:id
  describe 'GET /api/v1/tasks/:id' do
    before { get "/api/v1/tasks/#{task_id}" }

    context 'when the record exists' do
      it 'returns the task' do
        json_response = JSON.parse(response.body)
        expect(json_response).not_to be_empty
        expect(json_response['id']).to eq(task_id.to_s)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:task_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/not found/i)
      end
    end
  end

  # Test suite for POST /api/v1/tasks
  describe 'POST /api/v1/tasks' do
    let(:valid_attributes) do
      {
        task: {
          title: 'Learn Elm',
          description: 'Learn functional programming with Elm',
          due_date: 1.week.from_now,
          priority: 2
        }
      }
    end

    context 'when the request is valid' do
      before { post '/api/v1/tasks', params: valid_attributes }

      it 'creates a task' do
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq('Learn Elm')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/tasks', params: { task: { description: 'Foobar' } } }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/can't be blank/i)
      end
    end
  end

  # Test suite for PATCH /api/v1/tasks/:id
  describe 'PATCH /api/v1/tasks/:id' do
    let(:valid_attributes) do
      {
        task: {
          title: 'Updated Task Title',
          status: 'complete'
        }
      }
    end

    context 'when the record exists' do
      before { patch "/api/v1/tasks/#{task_id}", params: valid_attributes }

      it 'updates the record' do
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq('Updated Task Title')
        expect(json_response['status']).to eq('complete')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is invalid' do
      before { patch "/api/v1/tasks/#{task_id}", params: { task: { priority: 5 } } }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/inclusion/i)
      end
    end
  end

  # Test suite for DELETE /api/v1/tasks/:id
  describe 'DELETE /api/v1/tasks/:id' do
    before { delete "/api/v1/tasks/#{task_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end

