# frozen_string_literal: true

require 'test_helper'
require 'dry/container/stub'

class CheckRepositoryJobTest < ActiveJob::TestCase
  test 'should finish check with 0 offenses' do
    # Standard stub of the Open3 calls from container (0 offenses)
    check = repository_checks(:ruby)
    CheckRepositoryJob.perform_now(check.id)

    check.reload
    assert check.passed
    assert check.finished?
  end

  test 'should finish check with some offenses and send offenses_found email' do
    check = repository_checks(:ruby_with_offenses)
    fake_offenses = [
      { file_path: Faker::File.file_name,
        cop_name: Faker::Adjective.negative,
        message: Faker::Lorem.sentence,
        position: '19:84' }
    ]

    mailer = Minitest::Mock.new
    Repositories::CheckFactory.stub(:call, fake_offenses) do
      Repository::CheckMailer.stub(:with, mailer) do
        mailer.expect :offenses_found, mailer
        mailer.expect :deliver_later, nil

        CheckRepositoryJob.perform_now(check.id)
      end
    end

    check.reload
    assert check.offenses.find_by(file_path: fake_offenses.first[:file_path])
    assert_not check.passed
    assert check.finished?
    mailer.verify
  end

  test 'should fail and send check_failed email' do
    check = repository_checks(:ruby_with_offenses)

    # adding custom response we need to stub container's Open3 calls
    open3 = Open3Stub.new
    open3.add_response(/rubocop/, stdout: '', exitstatus: 2)
    ApplicationContainer.enable_stubs!
    ApplicationContainer.stub(:open3, open3)

    mailer = Minitest::Mock.new
    Repository::CheckMailer.stub(:with, mailer) do
      mailer.expect :check_failed, mailer
      mailer.expect :deliver_later, nil

      CheckRepositoryJob.perform_now(check.id)
    end

    check.reload
    assert check.failed?
    mailer.verify

    ApplicationContainer.unstub
  end
end
