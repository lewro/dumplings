class InvoiceProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def destroy
    @id                     = params[:id]
    @invoice_product        = InvoiceProduct.find_by_id(@id)
    @invoice                = Invoice.find_by_id(@invoice_product.invoice_id)
    @client                 = Company.find_by_id(@invoice.client_id)

    @invoice_product.destroy

    update_invoice

    render :nothing => true
  end

  def create
    @invoice_product        = InvoiceProduct.create(invoice_product_params)
    @invoice                = Invoice.find_by_id(@invoice_product.invoice_id)
    @client                 = Company.find_by_id(@invoice.client_id)

    update_invoice

    redirect_to "/invoices/#{@invoice.id}/edit"
  end

  def update
    @id                       = params[:id]
    @invoice_product          = InvoiceProduct.find_by_id(@id)
    @invoice                  = Invoice.find_by_id(@invoice_product.invoice_id)
    @invoice_products         = InvoiceProduct.where(:invoice_id => @invoice.id)
    @client                   = Company.find_by_id(@invoice.client_id)

    @invoice_product.update(invoice_product_params)

    update_invoice

    render :text => "#{t'actions.saved'}"
  end

  def update_invoice
    @sum = calculate_total_invoice_sum_without_tax()

    if @client.use_tax
      @invoice_sum = calculate_total_invoice_sum_with_tax()
    else
      @invoice_sum = @sum
    end

    @invoice.update(:sum_with_tax => @invoice_sum, :sum => @sum)
  end

  def invoice_product_params
     params.require(:invoice_product).permit(:invoice_id, :product_id, :packages_quantity, :packages_size, :package_price, :user_id, :unit, :expiration_date)
  end

end
