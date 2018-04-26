class Micropost < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  acts_as_votable

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.length.maximum}
  validate :picture_size, :user

  scope :desc, ->{order created_at: :desc}
  scope :following_ids, (lambda do |user|
    following_ids = "SELECT followed_id FROM relationships
      WHERE follower_id = :user_id"
    where "user_id IN (#{following_ids}) OR user_id = :user_id",
      user_id: user.id
  end)

  mount_uploader :picture, PictureUploader

  private

  def picture_size
    errors.add :picture, I18n.t("alert") if
      Settings.max_picture.maximum.megabytes < picture.size
  end
end
