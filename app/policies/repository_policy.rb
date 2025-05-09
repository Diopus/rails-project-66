# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def check?
    owner?
  end

  def show?
    owner?
  end

  private

  def owner?
    user&.id == record.user_id
  end
end
