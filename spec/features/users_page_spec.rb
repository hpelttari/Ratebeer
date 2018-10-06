require 'rails_helper'

include Helpers

describe "User" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:brewery1) { FactoryBot.create :brewery, name:"Malmgard" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:beer3) { FactoryBot.create :beer, name:"X Porter", brewery: brewery1, style: "Porter" }
  let!(:user) { FactoryBot.create :user }
  let!(:user1) { FactoryBot.create :user, username: "Käyttäjä", password: "Salasana1", password_confirmation: "Salasana1" }
  let!(:rating1) { FactoryBot.create :rating, score: 5, beer: beer1, user: user }
  let!(:rating2) { FactoryBot.create :rating, score: 10, beer: beer2, user: user }
  let!(:rating3) { FactoryBot.create :rating, score: 8, beer: beer2, user: user1 }
  let!(:rating4) { FactoryBot.create :rating, score: 1, beer: beer3, user: user }


  describe "who has signed up" do
    it "can signin with right credentials" do
      visit signin_path
      fill_in('username', with:'Pekka')
      fill_in('password', with:'Foobar1')
      click_button('Log in')

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end
    describe "and is logged in" do
      before :each do
        visit signin_path
        fill_in('username', with:'Pekka')
        fill_in('password', with:'Foobar1')
        click_button('Log in')
      end

      it "can see their favorite style" do
        visit user_path(user)
        expect(page).to have_content 'Favorite style: Lager'
      end

      it "can see their favorite brewery" do
        visit user_path(user)
        expect(page).to have_content 'Favorite brewery: Koff'
      end

      it "can delete their rating" do
        visit user_path(user)
        expect{
        find(:xpath, "/html/body/ul[1]/li[1]/a").click
      }.to change{Rating.count}.from(4).to(3)
      end

      it "can see their own ratings if" do

        visit user_path(user)
        expect(page).to have_content 'Number of ratings:3'
        expect(page).to have_content 'Average rating:5.333333333333333'
        expect(page).to have_content 'iso 3 5 delete'
        expect(page).to have_content 'Karhu 10 delete'
        expect(page).to have_content 'X Porter 1 delete'
        expect(page).not_to have_content 'Karhu 8 delete'

      end
    end

    it "is redirected back to signin form if wrong credentials given" do
        visit signin_path
        fill_in('username', with:'Pekka')
        fill_in('password', with:'wrong')
        click_button('Log in')
  
        expect(current_path).to eq(signin_path)
        expect(page).to have_content 'Username and/or password mismatch'
      end

      it "when signed up with good credentials, is added to the system" do
        visit signup_path
        fill_in('user_username', with:'Brian')
        fill_in('user_password', with:'Secret55')
        fill_in('user_password_confirmation', with:'Secret55')
      
        expect{
          click_button('Create User')
        }.to change{User.count}.by(1)
      end
  end

  
end