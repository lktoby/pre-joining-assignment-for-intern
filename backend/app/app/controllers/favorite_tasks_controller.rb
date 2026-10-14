class FavoriteTasksController < ApplicationController
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
    task_id = params[:task_id]
    @task = Task.find_by(id: task_id)
    if @task.nil?
      render json: { error: "タスクが見つかりません" }, status: :not_found
      return
    end
    if @task.user_id == user_id
      render json: { error: "自分のタスクはお気に入り登録できません" }, status: :unprocessable_entity
      return
    end
    if FavoriteTask.exists?(user_id: user_id, task_id: task_id)
      render json: { error: "すでにお気に入り登録されています" }, status: :unprocessable_entity
      return
    end
    @favorite_task = FavoriteTask.new(
      user_id: user_id,
      task_id: task_id
    )
    @favorite_task.save!
    render json: { task: { id: @task.id, is_favorited: true }}, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotUnique => e
    render json: { error: "すでにお気に入り登録されています" }, status: :unprocessable_entity
  end

  def destroy
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
    task_id = params[:task_id]
    @task = Task.find_by(id: task_id)
    if @task.nil?
      render json: { error: "タスクが見つかりません" }, status: :not_found
      return
    end
    @favorite_task = FavoriteTask.find_by(user_id: user_id, task_id: task_id)
    if @favorite_task.nil?
      render json: { error: "お気に入り登録されていません" }, status: :not_found
      return
    end
    @favorite_task.destroy!
    render json: { task: { id: @task.id, is_favorited: false }}, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end
end
