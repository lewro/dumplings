class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def new
    @task = Task.new
  end

  def create
    @task        = Task.create(task_params)

    redirect_to action: "index"
  end

  def edit
    @id          = params[:id]
    @task        = Task.find_by_id(@id)
  end

  def index
    @task = Task.new
    # tasks define in app. controller
  end

  def update
    @id          = params[:id]
    @task        = Task.find_by_id(@id)

    @task.update(task_params)

    redirect_to action: "index"
  end

  def mark_task_as_done
    @id          = params[:id]
    @task        = Task.find_by_id(@id)

    @task.update(:status => 0)

    render :nothing => true
  end

  def destroy
    @id          = params[:id]
    @task        = Task.find_by_id(@id)

    @task.destroy

    redirect_to action: "index"
  end

  def task_params
     params.require(:task).permit(:name, :message, :condition_object, :operator, :condition_value, :condition_unit, :frequency_value, :frequency_unit, :status, :user_id)
  end

end
