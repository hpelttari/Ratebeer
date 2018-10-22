class Style < ApplicationRecord
  include RatingAverage
  extend Top

  has_many :beers
  has_many :ratings, through: :beers

  def to_s
    name.to_s
  end
end
