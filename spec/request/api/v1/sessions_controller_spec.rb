require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :request do
  describe 'POST #create' do
    let!(:password) { Faker::Internet.password }
    let(:user) { create(:user, password: password) }

    let(:params) do
      {
        session: {
          email: user.email,
          password: password
        }
      }
    end

    context "with valid information" do
      it 'returns with http status created' do
        post '/sessions', params: params, headers: base_headers
        expect(response).to  have_http_status(:created)
      end

      it 'responds with token' do
        post '/sessions', params: params, headers: base_headers
        expect(response.body).to have_json_path('session/token')
      end
    end

    context 'with invalid data' do
      before(:each) { params[:session][:password] = Faker::Internet.password }

      it 'return with http status bad_request'do
        post '/sessions', params: params, headers: base_headers
        expect(response).to have_http_status(:bad_request)
      end

      it 'return error array' do
        post '/sessions', params: params, headers: base_headers
        expect(response.body).to have_json_type(Array).at_path('errors')
      end

      it 'returns message error' do
        post '/sessions', params: params, headers: base_headers
        result = JSON.parse(response.body)
        error_message = ["password of #{user.email} not found"]
        expect(result["errors"]).to eq(error_message)
      end
    end

    context 'when password is null' do
      before(:each) { params[:session][:password] = nil }

      it 'returns with http status bad_request' do
        post '/sessions', params: params, headers: base_headers
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns with http message errors' do
        post '/sessions', params: params, headers: base_headers
        expect(response.body).to have_json_path("errors")
      end
    end

    context "when password is empty" do
      before(:each) { params[:session][:password] = "" }

      it 'returns with http status bad_request' do
        post '/sessions', params: params, headers: base_headers
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns with http message errors' do
        post '/sessions', params: params, headers: base_headers
        expect(response.body).to have_json_path("errors")
      end
    end
  end
end