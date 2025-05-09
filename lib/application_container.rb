# frozen_string_literal: true

require 'dry/container'

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register(:octokit_client) { |_user_token| OctokitClientStub.new }
    register(:open3) { Open3Stub.new }
  else
    register(:octokit_client) { |user_token| Octokit::Client.new(access_token: user_token, auto_paginate: true) }
    register(:open3) { Open3 }
  end
end
