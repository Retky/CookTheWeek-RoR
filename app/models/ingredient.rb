class Ingredient < ApplicationRecord
  before_validation :sanitize_name

  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients
  has_many :shop_list_ingredients, dependent: :destroy
  has_many :shop_lists, through: :shop_list_ingredients

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  # Capitalize the first letter & remove any punctuation
  def sanitize_name
    return if name.blank?

    self.name = name.downcase.gsub(/[^a-zA-Z0-9 ]/, '').strip.capitalize
  end
end
