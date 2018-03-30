class Micropost < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.length.maximum}
  validate :picture_size, :user

  scope :desc, ->{order created_at: :desc}
<<<<<<< 50cd71ea67d7dafd55daf3e217e709409141de5d
=======
  scope :following_ids, (lambda do |user|
    following_ids = "SELECT followed_id FROM relationships
      WHERE follower_id = :user_id"
    where "user_id IN (#{following_ids}) OR user_id = :user_id",
      user_id: user.id
  end)
>>>>>>> chap12

  mount_uploader :picture, PictureUploader

  private

  def picture_size
    errors.add :picture, I18n.t("alert") if
      Settings.max_picture.maximum.megabytes < picture.size
  end
end
