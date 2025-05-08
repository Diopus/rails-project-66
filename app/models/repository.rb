# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user, inverse_of: :repositories
  has_many :checks, class_name: 'Repository::Check', inverse_of: :repository, dependent: :destroy

  validates :github_id, presence: true, uniqueness: true

  enumerize :language, in: [:Ruby] # [:Ruby, :JavaScript]
end
