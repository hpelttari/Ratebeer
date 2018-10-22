class BeerClub < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  def member?(user)
    users.each do |usr|
      if user == usr
        return true
      end
    end
    false
  end
end
