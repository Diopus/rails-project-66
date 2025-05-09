# frozen_string_literal: true

module Web
  module Repositories
    class ChecksController < ApplicationController
      before_action :authenticate_user!

      def show
        @repository = set_repository
        @check = @repository.checks.find(params[:id])

        authorize @check
      end

      def create
        @repository = set_repository
        authorize @repository, :check?

        @check = @repository.checks.build

        if @check.save
          CheckRepositoryJob.perform_later(@check.id)
          redirect_to repository_path(@repository), notice: t('checks.crud.create.success')
        else
          redirect_to repository_path(@repository), alert: t('checks.crud.create.failure')
        end
      end

      private

      def set_repository
        @repository = Repository.find(params[:repository_id])
      end
    end
  end
end
