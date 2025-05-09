# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository, inverse_of: :checks, touch: true
  has_many   :offenses,
             class_name: 'Repository::Offense',
             dependent: :destroy,
             inverse_of: :check,
             counter_cache: :offenses_count

  aasm whiny_transitions: false do
    state :pending, initial: true
    state :cloning, :checking, :finished, :failed

    event :clone_repo do
      transitions from: :pending, to: :cloning
    end

    event :check do
      transitions from: :cloning, to: :checking
    end

    event :finish do
      transitions from: :checking, to: :finished
    end

    event :fail do
      transitions from: %i[pending cloning checking], to: :failed
    end
  end
end
