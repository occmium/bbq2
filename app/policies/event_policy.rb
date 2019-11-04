class EventPolicy < ApplicationPolicy
  def show?
    true
  end

  def edit?
    update?
  end

  def update?
    is_authorise_user?(record)
  end

  def destroy?
    update?
  end

  def new?
    user.present?
  end

  def is_authorise_user?(event)
    user.present? && (event.try(:user) == user)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
