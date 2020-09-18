class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :user_id, presence: true
  validates :content, presence: true,
            length: {maximum: Settings.validates.micropost.max_length_content}
  validates :image,
            content_type: {in: %w(Settings.validates.micropost.image_type)
              .join(","),
                           message: I18n.t("global.valid_image_format")},
            size: {less_than: Settings.validates.micropost.image_max.megabytes,
                   message: I18n.t("global.valid_image_size")}

  scope :order_created_at, ->{order created_at: :desc}
  scope :user_microposts, ->(user_ids){where user_id: user_ids}

  delegate :name, to: :user, prefix: true

  def display_image
    image.variant resize_to_limit: [Settings.validates.micropost.size_limit,
                                    Settings.validates.micropost.size_limit]
  end
end
