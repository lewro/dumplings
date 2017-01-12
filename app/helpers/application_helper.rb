module ApplicationHelper
  
  
  def display_date(dateVar)
    dateVar = dateVar.strftime("%B %d, %Y")
    return dateVar
  end
  
  def display_date_time(dateVar)
    dateVar = dateVar.strftime("%B %d, %Y - %H:%M")
    return dateVar
  end

  def id_format(value)
    value = value.to_i
    if value == 1
      return "XX/YEAR/NUMBER1"
    elsif value == 2  
      return "XX/YEAR/NUMBER2"    
    elsif value == 3
      return "XX/YEAR/NUMBER3"
    end
  end

  def status(value)
    value = value.to_i
    if value == 1
      return "#{t'status.open'}"
    elsif value == 2  
      return "#{t'status.in_progress'}"      
    elsif value == 3
      return "#{t'status.closed'}"      
    elsif value == 4
      return "#{t'status.active'}"      
    elsif value == 5
      return "#{t'status.inactive'}"      
    elsif value == 6
      return "#{t'status.order_sent'}"      
    elsif value == 7
      return "#{t'status.received'}"      
    elsif value == 8
      return "#{t'status.out_of_stock'}"      
    end
  end
  
  def category(value)
    value = value.to_i
    if value == 1
      return "#{t'category.sales_representant'}"
    elsif value == 2  
      return "#{t'category.factory_worker'}"
    elsif value == 3
      return "#{t'category.admin'}"
    elsif value == 4
      return "#{t'category.delivery'}"
    elsif value == 5  
      return "#{t'category.management'}"
    end
  end
    
  def unit(value)
    value = value.to_i
    if value == 1
      return "#{t'unit.pieces'}"
    elsif value == 2  
      return "#{t'unit.kg'}"
    elsif value == 3
      return "#{t'unit.m'}"
    elsif value == 4
      return "#{t'unit.cm'}"
    elsif value == 5  
      return "#{t'unit.mm'}"
    elsif value == 6
      return "#{t'unit.l'}"
    end    
  end
  
  def payment_type(value)
    value = value.to_i
    if value == 1
      return "#{t'payment_type.cash'}"
    elsif value == 2  
      return "#{t'payment_type.card'}"      
    elsif value == 3
      return "#{t'payment_type.transfer'}"            
    end
  end

  def delivery_type(value)
    value = value.to_i
    if value == 1
      return "#{t'delivery_type.service'}"
    elsif value == 2  
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
    return f.select(:unit, options_for_select([[unit(1),1], [unit(2),2], [unit(3),3], [unit(4),4], [unit(5),5], [unit(6),6]], preselected  ),)
  end  
  
  def stuff_category_select(f, preselected=nil)
    return f.select(:category, options_for_select([[category(1),1], [category(2),2], [category(3),3], [category(4),4], [category(5),5]], preselected  ),)
  end  

  def id_format_select(f, preselected=nil)
    return f.select(:id_format, options_for_select([[id_format(1),1], [id_format(2),2], [id_format(3),3]], preselected  ),)
  end    
  
  def sale_reps_select(f, reps)    
    return f.collection_select(:sales_id, reps, :id, :full_name)  
    #full_name defined in User model  
  end

  def clients_select(f, clients)
    return f.collection_select(:client_id, clients, :id, :name)
  end

  def suppliers_select(f, suppliers)
    return f.collection_select(:supplier_id, suppliers, :id, :name)
  end
  
  def products_select(f, products, preselected=nil)    
    return f.collection_select(:product_id, products, :id, :product_code_and_name, selected: preselected)      
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
