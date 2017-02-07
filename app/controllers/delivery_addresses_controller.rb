class DeliveryAddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def create
    @delivery_addresses     = DeliveryAddress.create(delivery_address_params)
    @company                = Company.find_by_id(@delivery_addresses.company_id)

    redirect_to "/companies/#{@company.id}/edit"
  end

  def destroy
    @id                     = params[:id]
    @delivery_addresses     = DeliveryAddress.find_by_id(@id)

    @delivery_addresses.destroy

    render :text => "#{t'actions.saved'}"
  end

  def delivery_address_params
     params.require(:delivery_address).permit(:user_id, :street, :street_number, :city, :zip_code, :company_id)
  end
end
