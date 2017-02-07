class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  #TODO
  #ADD EVENTS WHOLE TEAM
  #ADD STATS DATA - MOCKUP
  #ADD TASKS

  def index
    @events         = Event.joins("JOIN companies ON companies.id = events.client_id").joins("JOIN users on events.user_id = users.id").where("users.admin_id = #{current_user.admin_id}").select("companies.name AS name, events.date AS date, events.time AS time, events.note AS note, events.id AS id").where("date > ?", DateTime.now - 1.day).order("date")
  end

end
