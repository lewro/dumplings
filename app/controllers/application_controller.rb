class ApplicationController < ActionController::Base
  protect_from_forgery


  before_filter :set_reps
  before_filter :set_clients	  
  before_filter :set_suppliers
  before_filter :set_products
  before_filter :set_payment_conditions
  before_filter :set_supplies
  before_filter :set_users  

  
  def set_reps
    if current_user
  	 @reps = User.where(:category => 1, :admin_id => "#{current_user.admin_id}")
  	 return @reps
    end
  end

  def set_clients
    if current_user    
	   @clients = Company.joins("JOIN users ON users.id = companies.user_id").where(:status => 4, :category => "client").where("users.admin_id = #{current_user.admin_id }")
    end
  end

  def set_suppliers
    if current_user    
      @suppliers = Company.joins("JOIN users ON users.id = companies.user_id").where(:status => 4, :category => "supplier").where("users.admin_id = #{current_user.admin_id }") 
    end
  end

  def set_products
    if current_user
      @products = Product.joins("JOIN users ON users.id = products.user_id").where("users.admin_id = #{current_user.admin_id }")
    end
  end

  def set_payment_conditions
    if current_user
      @payment_conditions = PaymentCondition.joins("JOIN users ON users.id = payment_conditions.user_id").where("users.admin_id = #{current_user.admin_id }")
    end
  end

  def set_supplies
    if current_user 
      @supplies =  Supply.joins("JOIN users ON users.id = supplies.user_id").where("users.admin_id = #{current_user.admin_id }")
    end
  end
  
  def set_users
    if current_user
      @users = User.where("users.admin_id =#{current_user.admin_id }") 
    end
  end
end
