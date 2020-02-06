class TicketsController < ApplicationController
  before_action :set_ticket, only: %i[show update destroy]
  before_action :set_event

  def index
    @tickets = @event.tickets

    render json: @tickets
  end

  def show
    render json: @ticket
  end

  def create
    @ticket = @event.tickets.new(check_params)

    if @ticket.save
      render json: @ticket, status: :created
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  def check_params
    params.require(:ticket).permit(:quantity)
  end
end
