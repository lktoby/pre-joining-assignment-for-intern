class TasksController < ApplicationController
  def create
    if session[:identifier].nil?
      render json: { error: "サインインしていません" }, status: :unauthorized
      return
    end
    @user = UserAuthentication.find_by(identifier: session[:identifier])
    if @user.nil?
      render json: { error: "サインインしていません" }, status: :unauthorized
      return
    end
    user_id = @user.user_id
    @task = Task.new(
      body: task_params[:body],
      user_id: user_id
    )
    @task.save!
    render json: { id: @task.id }, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_entity
  end
  private
  def task_params
    params.require(:task).permit(:body)
  end
end
