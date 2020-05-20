require 'rails_helper'

RSpec.describe Api::V1::ActivityLogsController, type: :request do
  describe 'GET #index' do
    let!(:assistant) { create(:assistant) }

    let!(:baby) { create(:baby) }

    let!(:activity) { create(:activity) }

    let(:user) { create(:user) }

    let(:token) { user.to_token }

    let(:headers) { authenticated_headers(token) }

    it 'responds with http status ok' do
      get '/api/activity_logs', params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'responds with http status ok' do
      get '/api/activity_logs', params: {}, headers: headers
      expect(response.body).to have_json_size(0).at_path('activity_logs')
    end

    context "when return array" do
      let!(:activity_log) {
        create(:activity_log, assistant: assistant, baby: baby, activity: activity)
      }

      it 'responds with json array' do
        get '/api/activity_logs', params: {}, headers: headers
        expect(response.body).to have_json_size(1).at_path('activity_logs')
      end
    end
  end

  describe 'GET #baby_activity_logs' do
    let!(:assistant) { create(:assistant) }

    let!(:baby) { create(:baby) }

    let!(:activity) { create(:activity) }

    let(:user) { create(:user) }

    let(:token) { user.to_token }

    let(:headers) { authenticated_headers(token) }

    it 'responds with https status ok' do
      get "/api/babies/#{baby.id}/activity_logs", params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'with return array with zero elements' do
      get "/api/babies/#{baby.id}/activity_logs", params: {}, headers: headers
      expect(response.body).to have_json_size(0).at_path('activity_logs')
    end

    context 'when return array of objects' do
      let!(:activity_log) {
        create(:activity_log, baby: baby, assistant: assistant, activity: activity)
      }
      it 'return array' do
        get "/api/babies/#{baby.id}/activity_logs", params: {}, headers: headers
        expect(response.body).to have_json_size(1).at_path('activity_logs')
      end
    end
  end

  describe 'POST #create' do
    let!(:assistant) { create(:assistant) }

    let!(:baby) { create(:baby) }

    let!(:activity) { create(:activity) }

    let(:user) { create(:user) }

    let(:token) { user.to_token }

    let(:headers) { authenticated_headers(token) }

    let(:params) do
      {
        activity_log: {
          activity_id: activity.id, 
          assistant_id: assistant.id,
          baby_id: baby.id,
          start_time: DateTime.now
          }
      }
    end

    it 'return http status created' do
      post '/api/activity_logs', params: params, headers: headers
      expect(response).to have_http_status(:created)
    end

    it 'responds with activity_log object' do
      post '/api/activity_logs', params: params, headers: headers
      expect(response.body).to have_json_path('activity_log')
    end

    it 'should return count like 1' do
      expect {
        post '/api/activity_logs', params: params, headers: headers
      }.to change(ActivityLog, :count).by(1)
    end

    context 'with invalid data' do
      let(:invalid_params) do
        {
          activity_log: {
            activity_id: nil, 
            assistant_id: nil,
            baby_id: nil,
            start_time: DateTime.now
            }
        }
      end

      it 'responds with activity_log object' do
        post '/api/activity_logs', params: invalid_params, headers: headers
        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with activity_log object' do
        post '/api/activity_logs', params: invalid_params, headers: headers
        expect(response.body).to have_json_path('errors')
      end
    end
  end

  describe 'PUT #update' do
    let!(:assistant) { create(:assistant) }

    let!(:baby) { create(:baby) }

    let!(:activity) { create(:activity) }


    let!(:activity_log) {
      create(:activity_log, assistant: assistant, baby: baby, activity: activity, start_time: DateTime.now - 1.hour)
    }
    let(:user) { create(:user) }

    let(:token) { user.to_token }

    let(:headers) { authenticated_headers(token) }

    let(:params) do
      {
        activity_log: {
          stop_time: DateTime.now,
          comments: Faker::Lorem.paragraph
          }
      }
    end

    it 'responds with http status ok' do
      put "/api/activity_logs/#{activity_log.id}", params: params, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'responds with update stop_time' do
      put "/api/activity_logs/#{activity_log.id}", params: params, headers: headers
      activity_log.reload

      result = JSON.parse(response.body)
      expect(result["activity_log"]["stop_time"]).not_to eql(nil)
    end

    it 'responds with update comment' do
      put "/api/activity_logs/#{activity_log.id}", params: params, headers: headers
      activity_log.reload

      expect(activity_log.comments).not_to eql(nil)
    end

    it 'responds with update duration' do
      put "/api/activity_logs/#{activity_log.id}", params: params, headers: headers
      activity_log.reload

      expect(activity_log.duration).not_to eql(nil)
    end
  end
end