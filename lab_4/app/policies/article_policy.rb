class ArticlePolicy < ApplicationPolicy
  def index?
    true # Everyone can view the index
  end

  def show?
    true # Everyone can view articles
  end

  def create?
    user.present? # Only logged in users can create
  end

  def update?
    return false unless user.present?
    user == record.user # Only article owner can update
  end

  def destroy?
    return false unless user.present?
    user == record.user # Only article owner can delete
  end
end
