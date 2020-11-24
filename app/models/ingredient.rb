class Ingredient < ApplicationRecord
  has_many :doses
  validates :name, presence: true, uniqueness: true

  # def index
  #   ingredients = Ingredient.all
  #   @ingredients = ingredients.sort_by { |i| i.name }
  # end
end
