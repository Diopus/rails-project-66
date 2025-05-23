# Preview all emails at http://localhost:3000/rails/mailers/repository/check_mailer
class Repository::CheckMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/repository/check_mailer/check_failed
  def check_failed
    Repository::CheckMailer.check_failed
  end

  # Preview this email at http://localhost:3000/rails/mailers/repository/check_mailer/offenses_found
  def offenses_found
    Repository::CheckMailer.offenses_found
  end
end
