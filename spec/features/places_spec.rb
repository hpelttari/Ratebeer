require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple is returned by the API, they are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("alppila").and_return(
      [ Place.new( name:"Maltainen Riekko", id: 1 ), Place.new( name:"Alppilan Huone", id: 2 ), Place.new( name:"Paussi bar", id: 3 ), Place.new( name:"Hertta 10", id: 4 ) ]
    )

    visit places_path
    fill_in('city', with: 'alppila')
    click_button "Search"

    expect(page).to have_content "Maltainen Riekko"
    expect(page).to have_content "Alppilan Huone"
    expect(page).to have_content "Paussi bar"
    expect(page).to have_content "Hertta 10"
  end

  it "if none is returned by the API, correct notification is shown" do
    allow(BeermappingApi).to receive(:places_in).with("tyhjä").and_return(
      [ ]
    )

    visit places_path
    fill_in('city', with: 'tyhjä')
    click_button "Search"

    expect(page).to have_content "No locations in tyhjä"
  end

end