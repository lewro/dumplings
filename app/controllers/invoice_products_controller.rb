class InvoiceProductsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @id                     = params[:id]
    @invoice_product        = InvoiceProduct.find_by_id(@id)
    @invoice                = Invoice.find_by_id(@invoice_product.invoice_id)
    @new_sum                = @invoice.sum - (@invoice_product.package_price * @invoice_product.packages_quantity)

    @invoice.update(:sum => @new_sum)
    @invoice_product.destroy

    render :nothing => true
  end

  def create
    @invoice_product        = InvoiceProduct.create(invoice_product_params)
    @invoice                = Invoice.find_by_id(@invoice_product.invoice_id)
    @new_sum                = @invoice_product.package_price * @invoice_product.packages_quantity + @invoice.sum

    @invoice.update(:sum => @new_sum)

    redirect_to "/invoices/#{@invoice.id}/edit"
  end

  def update
    @id                       = params[:id]
    @invoice_product          = InvoiceProduct.find_by_id(@id)
    @invoice                  = Invoice.find_by_id(@invoice_product.invoice_id)
    @invoice_products         = InvoiceProduct.where(:invoice_id => @invoice.id)
    @new_sum                  = 0

    @invoice_product.update(invoice_product_params)

    @invoice_products.each do |op|
      @new_sum =  @new_sum  + (op.package_price * op.packages_quantity)
    end

    @invoice.update(:sum => @new_sum)

    render :text => "#{t'actions.saved'}"
  end

  def invoice_product_params
     params.require(:invoice_product).permit(:invoice_id, :product_id, :packages_quantity, :packages_size, :package_price, :user_id, :unit, :expiration_date)
  end

end
