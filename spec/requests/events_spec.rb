require 'rails_helper'

RSpec.describe "Events", type: :request do

  let(:valid_attributes) do
    { name: 'Big concert', category: 'concert', place: 'Wroclaw', start_time: Time.now + 21.days,
      ticket_price: 25.99, max_ticket_quantity: 100, ticket_start_time: Time.now + 1.day, ticket_end_time: Time.now + 20.days
    }
  end

  let(:invalid_attributes) do
    { name: 'B', category: 'concert', place: 'Wroclaw', start_time: 'aaa' }
  end

  let(:url) { '/events' }
  let(:event) { create(:event) }

  describe 'GET /events' do
    before do
      event
      get url
    end

    it 'returns a success response' do
      expect(response).to have_http_status(200)
    end

    it 'populates an array of all events' do
      expect(assigns(:events)).to match_array([event])
    end
  end

  context 'with query params' do
    it 'returns searched events' do
      event
      event1 = create(:event, valid_attributes)
      get url, params: { 'q[name_cont]': 'big' }
      result = JSON.parse(response.body).map { |a| a['name'] }
      expect(result).to eq [event1.name]
      expect(result).not_to eq event.name
    end
  end

  describe 'GET /events/:id' do
    before { get "#{url}/#{event.id}" }

    it "returns a success response" do
      expect(response).to be_successful
    end

    it "renders a JSON with the requested event" do
      expect(assigns(:event)).to eq(event)
    end
  end

  describe "POST /events" do
    context "with valid params" do
      it "creates a new event" do
        expect {
          post url, params: {event: valid_attributes}
        }.to change(Event, :count).by(1)
      end

      it "renders a JSON response with the new event and response :created" do
        post url, params: {event: valid_attributes}
        expect(response).to have_http_status(:created)
        expect(assigns(:event)).to eq(Event.last)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new event" do
        post url, params: {event: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['name']).to include('is too short (minimum is 3 characters)')
        expect(JSON.parse(response.body)['start_time']).to include("can't be blank")
      end
    end
  end

  describe "PUT /events/:id" do
    context "with valid params" do
      let(:new_attributes) do
        { name: 'VERY Big concert' }
      end

      it "renders a JSON response with the updated event" do
        put "#{url}/#{event.id}", params: { event: new_attributes }
        event.reload
        expect(response).to be_successful
        expect(assigns(:event)).to eq(event)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the event" do
        put "#{url}/#{event.id}", params: { event: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['name']).to include('is too short (minimum is 3 characters)')
      end
    end
  end

  describe "DELETE /events/:id" do
    it "destroys the requested event" do
      event
      expect {
        delete "#{url}/#{event.id}"
      }.to change(Event, :count).by(-1)
    end
  end
end
