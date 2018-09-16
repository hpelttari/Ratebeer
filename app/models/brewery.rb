class Brewery < ApplicationRecord
  include RatingAverage

    has_many :beers, dependent: :destroy
    has_many :ratings, through: :beers

    def print_report
        puts name
        puts "established at year #{year}"
        puts "number of beers #{beers.count}"
      end
    
      def restart
        self.year = 2018
        puts "changed year to #{year}"
      end

      def average_rating
        number_of_ratings = ratings.count.to_f
        sum=ratings.map(&:score).inject(0,&:+)
        return sum/number_of_ratings
    end

      def to_s
        "#{name}"
      end
end
