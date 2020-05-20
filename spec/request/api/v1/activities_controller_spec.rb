require 'rails_helper'

RSpec.describe Api::V1::ActivitiesController, type: :request do
  describe 'GET #index' do
    let(:user) { create(:user) }

    let(:token) { user.to_token }

    let(:headers) { authenticated_headers(token) }

    it 'responds with http status ok' do
      get '/api/activities', params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'return zero objects' do
      get '/api/activities', params: {}, headers: headers
      expect(response.body).to have_json_size(0).at_path('activities')
    end

    context "when return objects" do
      let!(:activity) { create(:activity) }

      it 'return array object' do
        get '/api/activities', params: {}, headers: headers
        expect(response.body).to have_json_size(1).at_path('activities')
      end

      it 'return json array' do
        get '/api/activities', params: {}, headers: headers
        expect(response.body).to have_json_path('activities')
      end
    end
  end

  describe 'GET #show' do
    let!(:activity) { create(:activity) }

    let(:user) { create(:user) }

    let(:token) { user.to_token }

    let(:headers) { authenticated_headers(token) }

    it 'responds with http status ok' do
      get "/api/activities/#{activity.id}", params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end

    context "with valid data" do
      it 'responds with activity object' do
        get "/api/activities/#{activity.id}", params: {}, headers: headers
        expect(response.body).to have_json_path('activity')
      end
    end

    context "with invalid data" do
      it 'responds with http status ok' do
        id = Faker::Number.number(digits: 3)
        get "/api/activities/#{id}", params: {}, headers: headers
        expect(response).to have_http_status(:not_found)
      end

      it 'responds with http status ok' do
        id = Faker::Number.number(digits: 3)
        get "/api/activities/#{id}", params: {}, headers: headers
        expect(response.body).to have_json_path('errors')
      end

      it 'responds with message errors' do
        id = Faker::Number.number(digits: 3)
        get "/api/activities/#{id}", params: {}, headers: headers
        result = JSON.parse(response.body)
        message_error = ["Couldn't find Activity with 'id'=#{id}"]
        expect(result["errors"]).to eq(message_error)
      end
    end
  end
end