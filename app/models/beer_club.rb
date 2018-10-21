class BeerClub < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  def is_member(user)
    users.each do |usr|
      if user == usr
        return true
      end
    end
    return false
  end


end
