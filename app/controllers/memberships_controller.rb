class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @beer_clubs = BeerClub.all
    @membership = Membership.new
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new(membership_params)
    @membership.update_attribute(:confirmed, false)

    if @membership.save
      if current_user.memberships.find_by(beer_club_id: params[:membership][:beer_club_id]).nil?
        current_user.memberships << @membership
        redirect_to beer_club_path @membership.beer_club_id, flash[:notice] = "#{current_user.username} welcome to the club!"
      end
    else
      @beer_clubs = BeerClub.all
      render :new
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @user = User.find_by id: @membership.user_id
    @club = BeerClub.find_by id: @membership.beer_club_id
    @membership.destroy
    flash[:notice] = "Membership in #{@club.name} has ended."
    redirect_to user_path(@user)
  end

  def confirm
    membership = Membership.find(params[:id])
    membership.update_attribute :confirmed, true

    redirect_to breweries_path, notice: "Membership confirmed!"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def membership_params
    params.require(:membership).permit(:user_id, :beer_club_id)
  end
end
