class Supply < ActiveRecord::Base

  acts_as_indexed :fields => [:id, :user_id, :name, :note, :product_code]

  def product_code_and_name
    unless product_code.nil? || product_code == ""|| product_code == ""
      "#{product_code} - #{name}"
    else
      "#{name}"
    end
  end
end
