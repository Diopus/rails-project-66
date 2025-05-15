# frozen_string_literal: true

class Repository::Offense < ApplicationRecord
  belongs_to :check, class_name: 'Repository::Check', counter_cache: true, inverse_of: :offenses
end
