extends HBoxContainer


onready var inventory = preload("res://Inventory/Inventory.tres")

onready var itemTexture = get_node("CraftingSection/ItemTexture")

onready var recipes = $Recipes
onready var RecipeContainer = preload("res://Recipes/RecipeContainer.tscn")

var currentlySelected = null
var previouslySelected = null

"""Adds all the Recipes to the Recipe Section
Connects the Signal for detecting when one got selected"""
func _ready():
	for x in range(Recipes.allRecipes.size()):
		var newRecipeContainer = RecipeContainer.instance()
		newRecipeContainer.item = Recipes.allRecipes[x]
		newRecipeContainer.connect("recipe_selected", self, "_on_recipe_selected")
		recipes.add_child(newRecipeContainer)
	
func updateItemTexture():
	itemTexture.texture = recipes.get_child(currentlySelected).item.product.texture
	
func _on_CraftButton_pressed():
	inventory.add(recipes.get_child(currentlySelected).item.product)
	
"""When a Recipe gets selected, the previously selected one gets deselected
The Item Texture gets updated"""
func _on_recipe_selected(index):
		currentlySelected = index
		if previouslySelected != null and previouslySelected != currentlySelected:
			recipes.get_child(previouslySelected).deselect()
		updateItemTexture()
		previouslySelected = currentlySelected
