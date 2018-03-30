class Micropost < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.length.maximum}
  validate :picture_size, :user

  scope :desc, ->{order created_at: :desc}

  mount_uploader :picture, PictureUploader

  private

  def picture_size
    errors.add :picture, I18n.t("alert") if
      Settings.max_picture.maximum.megabytes < picture.size
  end
end
