require 'rails_helper'

describe "BeermappingApi" do
  it "When HTTP GET returns one entry, it is parsed and returned" do

    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Panimoravintola Koulu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*turku/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("turku")

    expect(places.size).to eq(1)
    place = places.first
    expect(place.name).to eq("Panimoravintola Koulu")
    expect(place.street).to eq("Eerikinkatu 18")
  end

  it "When HTTP GET returns no entries, an empty table is returned" do

    canned_answer = <<-END_OF_STRING
    <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*vantaa/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("vantaa")

    expect(places.size).to eq(0)
  end

  it "When HTTP GET returns multiple entries, they are parsed and returned" do

    canned_answer = <<-END_OF_STRING
    <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>17044</id><name>Teerenpeli</name><status>Brewery</status><reviewlink>https://beermapping.com/location/17044</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=17044&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=17044&amp;d=1&amp;type=norm</blogmap><street>Vapaudenkatu 20</street><city>Lahti</city><state></state><zip>15110</zip><country>Finland</country><phone></phone><overall>0</overall><imagecount>0</imagecount></location><location><id>18853</id><name>Teerenpeli</name><status>Brewery</status><reviewlink>https://beermapping.com/location/18853</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18853&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18853&amp;d=1&amp;type=norm</blogmap><street>Liimaajankatu 9</street><city>Lahti</city><state></state><zip>15520</zip><country>Finland</country><phone>0424 925 240</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>21526</id><name>Olu Bryki Raum</name><status>Brewery</status><reviewlink>https://beermapping.com/location/21526</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=21526&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=21526&amp;d=1&amp;type=norm</blogmap><street>Vaaljoentie 64</street><city>Honkilahti</city><state>Lansi-Suomen Laani</state><zip>27640</zip><country>Finland</country><phone>+358500122344</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>21537</id><name>Panimopaja</name><status>Brewery</status><reviewlink>https://beermapping.com/location/21537</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=21537&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=21537&amp;d=1&amp;type=norm</blogmap><street>Vasarakatu 6</street><city>Lahti</city><state>Etela-Suomen Laani</state><zip>15700</zip><country>Finland</country><phone>+358400404945</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*lahti/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("lahti")

    expect(places.size).to eq(4)
    place = places.first
    expect(place.name).to eq("Teerenpeli")
    expect(place.street).to eq("Vapaudenkatu 20")
    place = places.second
    expect(place.name).to eq("Teerenpeli")
    expect(place.street).to eq("Liimaajankatu 9")
    place = places.third
    expect(place.name).to eq("Olu Bryki Raum")
    expect(place.street).to eq("Vaaljoentie 64")
    place = places.fourth
    expect(place.name).to eq("Panimopaja")
    expect(place.street).to eq("Vasarakatu 6")

  end

  describe "in case of cache miss" do

    before :each do
      Rails.cache.clear
    end

    it "When HTTP GET returns one entry, it is parsed and returned" do
      canned_answer = <<-END_OF_STRING
  <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Panimoravintola Koulu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
  END_OF_STRING

      stub_request(:get, /.*turku/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      places = BeermappingApi.places_in("turku")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Panimoravintola Koulu")
      expect(place.street).to eq("Eerikinkatu 18")
    end

  end

  describe "in case of cache hit" do
    before :each do
      Rails.cache.clear
    end

    it "When one entry in cache, it is returned" do
      canned_answer = <<-END_OF_STRING
  <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Panimoravintola Koulu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
  END_OF_STRING

      stub_request(:get, /.*turku/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      BeermappingApi.places_in("turku")
      places = BeermappingApi.places_in("turku")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Panimoravintola Koulu")
      expect(place.street).to eq("Eerikinkatu 18")
    end
  end

end