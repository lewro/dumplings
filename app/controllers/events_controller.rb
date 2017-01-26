class EventsController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.new
  end

  def create
    @event        = Event.create(event_params)

    redirect_to action: "index"
  end

  def index
    @user           = current_user
    @events         = Event.joins("JOIN companies ON companies.id = events.client_id").where(:user_id => @user.id).select("companies.name AS name, events.date AS date, events.time AS time, events.note AS note, events.id AS id").where("date > ?", DateTime.now - 1.day).order("date")
    @event          = Event.new
    @your_clients   = Company.where(:status => 4, :category => "client", :sales_id => @id)
  end

  def edit
    @id         = params[:id]
    @event      = Event.find_by_id(@id)
  end

  def update
    @id 	     = params[:id]
    @event 	   = Event.find_by_id(@id)

    @event.update(event_params)

    redirect_to action: "index"
  end

  def destroy
    @id          = params[:id]
    @event       = Event.find_by_id(@id)

    @event.destroy

    redirect_to action: "index"
  end

  def event_params
     params.require(:event).permit(:user_id, :client_id, :date, :time, :note)
  end
end
