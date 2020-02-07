require 'rails_helper'

RSpec.describe "Ticekts", type: :request do
  let(:event) { create(:event) }
  let(:valid_attributes) do
    { quantity: 7, event: event }
  end
  let(:token) { 'abc' }

  let(:invalid_attributes) do
    { quantity: -5 }
  end

  let(:url) { "/events/#{event.id}/tickets" }
  let(:ticket) { create(:ticket, event: event, customer: customer) }
  let(:customer) { create(:user) }

  describe 'GET /events/:id/tickets' do
    before do
      ticket
      get url, headers: auth_headers(event.organizer)
    end

    it 'returns a success response' do
      expect(response).to have_http_status(200)
    end

    it 'populates an array of all tickets of indicated event' do
      expect(assigns(:tickets)).to match_array([ticket])
    end
  end

  describe 'GET /events/:id/tickets/:id' do
    before { get "#{url}/#{ticket.id}" , headers: auth_headers(customer)}

    it "returns a success response" do
      expect(response).to be_successful
    end

    it "renders a JSON with the requested ticket" do
      expect(assigns(:ticket)).to eq(ticket)
    end
  end

  describe "POST /events/:id/tickets" do
    context 'with valid payment token' do
      context "with valid params" do
        it "creates a new ticket" do
          expect {
            post url, params: {ticket: valid_attributes, token: token}, headers: auth_headers(customer)
          }.to change(Ticket, :count).by(1)
        end

        it "renders a JSON response with the new ticket and response :created" do
          post url, params: {ticket: valid_attributes, token: token}, headers: auth_headers(customer)
          expect(response).to have_http_status(:created)
          expect(assigns(:ticket)).to eq(Ticket.last)
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the new ticket" do
          post url, params: {ticket: invalid_attributes, token: token}, headers: auth_headers(customer)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['quantity']).to include('must be greater than 0')
        end
      end

      context 'with greater quantity than available' do
        it 'renders a JSON response with error' do
          post url, params: {ticket: { quantity: 105, event: event }, token: token}, headers: auth_headers(customer)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['quantity']).to include('must be less than or equal to 80')
        end
      end
    end

    context 'with invalid payment token' do
      context 'with card_error' do
        it "renders a JSON response with card error" do
          post url, params: {ticket: valid_attributes, token: 'card_error'}, headers: auth_headers(customer)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq('Your card has been declined.')
        end
      end

      context 'with payment_error' do
        it "renders a JSON response with payment error" do
          post url, params: {ticket: valid_attributes, token: 'payment_error'}, headers: auth_headers(customer)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq('Something went wrong with your transaction.')
        end
      end
    end
  end
end
