# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'json'
require_relative 'cocktails.rb'

def create_item(ingredient)
  Ingredient.create!(name: ingredient.downcase)
end

# CREATING INGREDIENTS DROPDOWN LIST
puts '1. Creating ingredients list...'

url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list';
json_string = JSON.parse(open(url).read);

json_ingredients = json_string['drinks'].map do |ingredient|
  ingredient['strIngredient1'].downcase!
end

extra_ingredients = %w(yakult beer malibu soju sake 'coconut cream')
ingredients = json_ingredients + extra_ingredients

ingredients.each do |ingredient|
  create_item(ingredient)
end

puts "Finished creating #{Ingredient.all.count} ingredients!"

# CREATING COCKTAILS
def find_item(ingredient)
  return Ingredient.find_by(name: ingredient.downcase) ? true : false
end

def item_exist?(ingredient)
  if find_item(ingredient)
    return Ingredient.find_by(name: ingredient.downcase)
  else
    create_item(ingredient)
  end
end

puts "Creating cocktails with ingredients & doses..."

COCKTAILS.each do |cocktail, ingredients|
  new_cocktail = Cocktail.create!(
    name: cocktail.to_s,
  )

  dose = ingredients.map do |ingredient, dose|
    # binding.byebug
    new_dose = Dose.create!(
      description: dose,
      ingredient: item_exist?(ingredient),
      cocktail: new_cocktail
    )
  end
  new_cocktail.doses = dose
end

puts "Finished creating #{Cocktail.all.count} cocktails!"

