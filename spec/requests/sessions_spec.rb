require 'rails_helper'

RSpec.describe 'Registrations', type: :request do

  let(:url_login) { '/login' }
  let(:url_logout) { '/logout' }
  let(:user) { create(:user) }

  describe 'POST /login' do

    context 'with unauthenticated user' do
      context 'with valid params' do
        before { post url_login, params: { user: {email: user.email, password: user.password } } }
        it 'returns 200' do
          expect(response.status).to eq 200
        end

        it 'return logged user' do
          expect(assigns(:user)).to eq user
        end

        it 'returns an authentication token' do
          expect(response.header['Authorization']).not_to be_empty
        end
      end

      context 'with invalid params' do
        it 'returns 401 and validation errors' do
          post url_login, params: { user: {email: user.email, password: 'pass' } }
          expect(response.status).to eq 401
          expect(response.body).to include('Invalid Email or password.')
        end
      end
    end
  end

  describe 'DELETE /logout' do
    it 'returns 200' do
      delete url_logout, headers: auth_headers(user)
      expect(response.status).to eq 200
    end
  end
end
