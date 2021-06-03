extends HBoxContainer


onready var inventory = preload("res://Inventory/Inventory.tres")

onready var recipes = $Recipes
onready var RecipeContainer = preload("res://Recipes/RecipeContainer.tscn")

func _ready():
	var recipeContainer = RecipeContainer.instance()
	recipes.add_child(recipeContainer)
	var recipeContainerr = RecipeContainer.instance()
	recipes.add_child(recipeContainerr)
	var recipeContainerrr = RecipeContainer.instance()
	recipes.add_child(recipeContainerrr)


func _on_CraftButton_pressed():
	inventory.add(recipes.get_child(0).item.product)
