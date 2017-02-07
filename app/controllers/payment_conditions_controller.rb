class PaymentConditionsController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def index

  end

  def new
    @payment_condition = PaymentCondition.new
  end

  def edit
    @id                   = params[:id]
    @payment_condition    = PaymentCondition.find_by_id(@id)
  end

  def update
    @id                   = params[:id]
    @payment_condition    = PaymentCondition.find_by_id(@id)

    @payment_condition.update(payment_condition_params)

    redirect_to action: "index"
  end

  def create
    @payment_condition = PaymentCondition.create(payment_condition_params)

    redirect_to action: "index"
  end

  def destroy
    @id                     = params[:id]
    @payment_condition      = PaymentCondition.find_by_id(@id)

    @payment_condition.destroy

    redirect_to action: "index"
  end

  def payment_condition_params
     params.require(:payment_condition).permit(:name, :text, :user_id, :admin_id)
  end
end

