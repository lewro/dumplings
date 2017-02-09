class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  #TODO
  #ADD EVENTS WHOLE TEAM
  #ADD STATS DATA - MOCKUP
  #ADD TASKS

  def index
    @events = Event.joins("JOIN companies ON companies.id = events.client_id").joins("JOIN users on events.user_id = users.id").where("users.admin_id = #{current_user.admin_id}").select("companies.name AS name, events.date AS date, events.time AS time, events.note AS note, events.id AS id, users.first_name AS first_name, users.last_name AS last_name").where("date > ?", DateTime.now - 1.day).order("date")

    @payments = Payment.joins("JOIN users ON users.id = payments.user_id").where("users.admin_id = #{current_user.admin_id}")

    @invoices = Invoice.joins("JOIN users ON users.id = invoices.user_id").where("users.admin_id = #{current_user.admin_id}")

    @clients = Company.joins("JOIN users ON users.id = companies.user_id").where("users.admin_id = #{current_user.admin_id}").where("companies.category = 'client'")

    @client_orders = ClientOrder.joins("JOIN users ON users.id = client_orders.user_id").where("users.admin_id = #{current_user.admin_id}")

    @total_clients    = @clients.count(:id)
    @active_clients   = @clients.where(:status => 4).count(:id)
    @last_clients     = @clients.where("companies.created_at > ?", DateTime.now - 30.day).count(:id)

    @client_orders_30_days  = @client_orders.where("client_orders.created_at > ?", DateTime.now - 30.day).count(:id)
    @client_orders_today    = @client_orders.where("client_orders.created_at > ?", DateTime.now - 1.day).count(:id)

    @invoices_30_days       = @invoices.where("invoices.created_at > ?", DateTime.now - 30.day).sum(:sum)

    @invoices_today         = @invoices.where("invoices.created_at > ?", DateTime.now - 1.day).sum(:sum)

    @payments_30_days       = @payments.where("payments.created_at > ?", DateTime.now - 30.day).sum(:sum)

    @payments_today         = @payments.where("payments.created_at > ?", DateTime.now - 1.day).sum(:sum)
  end
end
