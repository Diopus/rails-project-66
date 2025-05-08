# frozen_string_literal: true

require 'dry/container'

class ApplicationContainer
  extend Dry::Container::Mixin

  register(:octokit_client) do |user_token|
    if Rails.env.test?
      OctokitClientStub.new
    else
      Octokit::Client.new(access_token: user_token, auto_paginate: true)
    end
  end
end
