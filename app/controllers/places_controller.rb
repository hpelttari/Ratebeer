class PlacesController < ApplicationController
  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:city_searched] = params[:city]
      render :index
    end
  end

  def show
    city = session[:city_searched].downcase
    bar_id = params[:id]
    Rails.cache.read(city).each do |bar|
      if bar.id == bar_id
        @place = bar
      end
    end
  end
end
