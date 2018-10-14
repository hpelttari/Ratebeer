class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  validates :name, presence: true
  belongs_to :style

  def average_rating
    number_of_ratings = ratings.count.to_f
    sum = ratings.map(&:score).inject(0, &:+)
    sum / number_of_ratings
  end

  def average
    return 0 if ratings.empty?

    ratings.map(&:score).sum / ratings.count.to_f
  end

  def self.top(num)
    sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average || 0) }
    # palauta listalta parhaat n kappaletta
    # miten? ks. http://www.ruby-doc.org/core-2.5.1/Array.html
    sorted_by_rating_in_desc_order[0..num - 1]
  end

  def to_s
    "#{name} #{brewery.name}"
  end
end
