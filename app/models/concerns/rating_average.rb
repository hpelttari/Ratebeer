module RatingAverage
    extend ActiveSupport::Concern

    def average_rating
        number_of_ratings = ratings.count.to_f
        sum=ratings.map(&:score).inject(0,&:+)
        return sum/number_of_ratings
    end
end