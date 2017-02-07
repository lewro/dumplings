class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def index
    #users set in application controller
  end

  def edit
    @id             = params[:id]
    @user           = User.find_by_id(@id)
    @events         = Event.joins("JOIN companies ON companies.id = events.client_id").where(:user_id => @user.id).select("companies.name AS name, events.date AS date, events.time AS time, events.note AS note, events.id AS id").where("date > ?", DateTime.now - 1.day).order("date")
    @event          = Event.new
    @your_clients   = Company.where(:status => 4, :category => "client", :sales_id => @id)
  end

  def new
    @user  = User.new
  end

  def create
    #TODO: Only admin can create users

    @user       = User.create(user_params)
    @email      = params[:user][:email]
    @password   = params[:user][:password]
    @emailExist = User.where(:email => @email).size
    @error      = ""

    if @emailExist > 0
      @error = t 'errors.email_exists'
    end

    if @password.length < 6
      @error = @error + " & #{t 'errors.password_length'}"
    end

    #Admin ID
    @user.admin_id = current_user.id

    if @user.save
        redirect_to action: "index"
    else
      flash[:notice] =  @error
    end
  end

  def update
    @id       = params[:id]
    @user     = User.find_by_id(@id)

    @user.update(user_params)

    redirect_to action: "index"
  end

  def destroy
    @id         = params[:id]
    @user       = User.find_by_id(@id)
    @companies  = Company.where(:sales_id => @id)

    if @companies.size > 0
      flash[:notice] = t "errors.companies_exist"
      redirect_to action: "edit"
    else
      @user.destroy
      redirect_to action: "index"
    end
  end

  def user_params
     params.require(:user).permit(:first_name, :last_name, :email, :category, :note, :password)
  end

end
