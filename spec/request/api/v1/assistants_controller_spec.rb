require 'rails_helper'

RSpec.describe Api::V1::AssistantsController, type: :request do
  describe 'GET #index' do
    let(:user) { create(:user) }

    let(:token) { user.to_token }

    let(:headers) { authenticated_headers(token) }

    it 'responds with http status ok' do
      get '/api/assistants', params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'return zero objects' do
      get '/api/assistants', params: {}, headers: headers
      expect(response.body).to have_json_size(0).at_path('assistants')
    end

    context "when return objects" do
      let!(:assistant) { create(:assistant) }

      it 'return array object' do
        get '/api/assistants', params: {}, headers: headers
        expect(response.body).to have_json_size(1).at_path('assistants')
      end

      it 'return json array' do
        get '/api/assistants', params: {}, headers: headers
        expect(response.body).to have_json_path('assistants')
      end
    end
  end

  describe 'GET #show' do
    let!(:user) { create(:user) }

    let(:assistant) { create(:assistant) }

    let(:token) { user.to_token }

    let(:headers) { authenticated_headers(token) }

    it 'responds with http status ok' do
      get "/api/assistants/#{assistant.id}", params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end

    context "with valid data" do
      it 'responds with assistant object' do
        get "/api/assistants/#{assistant.id}", params: {}, headers: headers
        expect(response.body).to have_json_path('assistant')
      end
    end

    context "with invalid data" do
      it 'responds with http status ok' do
        id = Faker::Number.number(digits: 3)
        get "/api/assistants/#{id}", params: {}, headers: headers
        expect(response).to have_http_status(:not_found)
      end

      it 'responds with http status ok' do
        id = Faker::Number.number(digits: 3)
        get "/api/assistants/#{id}", params: {}, headers: headers
        expect(response.body).to have_json_path('errors')
      end

      it 'responds with message errors' do
        id = Faker::Number.number(digits: 3)
        get "/api/assistants/#{id}", params: {}, headers: headers
        result = JSON.parse(response.body)
        message_error = ["Couldn't find Assistant with 'id'=#{id}"]
        expect(result["errors"]).to eq(message_error)
      end
    end
  end

  describe 'POST #create' do
    let!(:user) { create(:user) }

    let(:token) { user.to_token }

    let(:headers) { authenticated_headers(token) }

    context "with valid data" do
      let(:params) do
        {
          assistant: {
            name:    Faker::Name.first_name,
            group:   Faker::Name.last_name,
            address: Faker::Address.full_address,
            phone:   Faker::Number.number(digits: 10)
          }
        }
      end
  
      it 'responds with http status created' do
        post '/api/assistants', params: params, headers: headers
        expect(response).to have_http_status(:created)
      end
  
      it 'responds with yassistant object' do
        post '/api/assistants', params: params, headers: headers
        expect(response.body).to have_json_path('assistant')
      end
    end

    describe 'PUT #update' do
      let!(:user) { create(:user) }

      let!(:assistant) { create(:assistant) }
  
      let(:token) { user.to_token }
  
      let(:headers) { authenticated_headers(token) }
  
      context 'with valid data' do
        let(:params) do
          {
            assistant: {
              name: Faker::Name.first_name,
              group: Faker::Name.last_name,
              address: Faker::Address.full_address,
              phone: Faker::Number.number(digits: 3)
            }
          }
        end
    
        it 'responds with http status ok' do
          put "/api/assistants/#{assistant.id}", params: params, headers: headers
          expect(response).to have_http_status(:ok)
        end
    
        it 'responds with update user' do
          put "/api/assistants/#{assistant.id}", params: params, headers: headers
          result = JSON.parse(response.body)
          expect(result["assistant"]["name"]).not_to eq(assistant.name)
        end
    
        it 'responds with update fields' do
          expect { put "/api/assistants/#{assistant.id}", params: params, headers: headers }.to change { assistant.reload.name }
        end
      end
  
      context 'with invalid data' do
        let(:params) do
          {
            user: {
              name: nil,
              group: nil,
              address: nil,
              phone: nil
            }
          }
        end
  
        it 'responds with http status not found' do
          id = Faker::Number.number(digits: 3)
          put "/api/assistants/#{id}", params: params, headers: headers
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:user) { create(:user) }

      let!(:assistant) { create(:assistant) }
  
      let(:token) { user.to_token }
  
      let(:headers) { authenticated_headers(token) }

      it 'responds with status no_content' do
        delete "/api/assistants/#{assistant.id}", params: {}, headers: headers
        expect(response).to have_http_status(:no_content)
      end

      it 'responds with status not_found' do
        id = Faker::Number.number(digits: 3)
        delete "/api/assistants/#{id}", params: {}, headers: headers
        expect(response).to have_http_status(:not_found)
      end

      it 'responds with error' do
        id = Faker::Number.number(digits: 3)
        delete "/api/assistants/#{id}", params: {}, headers: headers
        expect(response.body).to have_json_path("errors")
      end

      it 'responds with messsage error' do
        id = Faker::Number.number(digits: 3)
        delete "/api/assistants/#{id}", params: {}, headers: headers
        result = JSON.parse(response.body)
        message_error = ["Couldn't find Assistant with 'id'=#{id}"]
        expect(result["errors"]).to eq(message_error)
      end
    end
  end
end