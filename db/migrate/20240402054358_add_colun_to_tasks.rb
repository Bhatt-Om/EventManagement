class AddColunToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :task_lat, :float, default: 0.0
    add_column :tasks, :task_lon, :float, default: 0.0
  end
end
