# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    before_action :authenticate_user!, only: %i[index show new create]
    before_action :set_repository, only: %i[show]

    def index
      @repositories = current_user.repositories
    end

    def show
      authorize @repository
    end

    def new
      @repository = Repository.new
      @repositories_list = fetch_repositories_list
    end

    def create
      @repository = current_user.repositories.find_or_initialize_by(repository_params)
      if @repository.persisted?
        flash[:warning] = I18n.t('repositories.crud.create.exists')
        redirect_to repositories_path
        UpdateRepositoryInfoJob.perform_later(@repository.id)
        return
      end

      if @repository.save
        redirect_to repositories_path, notice: I18n.t('repositories.crud.create.success')
        UpdateRepositoryInfoJob.perform_later(@repository.id, add_webhook: true)
      else
        flash[:alert] = I18n.t('repositories.crud.create.failure')
        render :new, status: :unprocessable_entity
      end
    end

    private

    def fetch_repositories_list
      client = ApplicationContainer[:octokit_client][current_user.token]
      ::Repositories::FetchListService.new(client:).call
    end

    def repository_params
      params.require(:repository).permit(:github_id)
    end

    def set_repository
      @repository = Repository.find(params[:id])
    end
  end
end
