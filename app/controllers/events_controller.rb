class EventsController < ApplicationController
  before_action :authenticate_user!

  def events_params
     params.require(:event).permit()
  end  
end