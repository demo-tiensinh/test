require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :controller do
  # Test suite for POST /api/v1/auth/login
  describe 'POST #login' do
    let!(:user) { create(:user, username: 'testuser', password: 'password123') }
    
    context 'when credentials are valid' do
      before do
        post :login, params: { login: { username: 'testuser', password: 'password123' } }
      end

      it 'returns a successful response' do
        expect(response).to be_successful
      end

      it 'returns an access token and refresh token' do
        json_response = JSON.parse(response.body)
        expect(json_response['access_token']).to be_present
        expect(json_response['refresh_token']).to be_present
      end
    end

    context 'when credentials are invalid' do
      before do
        post :login, params: { login: { username: 'testuser', password: 'wrong_password' } }
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns an error message' do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to match(/invalid username or password/i)
      end
    end

    context 'when user does not exist' do
      before do
        post :login, params: { login: { username: 'nonexistent', password: 'password123' } }
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns an error message' do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to match(/invalid username or password/i)
      end
    end
  end
end

