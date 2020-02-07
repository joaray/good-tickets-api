class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event

  def index
    @tickets = current_user == @event.organizer ? @event.tickets : current_user.tickets

    render json: @tickets
  end

  def show
    @ticket = Ticket.find(params[:id])
    render json: @ticket if current_user == (@ticket.customer || @event.organizer)
  end

  def create
    throw :alert unless @event.tickets_active?

    @ticket = @event.tickets.new(check_params)
    @ticket.customer = current_user

    amount = @event.ticket_price * @ticket.quantity

    Adapters::Payment::Gateway.charge(amount: amount, token: params[:token])
    if @ticket.save
      render json: @ticket, status: :created
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def check_params
    params.require(:ticket).permit(:quantity)
  end
end
