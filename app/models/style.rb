class Style < ApplicationRecord
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  def self.top(num)
    sorted_by_rating_in_desc_order = Style.all.sort_by{ |b| -(b.average_rating || 0) }
    # palauta listalta parhaat n kappaletta
    # miten? ks. http://www.ruby-doc.org/core-2.5.1/Array.html
    sorted_by_rating_in_desc_order[0..num - 1]
  end

  def to_s
    name.to_s
  end
end
