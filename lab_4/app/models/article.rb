class Article < ApplicationRecord
  belongs_to :user
  has_many :reports

  validates :body, :title, presence: true
  mount_uploader :image, ImageUploader

  after_save :check_reports_count

  private

  def check_reports_count
    if reports_count >= 3 && !archived
      update_column(:archived, true)
    end
  end
end
