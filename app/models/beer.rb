class Beer < ApplicationRecord
  include RatingAverage
  include Top

  belongs_to :brewery, touch: true
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  validates :name, presence: true
  belongs_to :style

  def to_s
    "#{name} #{brewery.name}"
  end
end
