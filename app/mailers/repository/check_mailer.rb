# frozen_string_literal: true

class Repository::CheckMailer < ApplicationMailer
  STYLE_GUIDES = {
    'ruby' => 'https://rubystyle.guide/',
    'javascript' => 'https://github.com/airbnb/javascript/blob/master/README.md'
  }.freeze

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.repository.check_mailer.check_failed.subject
  #
  def check_failed
    @failure_reason = params[:message]

    check = params[:check]
    @check_id = check.id

    repo = check.repository
    @repo_name = repo.full_name
    @user = repo.user

    @check_url = repository_check_url(repo, check)

    mail(
      to: email_address_with_name(@user.email, @user.nickname),
      subject: t('.subject', repo: @repo_name, check_id: @check_id)
    )
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.repository.check_mailer.offenses_found.subject
  #
  def offenses_found
    check = params[:check]
    @check_id = check.id
    @count = check.offenses.count

    repo = check.repository
    @repo_name = repo.full_name
    @user = repo.user

    @check_url = repository_check_url(repo, check)

    key = repo.language.to_s.downcase
    @style_guide = STYLE_GUIDES[key] or t('.unknown_style_guide')

    mail(
      to: email_address_with_name(@user.email, @user.nickname),
      subject: t('.subject', repo: @repo_name, check_id: @check_id)
    )
  end
end
