# frozen_string_literal: true

module Api
  class ChecksController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      github_id = params[:repository][:id]
      repository = Repository.find_by(github_id:)
      handle_error("No repository found with ID #{github_id}") unless repository

      @check = repository.checks.build
      if @check.save
        CheckRepositoryJob.perform_later(@check.id)
        head :ok
      else
        handle_error(@check.errors.full_messages)
      end
    end

    private

    def handle_error(error)
      Rails.logger.error(error)
      head :unprocessable_entity
    end
  end
end
