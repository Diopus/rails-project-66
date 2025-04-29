# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  before_action :set_locale

  include Authentication
  # include Pundit::Authorization

  helper_method :user_signed_in?, :current_user

  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def default_url_options
    { locale: I18n.locale }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def user_not_authorized
    flash[:alert] = t('auth.not_authorized') # 'You are not authorized to perform this action.'
    redirect_back_or_to(root_path)
  end
end
