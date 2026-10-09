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

  def index
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
    type = task_query_params[:type] || "my"
    begin
      page = task_query_params[:page].nil? ? 1 : Integer(task_query_params[:page])
    rescue ArgumentError
      render json: { error: "不正な値が入力されています" }, status: :bad_request
      return
    end
    if page < 1
      render json: { error: "不正な値が入力されています" }, status: :bad_request
      return
    end
    offset = (page - 1) * 15
    if type == "my"
      @has_next = Task.where(user_id: user_id).count > offset + 15 ? true : false
      @tasks = Task.includes(:user).where(user_id: user_id).order(created_at: :desc, id: :desc).limit(15).offset(offset)
      if @tasks.count == 0
        render json: { tasks: [], has_next: false }, status: :ok
        return
      end
      render json: {tasks: @tasks.as_json(include: {user: {only: [:id, :name]}}), has_next: @has_next}, status: :ok
    elsif type == "others"
      @has_next = Task.where.not(user_id: user_id).count > offset + 15 ? true : false
      @tasks = Task.includes(:user).where.not(user_id: user_id).order(created_at: :desc, id: :desc).limit(15).offset(offset)
      if @tasks.count == 0
        render json: { tasks: [], has_next: false }, status: :ok
        return
      end
      render json: {tasks: @tasks.as_json(include: {user: {only: [:id, :name]}}), has_next: @has_next}, status: :ok
    else
      render json: { error: "不正な値が入力されています" }, status: :bad_request
    end
  end

  private
  def task_params
    params.require(:task).permit(:body)
  end
  def task_query_params
    params.permit(:type, :page)
  end
end
