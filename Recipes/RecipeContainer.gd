extends HBoxContainer


onready var selected = $Selected
onready var itemTexture = $ItemTexture

onready var ingredientTextures = get_node("IngredientsAmount/Ingredients")
onready var ingredientNames = get_node("IngredientsAmount/IngredientNames")
onready var ingredientAmounts = get_node("IngredientsAmount/Amount")

onready var description = get_node("IngredientsAmount/Description/Description")

onready var item = preload("res://Recipes/Pickaxe.tres")

var currentlyActive = false

func _ready():
	setTextures()
	setNames()
	setAmounts()
	setDescription()
	
func setTextures():
	if item.product != null:
		itemTexture.texture = item.product.texture
	for x in range(item.ingredients.size()):
		if item.ingredients[x] != null:
			ingredientTextures.get_child(x).texture = item.ingredients[x].texture
		else:
			ingredientTextures.get_child(x).texture = null
	
func setNames():
	for x in range(item.ingredients.size()):
		if item.ingredients[x] != null:
			ingredientNames.get_child(x).name = item.ingredients[x].name
		else:
			ingredientNames.get_child(x).name = ""
	
func setAmounts():
	for x in range(item.ingredientAmounts.size()):
		if item.ingredients[x] != null:
			ingredientAmounts.get_child(x).text = str(item.ingredientAmounts[x])
		else:
			ingredientAmounts.get_child(x).text = null
	
func setDescription():
	description.text = item.description
	
func _on_HBoxContainer_gui_input(_event):
	if Input.is_action_just_pressed("mouse_left"):
		if(currentlyActive):
			selected.hide()
			currentlyActive = false
		else:
			selected.show()
			currentlyActive = true
