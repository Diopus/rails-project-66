# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/repository/check_mailer
class Repository::CheckMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/repository/check_mailer/check_failed
  def check_failed
    Repository::CheckMailer.with(
      check: Repository::Check.first,
      message: 'Check failed due to some reason'
    ).check_failed
  end

  # Preview this email at http://localhost:3000/rails/mailers/repository/check_mailer/offenses_found
  def offenses_found
    Repository::CheckMailer.with(
      check: Repository::Check.first
    ).offenses_found
  end
end
