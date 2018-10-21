class RatingsController < ApplicationController
  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def index
    # Cache everything individually and fetch if cached
    @top_beers = Rails.cache.fetch('top_beers') { Beer.top 3 }
    @ratings = Rating.all
    @top_breweries = Rails.cache.fetch('top_breweries') { Brewery.top 3 }
    # @top_beers = Beer.top 3
    @most_recent_ratings = Rails.cache.fetch('recent_ratings') { Rating.recent }
    @top_styles = Rails.cache.fetch('top_styles') { Style.top 3 }
    @most_active_users = Rails.cache.fetch('active_users') { User.most_active 3 }
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def destroy
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
