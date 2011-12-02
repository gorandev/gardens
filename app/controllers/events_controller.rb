class EventsController < ApplicationController
  respond_to :json
  
  def index
    @events = Event.limit(@count).offset(@offset)
  end
  
  def show
    @event = Event.find(params[:id])
  end
end