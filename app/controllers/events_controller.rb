class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[show update destroy]

  def index
    @events = Event.ransack(params[:q]).result

    render json: @events
  end

  def show
    render json: @event
  end

  def create
    @event = current_user.events.new(check_params)

    if @event.save
      render json: @event, status: :created, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def update
    if authorized_user? && @event.update(check_params)
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy if authorized_user?
  end

  private

  def authorized_user?
    current_user == @event.organizer
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def check_params
    params.require(:event).permit(
      :name, :category, :place, :start_time, :ticket_price,
      :max_ticket_quantity, :ticket_start_time, :ticket_end_time
    )
  end
end
