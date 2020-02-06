require 'rails_helper'

RSpec.describe "Ticekts", type: :request do
  let(:event) { create(:event) }
  let(:valid_attributes) do
    { quantity: 7, event: event }
  end

  let(:invalid_attributes) do
    { quantity: -5 }
  end

  let(:url) { "/events/#{event.id}/tickets" }
  let(:ticket) { create(:ticket, event: event) }

  describe 'GET /events/:id/tickets' do
    before do
      ticket
      get url
    end

    it 'returns a success response' do
      expect(response).to have_http_status(200)
    end

    it 'populates an array of all tickets of indicated event' do
      expect(assigns(:tickets)).to match_array([ticket])
    end
  end

  describe 'GET /events/:id/tickets/:id' do
    before { get "#{url}/#{ticket.id}" }

    it "returns a success response" do
      expect(response).to be_successful
    end

    it "renders a JSON with the requested ticket" do
      expect(assigns(:ticket)).to eq(ticket)
    end
  end

  describe "POST /events/:id/tickets" do
    context "with valid params" do
      it "creates a new ticket" do
        expect {
          post url, params: {ticket: valid_attributes}
        }.to change(Ticket, :count).by(1)
      end

      it "renders a JSON response with the new ticket and response :created" do
        post url, params: {ticket: valid_attributes}
        expect(response).to have_http_status(:created)
        expect(assigns(:ticket)).to eq(Ticket.last)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new ticket" do
        post url, params: {ticket: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['quantity']).to include('must be greater than 0')
      end
    end
  end
end
