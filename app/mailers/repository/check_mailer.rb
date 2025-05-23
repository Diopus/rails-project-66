class Repository::CheckMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.repository.check_mailer.check_failed.subject
  #
  def check_failed
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.repository.check_mailer.offenses_found.subject
  #
  def offenses_found
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
