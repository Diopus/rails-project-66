# frozen_string_literal: true

module AuthenticationHelpers
  def sign_in(user, _options = {})
    auth_hash = {
      provider: 'github',
      uid: '12345',
      info: {
        email: user.email,
        nickname: user.nickname
      }
    }

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

    if respond_to?(:get)
      get callback_auth_url('github')
    elsif respond_to?(:visit)
      visit callback_auth_url('github')
    else
      raise 'sign_in method not supported in this context'
    end
  end

  def signed_in?
    session[:user_id].present? && current_user.present?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
