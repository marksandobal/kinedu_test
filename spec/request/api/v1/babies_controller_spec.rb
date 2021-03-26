require 'rails_helper'

RSpec.describe Api::V1::BabiesController, type: :request do
  describe 'GET #index' do
    let(:user) { create(:user) }

    let(:token) { user.to_token }

    let(:headers) { authenticated_headers(token) }

    it 'responds with http status ok' do
      get '/api/babies', params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'return zero objects' do
      get '/api/babies', params: {}, headers: headers
      expect(response.body).to have_json_size(0).at_path('babies')
    end

    context "when return objects" do
      let!(:baby) { create(:baby) }

      it 'return array object' do
        get '/api/babies', params: {}, headers: headers
        expect(response.body).to have_json_size(1).at_path('babies')
      end

      it 'return json array' do
        get '/api/babies', params: {}, headers: headers
        expect(response.body).to have_json_path('babies')
      end
    end
  end

  describe 'GET #show' do
    let!(:baby) { create(:baby) }

    let(:user) { create(:user) }

    let(:token) { user.to_token }

    let(:headers) { authenticated_headers(token) }

    it 'responds with http status ok' do
      get "/api/babies/#{baby.id}", params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end

    context "with valid data" do
      it 'responds with baby object' do
        get "/api/babies/#{baby.id}", params: {}, headers: headers
        expect(response.body).to have_json_path('baby')
      end
    end

    context "with invalid data" do
      it 'responds with http status ok' do
        id = Faker::Number.number(digits: 3)
        get "/api/babies/#{id}", params: {}, headers: headers
        expect(response).to have_http_status(:not_found)
      end

      it 'responds with http status ok' do
        id = Faker::Number.number(digits: 3)
        get "/api/babies/#{id}", params: {}, headers: headers
        expect(response.body).to have_json_path('errors')
      end

      it 'responds with message errors' do
        id = Faker::Number.number(digits: 3)
        get "/api/babies/#{id}", params: {}, headers: headers
        result = JSON.parse(response.body)
        message_error = ["Couldn't find Baby with 'id'=#{id}"]
        expect(result["errors"]).to eq(message_error)
      end
    end
  end
end