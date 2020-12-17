require 'open-uri'
require 'json'
require_relative 'cocktails.rb'

def create_item(ingredient)
  Ingredient.create!(name: ingredient)
end

# CREATING INGREDIENTS DROPDOWN LIST
puts '1. Creating ingredients list...'

url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list';
json_string = JSON.parse(open(url).read);

# Collecting each ingredient name from JSON file
json_ingredients = json_string['drinks'].map do |ingredient|
  ingredient['strIngredient1'].downcase!
end

# Adding extra custom ingredients
extra_ingredients = %w(yakult beer malibu soju sake 'coconut cream' 'candied ginger' 'brandied cherry')
ingredients = json_ingredients + extra_ingredients
ingredients.sort!

ingredients.each do |ingredient|
  create_item(ingredient)
end

puts "Finished creating #{Ingredient.all.count} ingredients!"

# CREATING COCKTAILS
# Find ingredient instance
def find_item(ingredient)
  return Ingredient.find_by(name: ingredient) ? true : false
end

# If ingredient exists, return instance else create new ingredient
def item_exist?(ingredient)
  if find_item(ingredient)
    return Ingredient.find_by(name: ingredient)
  else
    create_item(ingredient)
  end
end

puts "Creating cocktails with ingredients & doses..."

COCKTAILS.each do |cocktail|
  new_cocktail = Cocktail.create!(
    name: cocktail[:name],
  )

  dose = cocktail[:ingredients].map do |ingredient, dose|
    new_dose = Dose.create!(
      ingredient: item_exist?(ingredient.to_s),
      description: dose,
      cocktail: new_cocktail
    )
  end
  new_cocktail.doses = dose

  # Attach image from photo_url
  img = URI.open(cocktail[:photo])
  new_cocktail.photo.attach(io: img, filename: new_cocktail.name)

  new_cocktail.save
end

puts "Finished creating #{Cocktail.all.count} cocktails!"

