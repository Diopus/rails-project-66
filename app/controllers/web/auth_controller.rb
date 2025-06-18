# frozen_string_literal: true

module Web
  class AuthController < ApplicationController
    def callback
      auth_hash = request.env['omniauth.auth']

      user = User.find_or_initialize_by(email: auth_hash['info']['email'])
      user.nickname = auth_hash['info']['nickname']
      user.token = auth_hash['credentials']['token']

      if user.save
        sign_in(user)
        redirect_to root_path, notice: I18n.t('auth.signed_in')
      else
        redirect_to root_path, alert: I18n.t('auth.error')
      end
    end

    def logout
      sign_out
      redirect_to root_path, notice: I18n.t('auth.signed_out')
    end
  end
end
