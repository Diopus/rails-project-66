# frozen_string_literal: true

module Authentication
  def authenticate_user!
    return if user_signed_in?

    flash[:danger] = t('auth.req_log_in')
    redirect_back(fallback_location: root_path)
  end

  def authenticate_admin!
    return if current_user&.admin?

    flash[:danger] = t('auth.req_admin')
    redirect_back(fallback_location: root_path)
  end

  def current_user
    @current_user ||= session[:user_id] && User.find_by(id: session[:user_id])
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session.delete(:user_id)
    @current_user = nil
  end

  def user_signed_in?
    session[:user_id].present? && current_user.present?
  end
end
