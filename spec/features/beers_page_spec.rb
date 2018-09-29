require 'rails_helper'

include Helpers

describe "Beers page" do
    before :each do
        FactoryBot.create(:brewery, name: "Panimo", year: 2001)
    end

    it "should have the possibility to add a beer" do
        
        visit beers_path
        click_link "New Beer"
        fill_in('beer[name]', with:'Kalja')
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