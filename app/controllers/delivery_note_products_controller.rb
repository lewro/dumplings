class DeliveryNoteProductsController < ApplicationController
  before_action :authenticate_user!
  
  def destroy
  	@id                        = params[:id]    
    @delivery_note_product     = DeliveryNoteProduct.find_by_id(@id)      
    @delivery_note             = DeliveryNote.find_by_id(@delivery_note_product.delivery_note_id)
    @new_sum                   = @delivery_note.sum - (@delivery_note_product.package_price * @delivery_note_product.packages_quantity)
    
    @delivery_note.update(:sum => @new_sum)        
    @delivery_note_product.destroy  
    
    render :nothing => true 
  end

  def create  
    @delivery_note_product    = DeliveryNoteProduct.create(delivery_note_product_params)        
    @delivery_note            = DeliveryNote.find_by_id(@delivery_note_product.delivery_note_id)
    @new_sum                  = @delivery_note_product.package_price * @delivery_note_product.packages_quantity + @delivery_note.sum

    @delivery_note.update(:sum => @new_sum)
    
    redirect_to "/delivery_notes/#{@delivery_note.id}/edit"    
  end

  def delivery_note_product_params
     params.require(:delivery_note_product).permit(:product_id, :packages_quantity, :packages_size, :package_price, :user_id, :unit, :delivery_note_id, :expiration_date)
  end
  
end