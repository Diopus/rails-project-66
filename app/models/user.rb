# frozen_string_literal: true

class User < ApplicationRecord
  has_many :repositories, inverse_of: :user, dependent: :destroy
end
