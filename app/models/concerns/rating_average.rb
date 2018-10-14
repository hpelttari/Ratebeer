module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    if ratings.empty?
      0
    else
      number_of_ratings = ratings.count.to_f
      sum = ratings.map(&:score).inject(0, &:+)
      sum / number_of_ratings
    end
  end
end
