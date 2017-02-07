module ApplicationHelper


  def display_date(dateVar)
    dateVar = dateVar.strftime("%B %d, %Y")
    return dateVar
  end

  def display_date_time(dateVar)
    dateVar = dateVar.strftime("%B %d, %Y - %H:%M")
    return dateVar
  end

  def id_format(id, client)

    year                  = (Time.now.year)
    year_last_number      = (Time.now.year).to_s[3]
    value                 = ("%03d" % id).to_s
    sales_representant    = User.find(client.sales_id).id
    sales_rep_2_digits    = ("%02d" % sales_representant).to_s
    user_format           = Setting.where(:user_id => current_user.admin_id).first.id_format

    if user_format == 1
      return year_last_number + "" + sales_rep_2_digits + "" + value
    elsif user_format == 2
      return year.to_s + "" + value
    elsif user_format == 3
      return  value + "" + year.to_s
    end
  end

  def id_format_types(value)
    value = value.to_i
    puts case value

    when 1
      return "YEAR-SALES_ID-NUMBER"
    when 2
      return "YEAR-NUMBER"
    when 3
      return "NUMBER-YEAR"
    end
  end

  def status(value)
    value = value.to_i
    puts case value

    when 1
      return "#{t'status.open'}"
    when 2
      return "#{t'status.in_progress'}"
    when 3
      return "#{t'status.closed'}"
    when 4
      return "#{t'status.active'}"
    when 5
      return "#{t'status.inactive'}"
    when 6
      return "#{t'status.order_sent'}"
    when 7
      return "#{t'status.received'}"
    when 8
      return "#{t'status.out_of_stock'}"
    end
  end

  def category(value)
    value = value.to_i
    puts case value

    when 1
      return "#{t'category.sales_representant'}"
    when 2
      return "#{t'category.factory_worker'}"
    when 3
      return "#{t'category.admin'}"
    when 4
      return "#{t'category.delivery'}"
    when 5
      return "#{t'category.management'}"
    end
  end


  def unit(value)
    value = value.to_i
    puts case value

    #Pieces
    when 1
      return "#{t'unit.pieces'}"

    #Wieghts
    when 2
      return "#{t'unit.t'}"
    when 3
      return "#{t'unit.kg'}"
    when 4
      return "#{t'unit.g'}"
    when 5
      return "#{t'unit.mg'}"

    #Length
    when 6
      return "#{t'unit.km'}"
    when 7
      return "#{t'unit.m'}"
    when 8
      return "#{t'unit.cm'}"
    when 9
      return "#{t'unit.mm'}"

    #Liquids
    when 10
      return "#{t'unit.kl'}"
    when 11
      return "#{t'unit.hl'}"
    when 12
      return "#{t'unit.dal'}"
    when 13
      return "#{t'unit.l'}"
    when 14
      return "#{t'unit.dl'}"
    when 15
      return "#{t'unit.cl'}"
    when 16
      return "#{t'unit.ml'}"
    end
  end

  def print_unit(value)
    value = value.to_i
    puts case value

    #Pieces
    when 1
      return 1

    #Wieghts (returns mg)
    when 2, 3, 4, 5
      return 3

    #Length (returns mm)
    when 6, 7, 8, 9
      return 7

    #Liquids (returns ml)
    when 10, 11, 12, 13, 14, 15, 16
      return 13
    end
  end


  def convert_to_print_value(type, value)

    #Converts to smallest unit
    type = type.to_i
    value = value.to_f

    puts case type

    #Pieces
    when 1
      return 1 * value

    #Wieghts to kg
    when 2
      return (value / 1000000).to_f
    when 3
      return (value / 1000000).to_f
    when 4
      return (value / 1000000).to_f
    when 5
      return (value / 1000000).to_f

    #Length to meters
    when 6
      return (value / 1000).to_f
    when 7
      return (value / 1000).to_f
    when 8
      return (value / 1000).to_f
    when 9
      return (value / 1000).to_f

    #Liquids to liters
    when 10
      return (value / 1000).to_f
    when 11
      return (value / 1000).to_f
    when 12
      return (value / 1000).to_f
    when 13
      return (value / 1000).to_f
    when 14
      return (value / 1000).to_f
    when 15
      return (value / 1000).to_f
    when 16
      return (value / 1000).to_f
    end
  end

  def payment_type(value)
    value = value.to_i
    puts case value

    when 1
      return "#{t'payment_type.cash'}"
    when 2
      return "#{t'payment_type.card'}"
    when 3
      return "#{t'payment_type.transfer'}"
    end
  end

  def delivery_type(value)
    value = value.to_i
    puts case value

    when 1
      return "#{t'delivery_type.service'}"
    when 2
      return "#{t'delivery_type.collection'}"
    end
  end

  def payment_type_select(f, preselected=nil)
    return f.select(:payment_type, options_for_select([[payment_type(1),1], [payment_type(2),2], [payment_type(3),3]], preselected  ),)
  end

  def delivery_type_select(f, preselected=nil)
    return f.select(:delivery_type, options_for_select([[delivery_type(1),1], [delivery_type(2),2]], preselected  ),)
  end

  def client_status_select(f, preselected=nil)
    return f.select(:status, options_for_select([[status(4),4], [status(5),5]], preselected  ),)
  end

  def client_order_status_select(f, preselected=nil)
    return f.select(:status, options_for_select([[status(1),1], [status(2),2], [status(3),3]], preselected  ),)
  end

  def supplier_order_status_select(f, preselected=nil)
    return f.select(:status, options_for_select([[status(1),1], [status(6),6], [status(7),7]], preselected  ),)
  end

  def units_select(f, preselected=nil)
    return f.select(:unit, options_for_select([[unit(1),1], [unit(2),2], [unit(3),3], [unit(4),4], [unit(5),5], [unit(6),6], [unit(7),7], [unit(8),8], [unit(9),9], [unit(10),10], [unit(11),11], [unit(12),12], [unit(13),13], [unit(14),14], [unit(15),15], [unit(16),16]], preselected  ),)
  end

  def stuff_category_select(f, preselected=nil)
    return f.select(:category, options_for_select([[category(1),1], [category(2),2], [category(3),3], [category(4),4], [category(5),5]], preselected  ),)
  end

  def id_format_select(f, preselected=nil)
    return f.select(:id_format, options_for_select([[id_format_types(1),1], [id_format_types(2),2], [id_format_types(3),3]], preselected  ),)
  end

  def sale_reps_select(f, reps)
    return f.collection_select(:sales_id, reps, :id, :full_name)
    #full_name defined in User model
  end

  def clients_select(f, clients)
    return f.collection_select(:client_id, clients, :id, :name)
  end

  def tax_groups_select(f, tax_groups)
    return f.collection_select(:tax_group_id, tax_groups, :id, :full_tax)
  end

  def suppliers_select(f, suppliers)
    return f.collection_select(:supplier_id, suppliers, :id, :name)
  end

  def products_select(f, products, preselected=nil)
    return f.collection_select(:product_id, products, :id, :product_code_and_name, selected: preselected)
  end

  def delivery_address_select(f, adddresses, preselected=nil)
    return f.collection_select(:delivery_address_id, adddresses, :id, :full_address, selected: preselected)
  end

  def supplies_select(f, supplies, preselected=nil)
    return f.collection_select(:supply_id, supplies, :id, :product_code_and_name, selected: preselected)
  end

  def payment_conditions_select(f, payment_conditions, preselected=nil)
    return f.collection_select(:payment_condition, payment_conditions, :id, :name_and_text, selected: preselected)
  end

  def balance_class(balance)
    if balance >= 0
      @class = "active"
    else
      @class = "pasive"
    end
    return @class
  end

end
