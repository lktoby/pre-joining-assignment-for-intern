class SessionsController < ApplicationController
  def new
    if session[:identifier]
      render json: { status: "authenticated" }, status: :ok
    else
      render json: { status: "unauthenticated" }, status: :ok
    end
  end
  def create
    if session[:identifier]
      render json: { error: "すでにサインイン済みです"}
      return
    end
    current_user ||= UserAuthentication.find_by(
      identifier: session_params[:identifier]
    )
    if current_user&.authenticate(session_params[:password])
      log_in(current_user)
      render json: { status: "authenticated" }, status: :ok
    else
      render json: { error: "ユーザー識別子またはパスワードが誤っています"}, status: :unauthorized
    end
  end
  private
  def session_params
    params.require(:session).permit(:identifier, :password)
  end
end
