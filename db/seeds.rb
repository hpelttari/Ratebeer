# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
b1 = Brewery.create name: 'Koff', year: 1897
b2 = Brewery.create name: 'Malmgard', year: 2001
b3 = Brewery.create name: 'Weihenstephaner', year: 1040
s1 = Style.create name: "Lager", description: "Lager beer"
s2 = Style.create name: "Pale Ale", description: "Pale Ale beer"
s3 = Style.create name: "IPA", description: "Indian Pale Ale"
s4 = Style.create name: "Porter", description: "Porter beer"
s5 = Style.create name: "Weizen", description: "Weizen beer"

b1.beers.create name: 'Iso 3', style_id: 1
b1.beers.create name: 'Karhu', style_id: 1
b1.beers.create name: 'Tuplahumala', style_id: 1
b2.beers.create name: 'Huvila Pale Ale', style_id: 2
b2.beers.create name: 'X Porter', style_id: 4
b3.beers.create name: 'Hefeweizen', style_id: 5
b3.beers.create name: 'Helles', style_id: 1
