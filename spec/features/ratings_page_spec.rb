require 'rails_helper'

include Helpers

describe "Ratings page" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }
  let!(:rating1) { FactoryBot.create :rating, score: 5, beer: beer1, user: user }
  let!(:rating2) { FactoryBot.create :rating, score: 10, beer: beer2, user: user }
  it "should list all ratings" do
    expect(beer1.ratings.count).to eq(1)
    expect(beer2.ratings.count).to eq(1)
    visit ratings_path
    expect(page).to have_content "Number of ratings:2"
    expect(page).to have_content "iso 3 5 Pekka"
    expect(page).to have_content "Karhu 10 Pekka"

  end


end

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    visit signin_path
    fill_in('username', with:'Pekka')
    fill_in('password', with:'Foobar1')
    click_button('Log in')
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
end