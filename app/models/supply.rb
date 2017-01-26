class Supply < ActiveRecord::Base

	def product_code_and_name
		unless product_code.nil? || product_code == ""|| product_code == ""
			"#{product_code} - #{name}"
   	else
   		"#{name}"
   	end
  end
end
