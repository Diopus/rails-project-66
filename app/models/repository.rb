# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  REPOSITORIES_LIST_CACHE_KEY_PREFIX = 'github-repos'

  def self.cache_key_for_user_repos(user_id)
    "#{REPOSITORIES_LIST_CACHE_KEY_PREFIX}/#{user_id}"
  end

  belongs_to :user, inverse_of: :repositories
  has_many :checks, class_name: 'Repository::Check', inverse_of: :repository, dependent: :destroy

  validates :github_id, presence: true, uniqueness: true

  enumerize :language, in: %i[ruby javascript]

  private

  def invalidate_cache
    Rails.cache.delete(self.class.cache_key_for_user_repos(user_id))
  end
end
