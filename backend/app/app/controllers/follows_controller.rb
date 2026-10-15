class FollowsController < ApplicationController
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
    target_user_id = params[:target_user_id]
    if user_id == target_user_id.to_i
      render json: { error: "自分自身をフォローすることはできません" }, status: :unprocessable_entity
      return
    end
    @target_user = User.find_by(id: target_user_id)
    if @target_user.nil?
      render json: { error: "ユーザーが見つかりません" }, status: :not_found
      return
    end
    if Follow.exists?(user_id: user_id, target_user_id: target_user_id)
      render json: { error: "すでにフォローしています" }, status: :unprocessable_entity
      return
    end
    @follow = Follow.new(
      user_id: user_id,
      target_user_id: target_user_id
    )
    @follow.save!
    render json: { user: { id: @target_user.id, is_following: true}}, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotUnique => e
    render json: { error: "すでにフォローしています" }, status: :unprocessable_entity
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
    target_user_id = params[:target_user_id]
    @target_user = User.find_by(id: target_user_id)
    if @target_user.nil?
      render json: { error: "ユーザーが見つかりません" }, status: :not_found
      return
    end
    @follow = Follow.find_by(user_id: user_id, target_user_id: target_user_id)
    if @follow.nil?
      render json: { error: "フォローしていません" }, status: :not_found
      return
    end
    @follow.destroy!
    render json: { user: { id: @target_user.id, is_following: false }}, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end
end
