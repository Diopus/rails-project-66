# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  aasm do
  end
  belongs_to :repository, inverse_of: :checks, touch: true
  has_many   :offenses,
             class_name: 'Repository::Offense',
             dependent: :destroy,
             inverse_of: :check,
             counter_cache: :offenses_count

  validates :status, presence: true
end
