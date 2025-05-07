# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    before_action :authenticate_user!, only: %i[index show new create]
    before_action :set_repository, only: %i[show destroy]

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
      @repository = current_user.repositories.build(repository_params)

      if @repository.save
        UpdateRepositoryInfoJob.perform_later(@repository.id)
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

    # Use callbacks to share common setup or constraints between actions.
    def set_repository
      @repository = Repository.find(params[:id])
    end
  end
end
