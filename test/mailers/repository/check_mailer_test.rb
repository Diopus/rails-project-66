require "test_helper"

class Repository::CheckMailerTest < ActionMailer::TestCase
  test "check_failed" do
    mail = Repository::CheckMailer.check_failed
    assert_equal "Check failed", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "offenses_found" do
    mail = Repository::CheckMailer.offenses_found
    assert_equal "Offenses found", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
