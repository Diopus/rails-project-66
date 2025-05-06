# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    before_action :set_repository, only: %i[show destroy]

    # GET /repositories or /repositories.json
    def index
      @repositories = Repository.all
    end

    # GET /repositories/1 or /repositories/1.json
    def show; end

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
        format.html { render :new, status: :unprocessable_entity }
      end
    end

       # DELETE /repositories/1 or /repositories/1.json
    def destroy
      @repository.destroy!

      respond_to do |format|
        # format.html { redirect_to repositories_path, status: :see_other, notice: 'Repository was successfully destroyed.' }
        format.json { head :no_content }
      end
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

    # Only allow a list of trusted parameters through.
    def repository_params
      params.require(:repository).permit(:name, :github_id, :full_name, :language, :clone_url, :ssh_url, :user_id)
    end
  end
end
