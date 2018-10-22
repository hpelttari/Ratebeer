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

  def self.github_signin(github_user)
    nick = github_user.nickname
    git_user = User.find_by_username(nick)

    if git_user
      git_user
    else
      password = SecureRandom.base64(25)
      User.create!(username: nick, password: password, password_confirmation: password, active:true)
    end
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    favorite(:style)
  end

  def favorite_brewery
    favorite(:brewery)
  end

  def favorite(groupped_by)
    return nil if ratings.empty?

    grouped_ratings = ratings.group_by{ |r| r.beer.send(groupped_by) }
    averages = grouped_ratings.map do |group, ratings|
      { group: group, score: average_of(ratings) }
    end

    averages.max_by{ |r| r[:score] }[:group]
  end

  def average_of(ratings)
    ratings.sum(&:score).to_f / ratings.count
  end

  def self.most_active(num)
    sorted_by_number_of_ratings_in_desc_order = User.all.sort_by{ |b| -(b.ratings.count || 0) }
    # palauta listalta parhaat n kappaletta
    # miten? ks. http://www.ruby-doc.org/core-2.5.1/Array.html
    sorted_by_number_of_ratings_in_desc_order[0..num - 1]
  end

  def to_s
    username.to_s
  end
end
