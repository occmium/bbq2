class EventPolicy < ApplicationPolicy
  def show?
    pincode?(record)
  end

  def edit?
    update?
  end

  def update?
    is_authoise_user?(record)
  end

  def destroy?
    update?
  end

  def new?
    user.present?
  end

  def pincode?(event)
    event.pincode.blank? ||
    (user.present? && (event.try(:user) == user))
  end

  def is_authoise_user?(event)
    user.present? && (event.try(:user) == user)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
