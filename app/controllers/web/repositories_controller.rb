# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    after_commit :invalidate_cache, only: %i[create]
    before_action :authenticate_user!, only: %i[index show new create]

    def index
      @repositories = current_user.repositories
    end

    def show
      @repository = Repository.find(params[:id])
      authorize @repository
    end

    def new
      @repository = Repository.new
      @repositories_list = fetch_repositories_list
    end

    def create
      @repository = current_user.repositories.find_or_initialize_by(repository_params)

      if @repository.persisted?
        flash[:warning] = t('repositories.crud.create.exists')
      elsif @repository.save
        flash[:notice] = t('repositories.crud.create.success')
        add_webhook = true
      else
        flash[:alert] = t('repositories.crud.create.failure')
        render :new, status: :unprocessable_entity
        return
      end

      UpdateRepositoryInfoJob.perform_later(@repository.id, add_webhook:)
      redirect_to repositories_path
    end

    private

    def fetch_repositories_list
      cache_key = repositories_list_cache_key
      Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
        client = ApplicationContainer[:octokit_client][current_user.token]
        ::Repositories::FetchListService.new(client: client).call
      end
    end

    def invalidate_cache
      Rails.cache.delete(repositories_list_cache_key)
    end

    def repositories_list_cache_key
      "repositories_list/#{current_user.id}"
    end

    def repository_params
      params.require(:repository).permit(:github_id)
    end
  end
end
