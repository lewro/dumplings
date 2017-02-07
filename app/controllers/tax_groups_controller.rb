class TaxGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def index
  end

  def new
    @tax_group    = TaxGroup.new
  end

  def edit
    @id           = params[:id]
    @tax_group    = TaxGroup.find_by_id(@id)
  end

  def update
    @id           = params[:id]
    @tax_group    = TaxGroup.find_by_id(@id)

    @tax_group.update(tax_groups_params)

    redirect_to action: "index"
  end

  def create
    @tax_group    = TaxGroup.create(tax_groups_params)

    redirect_to action: "index"
  end

  def destroy
    @id           = params[:id]
    @tax_group    = TaxGroup.find_by_id(@id)

    @tax_group.destroy

    redirect_to action: "index"
  end

  def tax_groups_params
    params.require(:tax_group).permit(:id, :tax, :note, :user_id)
  end

 end
