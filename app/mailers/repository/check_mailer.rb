# frozen_string_literal: true

class Repository::CheckMailer < ApplicationMailer
  STYLE_GUIDES = {
    'ruby' => 'https://rubystyle.guide/',
    'javascript' => 'https://github.com/airbnb/javascript/blob/master/README.md'
  }.freeze

  def check_failed
    prepare(params[:check])

    @failure_reason = params[:message]

    mail_to_user(:check_failed)
  end

  def offenses_found
    prepare(params[:check])

    @count = @check.offenses.count
    language = @repo.language.to_s.downcase
    @style_guide = STYLE_GUIDES[language] or t('.unknown_style_guide')

    mail_to_user(:offenses_found)
  end

  private

  def mail_to_user(template_name)
    mail(
      to: email_address_with_name(@user.email, @user.nickname),
      subject: t(".#{template_name}.subject", repo: @repo_name, check_id: @check_id)
    )
  end

  def prepare(check)
    @check = check
    @check_id = check.id
    @repo = check.repository
    @repo_name = @repo.full_name
    @user = @repo.user
    @check_url = repository_check_url(@repo, check)
  end
end
