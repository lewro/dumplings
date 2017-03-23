class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  #TODO
  #ADD EVENTS WHOLE TEAM
  #ADD STATS DATA - MOCKUP
  #ADD TASKS

  #Task status
  # - 0 - Task Active
  # - 1 - Task Alert
  # - 2 - Task Supply does not exist in the stock
  # - 3 - Stopped Task
  # - 4 - Expiration Alert

  def index
    @payments = Payment.joins("JOIN users ON users.id = payments.user_id").where("users.admin_id = #{current_user.admin_id}")

    @invoices = Invoice.joins("JOIN users ON users.id = invoices.user_id").where("users.admin_id = #{current_user.admin_id}")

    @clients = Company.joins("JOIN users ON users.id = companies.user_id").where("users.admin_id = #{current_user.admin_id}").where("companies.category = 'client'")

    @client_orders = ClientOrder.joins("JOIN users ON users.id = client_orders.user_id").where("users.admin_id = #{current_user.admin_id}")

    @retails = Retail.joins("JOIN users ON users.id = retails.user_id").where("users.admin_id = #{current_user.admin_id}")


    @total_clients    = @clients.count(:id)
    @active_clients   = @clients.where(:status => 4).count(:id)
    @last_clients     = @clients.where("companies.created_at > ?", DateTime.now - 30.day).count(:id)

    @client_orders_30_days  = @client_orders.where("client_orders.created_at > ?", DateTime.now - 30.day).count(:id)
    @client_orders_today    = @client_orders.where("client_orders.created_at > ?", DateTime.now - 1.day).count(:id)

    @invoices_30_days       = @invoices.where("invoices.created_at > ?", DateTime.now - 30.day).sum(:sum)

    @invoices_today         = @invoices.where("invoices.created_at > ?", DateTime.now - 1.day).sum(:sum)

    @payments_30_days       = @payments.where("payments.created_at > ?", DateTime.now - 30.day).sum(:sum)

    @payments_today         = @payments.where("payments.created_at > ?", DateTime.now - 1.day).sum(:sum)


    @stocks_sum = StockProduct.select("sum(stock_products.packages_size * stock_products.unit_price) AS total_price").where(:gone => false).first

    @retails_30_days        = @retails.where("retails.created_at > ?", DateTime.now - 30.day).sum(:sum)

    @retails_today          = @retails.where("retails.created_at > ?", DateTime.now - 1.day).sum(:sum)

    @reminders = Task.paginate(:page => params[:page], :per_page => @pagination).joins("JOIN users ON users.id = tasks.user_id").joins("LEFT JOIN supplies ON tasks.condition_object = supplies.id").where("users.admin_id = #{current_user.admin_id }").order("tasks.id DESC").select("*, tasks.id AS id,  supplies.name AS supply_name").where(:status => [1,2,4])


  end

end
