class User < ApplicationRecord
  include RatingAverage

  has_secure_password
  has_many :ratings, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
  has_many :beers, through: :ratings

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }
  validates :password, length: { minimum: 4 }, format: { with: /\A(?=.*\d)(?=.*[A-Z])/x }

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    find_highest_average_for_styles
  end

  def favorite_brewery
    return nil if ratings.empty?

    find_highest_average_for_breweries.name
  end

  def average_rating_of_brewery(brew)
    ratings.find_all{ |r| r.beer.brewery.id == brew.id }.map(&:score).inject(0, &:+) / ratings.find_all{ |r| r.beer.brewery.id == brew.id }.count.to_f
  end

  def average_rating_of_style(beer_style)
    ratings.find_all{ |r| r.beer.style == beer_style }.map(&:score).inject(0, &:+) / ratings.find_all{ |r| r.beer.style == beer_style }.count.to_f
  end

  def list_styles
    ratings.map{ |r| r.beer.style }.uniq
  end

  def list_breweries
    ratings.map{ |r| r.beer.brewery }.uniq
  end

  def find_highest_average_for_styles
    list = list_styles
    list.max { |a, b| average_rating_of_style(a) <=> average_rating_of_style(b) }
  end

  def find_highest_average_for_breweries
    list = list_breweries
    list.max { |a, b| average_rating_of_brewery(a) <=> average_rating_of_brewery(b) }
  end
end
