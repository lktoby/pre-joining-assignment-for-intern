module SessionsHelper
  def log_in(user)
    session[:identifier] = user.identifier
  end

  def current_user
    @current_user ||= UserAuthentication.find_by(
      identifier: session[:identifier]
    )
  end

  def logged_in?
    !current_user.nil?
  end

end