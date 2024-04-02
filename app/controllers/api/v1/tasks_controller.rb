class Api::V1::TasksController < ApplicationController
  before_action :only_for_admin, only: [:create, :update]
  
  def index
    if current_user
      tasks_ids  = current_user.tasks.pluck(:id)
      tasks = Task.includes(event_poster_attachment: :blob).all.order(id: :desc)
      tasks = Task.includes(event_poster_attachment: :blob).where.not(id: tasks_ids).order(id: :desc) if tasks_ids.any?
      render json: { message: 'All Task List', tasks: tasks, success: true }, status: 200
    else
      render json: { message: 'User Not Found', tasks: tasks, success: true }, status: 401
    end
  end

  def create
    task = Task.new(task_params)
    if task.save
      render json: { message: 'Task Created Successfully', success: true }, status: 201
    else
      render json: { message: task.errors.full_messages.join(','), success: false },  status: 422
    end
  end

  def update
    task = Task.find_by(id: params[:id])
    if task&.update(task_params)
      render json: { message: "#{task.event_name} updated successfully", success: true }, status: 200
    else
      render json: { message: task.errors.full_messages.join(','), success: false }, status: 422
    end
  end

  def destroy
    task = Task.find_by(id: params[:id])
    if task
      task.destroy
      render json: {message: 'Task Deleted SuccessFully', success: true }, status: 200
    else
      render json: {message: task.errors.full_messages.join(','), success: false }, status: 404
    end
  end

  private

  def task_params
    params.require(:task).permit(:event_name, :event_location, :google_link, :date, :time, :other_instruction, :points, :task_lat, :task_lon, :event_poster)
  end
end
