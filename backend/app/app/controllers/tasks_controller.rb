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
    completion = task_query_params[:completion] || "all"
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
    unless %w[all complete incomplete].include?(completion)
      render json: { error: "不正な値が入力されています" }, status: :bad_request
      return
    end
    if type == "my"
      @has_next = Task.where(user_id: user_id).count > offset + 15 ? true : false
      @tasks = Task.includes(:user).where(user_id: user_id).order(created_at: :desc, id: :desc).limit(15).offset(offset)
      if completion == "complete"
        @has_next = Task.where(user_id: user_id, is_completed: true).count > offset + 15 ? true : false
        @tasks = Task.includes(:user).where(user_id: user_id, is_completed: true).order(created_at: :desc, id: :desc).limit(15).offset(offset)
      elsif completion == "incomplete"
        @has_next = Task.where(user_id: user_id, is_completed: false).count > offset + 15 ? true : false
        @tasks = Task.includes(:user).where(user_id: user_id, is_completed: false).order(created_at: :desc, id: :desc).limit(15).offset(offset)
      end
      if @tasks.count == 0
        render json: { tasks: [], has_next: false }, status: :ok
        return
      end
      render json: {tasks: @tasks.as_json(include: {user: {only: [:id, :name]}}), has_next: @has_next}, status: :ok
      return
    elsif type == "others"
      @has_next = Task.where.not(user_id: user_id).count > offset + 15 ? true : false
      @tasks = Task.includes(:user).where.not(user_id: user_id).order(created_at: :desc, id: :desc).limit(15).offset(offset)
      if completion == "complete"
        @has_next = Task.where.not(user_id: user_id).where(is_completed: true).count > offset + 15 ? true : false
        @tasks = Task.includes(:user).where.not(user_id: user_id).where(is_completed: true).order(created_at: :desc, id: :desc).limit(15).offset(offset)
      elsif completion == "incomplete"
        @has_next = Task.where.not(user_id: user_id).where(is_completed: false).count > offset + 15 ? true : false
        @tasks = Task.includes(:user).where.not(user_id: user_id).where(is_completed: false).order(created_at: :desc, id: :desc).limit(15).offset(offset)
      end
      if @tasks.count == 0
        render json: { tasks: [], has_next: false }, status: :ok
        return
      end
      render json: {tasks: @tasks.as_json(include: {user: {only: [:id, :name]}}), has_next: @has_next}, status: :ok
      return
    else
      render json: { error: "不正な値が入力されています" }, status: :bad_request
      return
    end
  end

  def complete
    if session[:identifier].nil?
      render json: { error: "サインインしていません" }, status: :unauthorized
      return
    end
    @user = UserAuthentication.find_by(identifier: session[:identifier])
    if @user.nil?
      render json: { error: "サインインしていません" }, status: :unauthorized
      return
    elsif @user.identifier != session[:identifier]
      render json: { error: "ユーザーが見つかりません" }, status: :not_found
      return
    end
    @task = Task.find_by(id: task_put_params[:task_id], user_id: @user.user_id)
    if @task.nil?
      render json: { error: "タスクが見つかりません" }, status: :not_found
      return
    else
      @task.update!(is_completed: true)
      render json: { task: @task.as_json(only: [:id, :is_completed]) }, status: :ok
    end
  end

  def incomplete
    if session[:identifier].nil?
      render json: { error: "サインインしていません" }, status: :unauthorized
      return
    end
    @user = UserAuthentication.find_by(identifier: session[:identifier])
    if @user.nil?
      render json: { error: "サインインしていません" }, status: :unauthorized
      return
    elsif @user.identifier != session[:identifier]
      render json: { error: "ユーザーが見つかりません" }, status: :not_found
      return
    end
    @task = Task.find_by(id: task_put_params[:task_id], user_id: @user.user_id)
    if @task.nil?
      render json: { error: "タスクが見つかりません" }, status: :not_found
      return
    else
      @task.update!(is_completed: false)
      render json: { task: @task.as_json(only: [:id, :is_completed]) }, status: :ok
    end
  end

  private
  def task_params
    params.require(:task).permit(:body)
  end
  def task_query_params
    params.permit(:type, :page, :completion)
  end
  def task_put_params
    params.permit(:task_id)
  end
end
