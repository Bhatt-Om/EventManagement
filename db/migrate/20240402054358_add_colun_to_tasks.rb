class AddColunToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :task_lat, :string, default: '0'
    add_column :tasks, :task_lon, :string, default: '0'
  end
end
