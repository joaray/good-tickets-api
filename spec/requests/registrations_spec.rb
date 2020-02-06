require 'rails_helper'

RSpec.describe 'Registrations', type: :request do

  let(:url) { '/signup' }

  let(:valid_attributes) do
    {
      email: 'user@example.com',
      password: 'password',
      password_confirmation: 'password'
    }
  end

  let(:invalid_attributes) do
    {
      email: 'user@example.com',
      password: 'pass',
      password_confirmation: 'password'
    }
  end

  let(:user) { create(:user) }

  describe 'POST /signup' do

    context 'with unauthenticated user' do
      context 'with valid params' do
        it 'returns 201' do
          post url, params: { user: valid_attributes }
          expect(response.status).to eq 201
        end

        it 'creates a new user' do
          expect {
            post url, params: { user: valid_attributes }
          }.to change(User, :count).by(1)
        end

        it 'returns a new user' do
          post url, params: { user: valid_attributes }
          expect(response.body).to match_json_schema('user')
        end
      end

      context 'with invalid params' do
        it 'returns 401 and validation errors' do
          post url, params: { user: invalid_attributes }
          expect(response.status).to eq 401
          expect(JSON.parse(response.body)['password']).to include('is too short (minimum is 6 characters)')
          expect(JSON.parse(response.body)['password_confirmation']).to include("doesn't match Password")
        end
      end
    end

    context 'when user already exists' do
      let!(:user) { create(:user, email: valid_attributes[:email]) }
      before do
        post url, params: { user: valid_attributes }
      end

      it 'returns unauthorized status' do
        expect(response.status).to eq 401
      end

      it 'returns validation errors' do
        expect(JSON.parse(response.body)['email']).to eq(['has already been taken'])
      end
    end
  end

  describe 'PUT /signup' do
    let(:new_attributes) do
      {
        email: 'new_user@example.com',
        password: 'new_password',
      }
    end

    context 'with authenticated user' do
      before { put url, params: { user: new_attributes }, headers: auth_headers(user) }
      it 'returns 200' do
        expect(response.status).to eq 200
      end

      it 'returns an updated user' do
        expect(assigns(:user)).to eq user
      end

    end

    context 'with unauthenticated user' do
      before { put url, params: { user: new_attributes } }
      it 'returns 401' do
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /signup' do
    context 'with authenticated user' do
      before { delete url, headers: auth_headers(user) }
      it 'returns 204' do
        expect(response.status).to eq 204
      end
    end

    context 'with unauthenticated user' do
      before { delete url }
      it 'returns 401' do
        expect(response.status).to eq 401
      end
    end
  end
end
