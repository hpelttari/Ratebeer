require 'rails_helper'

RSpec.describe Beer, type: :model do

  describe "with a name, style and brewery" do
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    let(:beer){ Beer.create name:"Kalja", brewery:test_brewery, style:"teststyle" }

    it "is saved" do
      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end
  end

  describe "without a name" do
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    let(:beer){ Beer.create brewery:test_brewery, style:"teststyle" }

    it "is not saved" do
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end

  describe "without a style" do
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    let(:beer){ Beer.create name:"Kalja", brewery:test_brewery}

    it "is not saved" do
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end
end