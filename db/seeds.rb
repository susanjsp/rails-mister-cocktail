# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'json'

require_relative 'cockails.rb'

# CREATING INGREDIENTS DROPDOWN LIST
puts '1. Creating ingredients list...'

url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list';
json_string = JSON.parse(open(url).read);

json_ingredients = json_string['drinks'].map do |ingredient|
  ingredient['strIngredient1'].capitalize
end

extra_ingredients = %w(Yakult Beer Malibu Soju Sake)
ingredients = json_ingredients + extra_ingredients

puts 'Sorting ingredients list alphabetically...'
alpha_ingredients = ingredients.sort!

alpha_ingredients.each do |ingredient|
  Ingredient.create!(name: ingredient)
end

puts "Finished creating #{Ingredient.all.count} ingredients!"

# CREATING COCKTAILS
puts "Creating cocktails..."

cocktails.each do |cocktail|
  new_cocktail = Cocktail.create!(
    name: cocktail
end

puts "Finished creating #{Cocktail.all.count} cocktails!"
