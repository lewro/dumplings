class Task < ActiveRecord::Base

  #Task status
  # - 0 - Task Active
  # - 1 - Task Alert
  # - 2 - Task Supply does not exist in the stock
  # - 3 - Stopped Task
  # - 4 - Expiration Alert


  # - Tasks checked when condition met, should be checked when stock product or supply order is updated

  def self.check_expiration_dates
    @settings                 = Setting.where("expiration_alert > ?", 0)

    @settings.each do |setting|
      @days                 = setting.expiration_alert
      @stock_products       = StockProduct.joins("JOIN supplies ON stock_products.supply_id = supplies.id").where("expiration_date < ?", Time.now - @days.days).select("*, supplies.name AS name").where(:gone => false)

      @stock_products.each do |stock_product|
        @task = Task.new(:name => "Expiration Alert", :message => stock_product.name , :status => 4, :condition_object => stock_product.supply_id, :user_id => setting.user_id)
        @task.save!
      end
    end
  end

  #1 - When conditions met
  def self.check_tasks_when_condition_met
    @tasks = get_tasks(1)
    check_task_conditions(@tasks)
  end

  #1 - Every minute --- Should we remove the condition one ?
  def self.check_tasks_every_minute
    @tasks = get_tasks(1)
    check_task_conditions(@tasks)
  end

  #2 - Every hour
  def self.check_tasks_every_hour
    @tasks = get_tasks(2)
    check_task_conditions(@tasks)
  end

  #3 - Every day
  def self.check_tasks_every_day
    @tasks = get_tasks(3)
    check_task_conditions(@tasks)
  end

  #4 - Every week (every 7 days)
  def self.check_tasks_every_week
    @tasks = get_tasks(4)
    check_task_conditions(@tasks)
  end

  #5 - Every month (every 30 days)
  def self.check_tasks_every_month
    @tasks = get_tasks(5)
    check_task_conditions(@tasks)
  end

  def self.get_tasks(frequency)
    @tasks = Task.joins("JOIN users ON users.id = tasks.user_id").joins("LEFT JOIN supplies ON tasks.condition_object = supplies.id").where(:status => 0).where(:frequency_value => frequency).select("*, tasks.id AS id, supplies.name AS supply_name")
  end

  def self.check_task_conditions(tasks)

    tasks.each do |task|

      #Just regular task, no stock
      if task.condition_object.nil?
        task.update(:status => 1)
      #Stock related task
      else

        #Convert the task condition to stock unit
        task_supply_in_common_unit = convert_unit(task.condition_unit, task.condition_value)

        @stock = StockProduct.where(:supply_id => task.condition_object.to_i).where(:gone => false)

        #The product does not exist in the stock
        if @stock.size == 0
          task.update(:status => 2)
        else

          #What is the condition?  1-Less, 2-Greater, 3-Equal
          if task.operator == 1
            @stock_supply = @stock.where("packages_size < ?", task_supply_in_common_unit)
            if @stock_supply.size > 0
              task.update(:status => 1)
            end
          elsif task.operator == 2
            @stock_supply = @stock.where("packages_size > ?", task_supply_in_common_unit)
            if @stock_supply.size > 0
              task.update(:status => 1)
            end

          elsif task.operator == 3
            @stock_supply = @stock.where(:packages_size => task_supply_in_common_unit)
            if @stock_supply.size > 0
              task.update(:status => 1)
            end
          end
        end
      end
    end
  end

 #Copy of method from Application Controller...  should be moved to #Lib?
 def self.convert_unit(type, value)

    #Converts to smallest unit
    type = type.to_i
    value = value.to_f

    puts case type

    #Pieces
    when 1
      return 1 * value
    #Weights
    when 2
      return (1000000000 * value).to_f
    when 3
      return (1000000 * value).to_f
    when 4
      return (1000 * value).to_f
    when 5
      return (1 * value).to_f
    #Length
    when 6
      return (1000000 * value).to_f
    when 7
      return (1000 * value).to_f
    when 8
      return (10 * value).to_f
    when 9
      return (1 * value).to_f
    #Liquids
    when 10
      return (1000000 * value).to_f
    when 11
      return (100000 * value).to_f
    when 12
      return (10000 * value).to_f
    when 13
      return (1000 * value).to_f
    when 14
      return (100 * value).to_f
    when 15
      return (10 * value).to_f
    when 16
      return (1 * value).to_f
    end
  end


end
