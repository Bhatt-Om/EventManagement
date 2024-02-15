class Api::V1::TasksController < ApplicationController
  before_action :only_for_admin, only: [:create, :update]
  
  def index
    tasks = Task.all.order(id: :desc)
    render json: { message: 'All Task List', tasks: tasks, success: true }, status: 200
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
    params.require(:task).permit(:event_name, :event_location, :google_link, :date, :time, :other_instruction, :points, :event_poster)
  end
end
