# frozen_string_literal: true

require 'test_helper'

class Repository::CheckMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @check = repository_checks(:ruby)
    @repository = @check.repository
  end

  test 'should send check_failed mail when check failed' do
    mail = Repository::CheckMailer.with(check: @check).check_failed
    mail_html = mail.html_part.decoded
    mail_text = mail.text_part.decoded
    expected_mail_content_values = [@repository.name, @check.id.to_s, repository_check_url(@repository, @check)]

    assert mail.subject.include?(@repository.name)
    assert mail.to.include?(@repository.user.email)

    expected_mail_content_values.each do |value|
      assert mail_html.include?(value)
      assert mail_text.include?(value)
    end
  end

  test 'should send offenses_found mail when offenses > 0' do
    mail = Repository::CheckMailer.with(check: @check).offenses_found
    mail_text = mail.text_part.decoded
    mail_html = mail.html_part.decoded
    expected_mail_content_values = [@repository.name, @check.id.to_s, @check.offenses_count.to_s, repository_check_url(@repository, @check)]

    assert mail.subject.include?(@repository.name)
    assert mail.to.include?(@repository.user.email)

    expected_mail_content_values.each do |value|
      assert mail_text.include?(value)
      assert mail_html.include?(value)
    end
  end
end
