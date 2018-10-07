require 'rails_helper'

include Helpers

describe "Beers page" do
    let!(:user) { FactoryBot.create :user }
    let!(:brewery) { FactoryBot.create :brewery, name:"Panimo", year: 2001 }
    let!(:style) {FactoryBot.create :style, name: "Weizen"}
    
        #FactoryBot.create(:brewery, name: "Panimo", year: 2001)
    

    describe "if user is logged in" do
        before :each do
            visit signin_path
            fill_in('username', with:'Pekka')
            fill_in('password', with:'Foobar1')
            click_button('Log in')
        end
    it "should have the possibility to add a beer" do
        
        visit beers_path
        click_link "New Beer"
        fill_in('beer[name]', with:'Kalja')
        #select('Weizen', from: 'beer[style_id]')
        select('Panimo', from: 'beer[brewery_id]')
        expect{
            click_button "Create Beer"
          }.to change{Beer.count}.from(0).to(1)
    end

    it "should not create a beer with an invalid name" do
        
        visit new_beer_path
        expect{
            click_button "Create Beer"
          }.not_to change{Beer.count}
        expect(page).to have_content "Name can't be blank"
        end

    end
end