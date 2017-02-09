class SearchesController < ApplicationController

  def index
    @query           = params[:q]
    @category        = params[:category]

    puts case @category

    when "company"
      @results    = Company.with_query(@query)


    when "offer"
      @company    = Company.find_with_index(@query,{},{:ids_only => true})

      if @company.size > 0
        @results    = Offer.joins("JOIN companies ON companies.id = offers.client_id").select("companies.name AS company_name, offers.id AS offer_id, offers.sum AS offer_sum, offers.reference_id AS reference_id, offers.issue_date AS issue_date").where("offers.client_id" => @company)
      else
        @results    = Offer.with_query(@query).joins("JOIN companies ON companies.id = offers.client_id").select("companies.name AS company_name, offers.id AS offer_id, offers.sum AS offer_sum, offers.reference_id AS reference_id, offers.issue_date AS issue_date")
      end

    when "client_order"
      @company    = Company.find_with_index(@query,{},{:ids_only => true})

      if @company.size > 0
        @results = ClientOrder.joins("JOIN companies ON companies.id = client_orders.client_id").select('companies.name AS company_name, client_orders.id AS order_id, client_orders.sum AS order_sum, client_orders.expected_delivery AS order_expected_delivery, client_orders.distribution AS order_distribution, client_orders.status AS order_status, client_orders.reference_id AS reference_id').where("client_orders.client_id" => @company).order("client_orders.id DESC")
      else
        @results = ClientOrder.with_query(@query).joins("JOIN companies ON companies.id = client_orders.client_id").select('companies.name AS company_name, client_orders.id AS order_id, client_orders.sum AS order_sum, client_orders.expected_delivery AS order_expected_delivery, client_orders.distribution AS order_distribution, client_orders.status AS order_status, client_orders.reference_id AS reference_id').order("client_orders.id DESC")
      end

    when "delivery_note"
      @company    = Company.find_with_index(@query,{},{:ids_only => true})

      if @company.size > 0
        @results = DeliveryNote.joins("JOIN users ON users.id = delivery_notes.user_id").joins("JOIN companies ON companies.id = delivery_notes.client_id").where("users.admin_id = #{current_user.admin_id}").select("delivery_notes.reference_id AS reference_id, delivery_notes.order_id AS order_id, delivery_notes.sum AS sum, delivery_notes.note AS note, delivery_notes.payment_condition AS payment_condition, delivery_notes.id AS id, companies.name AS company_name").where("delivery_notes.client_id" => @company).order("delivery_notes.id DESC")
      else
        @results = DeliveryNote.with_query(@query).joins("JOIN users ON users.id = delivery_notes.user_id").joins("JOIN companies ON companies.id = delivery_notes.client_id").where("users.admin_id = #{current_user.admin_id}").select("delivery_notes.reference_id AS reference_id, delivery_notes.order_id AS order_id, delivery_notes.sum AS sum, delivery_notes.note AS note, delivery_notes.payment_condition AS payment_condition, delivery_notes.id AS id, companies.name AS company_name").order("delivery_notes.id DESC")
      end

      when "invoice"
        @company    = Company.find_with_index(@query,{},{:ids_only => true})

        if @company.size > 0
          @results = Invoice.joins("JOIN companies ON companies.id = invoices.client_id").select("companies.name AS client_name, invoices.id AS id, invoices.sum_with_tax AS sum, invoices.due_date AS due_date, invoices.paid_date AS paid_date, (SELECT SUM(sum) FROM payments WHERE invoices.id = payments.invoice_id) AS balance, (SELECT SUM(sum) FROM payments WHERE payments.invoice_id = invoices.linked_proforma_id) AS proforma_balance").where(:proforma => false).where("invoices.client_id" => @company).order("id DESC")
        else
          @results = Invoice.with_query(@query).joins("JOIN companies ON companies.id = invoices.client_id").select("companies.name AS client_name, invoices.id AS id, invoices.sum_with_tax AS sum, invoices.due_date AS due_date, invoices.paid_date AS paid_date, (SELECT SUM(sum) FROM payments WHERE invoices.id = payments.invoice_id) AS balance, (SELECT SUM(sum) FROM payments WHERE payments.invoice_id = invoices.linked_proforma_id) AS proforma_balance").where(:proforma => false).order("id DESC")
        end

      when "proforma_invoice"
        @company    = Company.find_with_index(@query,{},{:ids_only => true})

        if @company.size > 0
          @results = Invoice.joins("JOIN companies ON companies.id = invoices.client_id").select("companies.name AS client_name, invoices.id AS id, invoices.sum_with_tax AS sum, invoices.due_date AS due_date, invoices.paid_date AS paid_date, (SELECT SUM(sum) FROM payments WHERE invoices.id = payments.invoice_id) AS balance, (SELECT SUM(sum) FROM payments WHERE payments.invoice_id in (SELECT I2.id FROM invoices AS I2 where I2.linked_proforma_id = invoices.id)) AS proforma_balance").where(:proforma => true).where("invoices.client_id" => @company).order("id DESC")
        else
          @results = Invoice.with_query(@query).joins("JOIN companies ON companies.id = invoices.client_id").select("companies.name AS client_name, invoices.id AS id, invoices.sum_with_tax AS sum, invoices.due_date AS due_date, invoices.paid_date AS paid_date, (SELECT SUM(sum) FROM payments WHERE invoices.id = payments.invoice_id) AS balance, (SELECT SUM(sum) FROM payments WHERE payments.invoice_id in (SELECT I2.id FROM invoices AS I2 where I2.linked_proforma_id = invoices.id)) AS proforma_balance").where(:proforma => true).order("id DESC")
        end

    when "retail"
      @results = Retail.with_query(@query).joins("JOIN users on retails.user_id = users.id").where("users.admin_id = #{current_user.admin_id}").order("retails.id DESC")

    when "supplier_order"
      @company    = Company.find_with_index(@query,{},{:ids_only => true})

      if @company.size > 0
        @results  = SupplierOrder.joins("JOIN companies ON companies.id = supplier_orders.supplier_id").select("companies.name AS company_name, supplier_orders.id AS order_id, supplier_orders.sum AS order_sum, supplier_orders.expected_delivery AS order_expected_delivery, supplier_orders.delivery AS order_delivery, supplier_orders.status AS order_status ").where("supplier_orders.supplier_id" => @company).order("supplier_orders.id DESC")
      else
        @results  = SupplierOrder.with_query(@query).joins("JOIN companies ON companies.id = supplier_orders.supplier_id").select("companies.name AS company_name, supplier_orders.id AS order_id, supplier_orders.sum AS order_sum, supplier_orders.expected_delivery AS order_expected_delivery, supplier_orders.delivery AS order_delivery, supplier_orders.status AS order_status ").order("supplier_orders.id DESC")
      end

      when "stock"
        @supply = Supply.find_with_index(@query,{},{:ids_only => true})

        @results = Stock.joins("JOIN supplies ON supplies.id = stocks.supply_id").select("stocks.id AS stock_id, stocks.packages_size AS packages_size,  stocks.unit AS unit, supplies.name as product_name").where("stocks.supply_id" => @supply).order("stocks.id DESC")






    end

    render :layout => false
  end

 end
