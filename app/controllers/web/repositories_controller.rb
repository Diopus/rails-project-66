# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    before_action :authenticate_user!, only: %i[index show new create]
    before_action :set_repository, only: %i[show]

    # GET /repositories or /repositories.json
    def index
      @repositories = current_user.repositories
    end

    # GET /repositories/1 or /repositories/1.json
    def show
      authorize @repository
    end

    # GET /repositories/new
    def new
      @repository = Repository.new
      @repositories_list = fetch_repositories_list
    end

    # POST /repositories or /repositories.json
    def create
      flag_update = true

      @repository = current_user.repositories.find_or_initialize_by(repository_params)
      if @repository.persisted?
        flash[:warning] = I18n.t('repositories.crud.create.exists')
        redirect_to repositories_path
        return
      end

      if @repository.save
        redirect_to repositories_path, notice: I18n.t('repositories.crud.create.success')
      else
        flash[:alert] = I18n.t('repositories.crud.create.failure')
        render :new, status: :unprocessable_entity
        flag_update = false
      end

      UpdateRepositoryInfoJob.perform_later(@repository.id) if flag_update
    end

    private

    def fetch_repositories_list
      client = Octokit::Client.new(access_token: current_user.token)
      Github::Repositories::FetchListService.new(client:).call
    end

    def repository_params
      params.require(:repository).permit(:github_id)
    end

    def set_repository
      @repository = Repository.find(params[:id])
    end
  end
end
