require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe 'GET #index' do
    let!(:user) { create(:user) }

    let(:token) { user.to_token }

    let(:headers) { authenticated_headers(token) }

    it 'responds with http status ok' do
      get '/api/users', params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it "responds with object's array" do
      get '/api/users', params: {}, headers: headers
      expect(response.body).to have_json_size(1).at_path('users')
    end
  end

  describe 'GET #show' do
    let!(:user) { create(:user) }

    let(:token) { user.to_token }

    let(:headers) { authenticated_headers(token) }

    it 'responds with http status ok' do
      get "/api/users/#{user.id}", params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'retur user object' do
      get "/api/users/#{user.id}", params: {}, headers: headers
      expect(response.body).to have_json_path('user')
    end

    it 'return error' do
      id = Faker::Number.number(digits: 3)
      get "/api/users/#{id}", params: {}, headers: headers
      expect(response.body).to have_json_path('errors')
    end

    it 'return error' do
      id = Faker::Number.number(digits: 3)
      get "/api/users/#{id}", params: {}, headers: headers
      result = JSON.parse(response.body)
      message_error = ["Couldn't find User with 'id'=#{id}"]
      expect(result['errors']).to eq(message_error)
    end
  end

  describe 'POST #create' do
    let!(:user) { create(:user) }

    let(:token) { user.to_token }

    let(:headers) { authenticated_headers(token) }

    let(:password) { Faker::Internet.password }

    context "with valid data" do
      let(:params) do
        {
          user: {
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            email: Faker::Internet.email
          }
        }
      end
  
      it 'responds with http status created' do
        post '/api/users', params: params, headers: headers
        expect(response).to have_http_status(:created)
      end
  
      it 'responds with yuser object' do
        post '/api/users', params: params, headers: headers
        expect(response.body).to have_json_path('user')
      end
    end

    context "with invalid data" do
      let(:params) do
        {
          user: {
            first_name: '',
            last_name: '',
            email: ''
          }
        }
      end

      it 'responds with http status created' do
        post '/api/users', params: params, headers: headers
        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with http status created' do
        post '/api/users', params: params, headers: headers
        expect(response.body).to have_json_path('errors')
      end

      it 'responds with http status created' do
        post '/api/users', params: params, headers: headers
        result = JSON.parse(response.body)
        error_messasges = { 
          "First name"=>["can't be blank"],
          "Last name"=>["can't be blank"],
          "Email"=>["can't be blank"]
        }
        expect(result['errors']).to eq(error_messasges)
      end
    end
  end

  describe 'PUT #update' do
    let!(:user) { create(:user) }

    let(:token) { user.to_token }

    let(:headers) { authenticated_headers(token) }

    context 'with valid data' do
      let(:params) do
        {
          user: {
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            email: Faker::Internet.email
          }
        }
      end
  
      it 'responds with http status ok' do
        put "/api/users/#{user.id}", params: params, headers: headers
        expect(response).to have_http_status(:ok)
      end
  
      it 'responds with update user' do
        put "/api/users/#{user.id}", params: params, headers: headers
        result = JSON.parse(response.body)
        expect(result["user"]["first_name"]).not_to eq(user.first_name)
      end
  
      it 'responds with update fields' do
        expect { put "/api/users/#{user.id}", params: params, headers: headers }.to change { user.reload.last_name }
      end
    end

    context 'with invalid data' do
      let(:user) { create(:user) }

      let(:params) do
        {
          user: {
            first_name: nil,
            last_name: nil,
            email: nil
          }
        }
      end

      it 'responds with http status not found' do
        id = Faker::Number.number(digits: 3)
        put "/api/users/#{id}", params: params, headers: headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end