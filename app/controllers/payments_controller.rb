class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def new
    @payment               = Payment.new
    @payment.paid_date     = Time.now

    if params[:id]
      @invoice              = Invoice.find_by_id(params[:id])
      @payment.invoice_id   = @invoice.id
    end
  end

  def create
    @payment = Payment.create(payment_params)

    if @payment.invoice_id
      update_invoice

      if @invoice.id
        redirect_to "/invoices/#{@invoice.id}/edit"
      else
        redirect_to action: "index"
      end
    else
      redirect_to action: "index"
    end
  end

  def index

    #Filtering
    if params[:payment]

      @from         = params[:payment][:from]
      @to           = params[:payment][:to]

      if @from != ""
        @from_date = "payments.paid_date > ?", @from
      else
        @from_date = ""
      end

      if @to != ""
        @to_date = "payments.paid_date < ?", @to
      else
        @to_date = ""
      end
    end

    #LEFT JOINS - INCLUDING PAYMENTS WTIH NO INVOICES
    @payments = Payment.paginate(:page => params[:page], :per_page => @pagination).joins("LEFT JOIN invoices on payments.invoice_id = invoices.id LEFT JOIN companies on companies.id = invoices.client_id").select("companies.name AS client_name, payments.id AS id, payments.sum AS sum, payments.paid_date AS paid_date, invoices.id AS invoice_id").order("payments.id DESC").where(@from_date).where(@to_date)
  end

  def edit
    @id       = params[:id]
    @payment  = Payment.joins("LEFT JOIN invoices ON payments.invoice_id = invoices.id LEFT JOIN companies on companies.id = invoices.client_id LEFT JOIN users ON companies.sales_id = users.id").where("payments.id" => @id).select("companies.name AS client_title, concat(users.first_name, ' ',users.last_name) AS sales_representative, invoices.id AS invoice_id, invoices.sum AS invoiced_sum, payments.sum AS sum, payments.paid_date AS paid_date, payments.id AS id").group("id").first
    @invoice  = Invoice.find_by_id(@payment.invoice_id)
  end

  def update
    @id           = params[:id]
    @payment      = Payment.find_by_id(@id)

    @payment.update(payment_params)

    update_invoice

    redirect_to action: "index"
  end

  def destroy
    @id       = params[:id]
    @payment  = Payment.find_by_id(@id)
    @invoice  = Invoice.find_by_id(@payment.invoice_id)

    @payment.destroy

    if @invoice
      update_invoice
    end

    if @invoice
      redirect_to "/invoices/#{@invoice.id}/edit"
    else
      redirect_to action: "index"
    end
  end

  def update_invoice
    @invoice        = Invoice.find_by_id(@payment.invoice_id)
    @payments_sum   = Payment.where(:invoice_id => @payment.invoice_id).sum(:sum)

    if @payments_sum >= @invoice.sum
      @invoice.update(:paid_date => @payment.paid_date)
    else
      @invoice.update(:paid_date => nil)
    end
  end

  def payment_params
     params.require(:payment).permit(:invoice_id, :user_id, :sum, :paid_date)
  end

end
