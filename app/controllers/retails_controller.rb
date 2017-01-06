class RetailsController < ApplicationController
	before_action :authenticate_user!


	def index
		#@retails = Retail.join("JOIN users on retails.user_id = users.id").where("users.admin_id = #{current_user.admin_id}")
		@retails = Retail.all
	end

	def retail_params
		params.require(:retail).permit(:user_id, :sum, :transport_cost, :retialproducts, :note, :payment_type, :delivery_type)
	end  

end  
