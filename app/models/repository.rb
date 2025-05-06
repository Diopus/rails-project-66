# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user, inverse_of: :repositories

  validates :github_id, presence: true, uniqueness: true

  enumerize :language, in: [:Ruby] # [:Ruby, :JavaScript]
end
