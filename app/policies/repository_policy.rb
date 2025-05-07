# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def show?
    owner?
  end

  private

  def owner?
    user&.id == record.user_id
  end
end
