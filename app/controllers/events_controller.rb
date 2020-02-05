class EventsController < ApplicationController
  before_action :set_event, only: %i[show update destroy]

  def index
    @events = Event.ransack(params[:q]).result

    render json: @events
  end

  def show
    render json: @event
  end

  def create
    @event = Event.new(check_params)

    if @event.save
      render json: @event, status: :created, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(check_params)
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def check_params
    params.require(:event).permit(:name, :category, :place, :start_time)
  end
end
