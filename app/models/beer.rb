class Beer < ApplicationRecord
    include RatingAverage

    belongs_to :brewery
    has_many :ratings, dependent: :destroy

    def average_rating
        number_of_ratings = ratings.count.to_f
        sum=ratings.map(&:score).inject(0,&:+)
        return sum/number_of_ratings
    end

    def to_s
        "#{name} #{brewery.name}"
    end

end
