class PaymentCondition < ActiveRecord::Base
  validates_presence_of :text, :name

  def name_and_text
	"#{name} - #{text[1..75]}..."
  end
end
