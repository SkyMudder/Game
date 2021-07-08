extends TileMap

signal stopped_placing(placed)

onready var groundLayer = get_node("../GroundLayer")
onready var topLayer = get_node("../TopLayer")
onready var player = get_node("../KinematicBody2D")
onready var toolbar = get_node("../InventoryWrapper/CenterPlayerInventory/ToolbarDisplay")
onready var objects = get_parent().get_node("Objects")

var raycast : RayCast2D
var raycastOffset = Vector2(1, 1)

var ww = WorldVariables
var areaClear = true
var currentObject = null

# Chunk Size in Tiles
var chunkSizeTiles : int = ww.getChunkSizeTiles()
# Chunk Size in Pixels
var chunkSizePixels : int = ww.getChunkSizePixels()
# Tile Size in Pixels
var tileSizePixels : int = ww.getTileSizePixels()
# Holds Noise Texture
var noise : = OpenSimplexNoise.new()

"""Ready Method
Sets the Seed and the First Chunk as the Next To Generate"""
func _ready():
	ww.setNextToGenerate(ww.getRoot())
	noise.lacunarity = 3
	noise.seed = 1
	
"""Updates the Mouse Pointer Hitbox
Handles Object Placement if an Object is currently getting placed"""
func _process(_delta):
	var mousePointer = get_parent().get_node("MousePointer")
	mousePointer.global_position = get_global_mouse_position()
	if currentObject != null:
		placeObject()

"""Generates a Chunk and keeps track of the Currently
Generated and Next To Generate Chunks"""
func generateChunk(root) -> void:
	createNoiseAndGenerate(root)
	generationFinished(root)
	
"""Creates a Noise Texture 
Used generate specific Tiles based on the Noise Value"""
func createNoiseAndGenerate(root) -> void:
	var percentage : int = SpawnRates.getPercentage()
	var rng = RandomNumberGenerator.new()
	rng.seed = root.x * root.y
	
	for x in range(chunkSizeTiles):
		for y in range(chunkSizeTiles):
			var rand = rng.randi_range(0, percentage)
			var randGrass = rng.randi_range(0, 4)
			var posCurrent = Vector2(x, y)
			var noise2D = noise.get_noise_2d(x + root.x * chunkSizeTiles,
			y + root.y * chunkSizeTiles) * 1.5 + 1.5
			if noise2D <= 1:
				generateDirt(posCurrent, root, rand)
				generateGrassTop(posCurrent, root, rand, randGrass, 1)
				groundLayer.update_bitmask_area(Vector2(x + root.x * chunkSizeTiles,
				y + root.y * chunkSizeTiles))
			elif noise2D <= 2:
				generateGrass(posCurrent, root, rand)
				generateGrassTop(posCurrent, root, rand, randGrass, 0)
				groundLayer.update_bitmask_area(Vector2(x + root.x * chunkSizeTiles,
				y + root.y * chunkSizeTiles))
			elif noise2D <= 3:
				generateGrassDark(posCurrent, root, rand)
				generateGrassTop(posCurrent, root, rand, randGrass, 2)
				groundLayer.update_bitmask_area(Vector2(x + root.x * chunkSizeTiles,
				y + root.y * chunkSizeTiles))
	
"""Updates the Chunk Arrays when the Generation is finished"""
func generationFinished(root):
	ww.setGeneratedChunks(root)
	ww.removeNextToGenerate(root)
	var rootLeft = root + Vector2.LEFT
	var rootRight = root + Vector2.RIGHT
	var rootDown = root + Vector2.DOWN
	var rootUp = root + Vector2.UP
	
	# Adds next to generate chunks if they are not already generated to an Array
	if !ww.getGeneratedChunks().has(rootLeft):
		ww.setNextToGenerate(rootLeft)
	if !ww.getGeneratedChunks().has(rootRight):
		ww.setNextToGenerate(rootRight)
	if !ww.getGeneratedChunks().has(rootDown):
		ww.setNextToGenerate(rootDown)
	if !ww.getGeneratedChunks().has(rootUp):
		ww.setNextToGenerate(rootUp)
	ww.updateNextToGenerate()
	
"""Generates the Dirt Floor
None of these Tiles have Collision"""
func generateDirt(posCurrent, root, rand) -> void:
	groundLayer.set_cell(posCurrent.x + root.x * chunkSizeTiles,
	posCurrent.y + root.y * chunkSizeTiles, 0)
	generateNature(0, posCurrent, root, rand)
	
"""Generates the Grass Floor
None of these Tiles have Collision"""
func generateGrass(posCurrent, root, rand) -> void:
	groundLayer.set_cell(posCurrent.x + root.x * chunkSizeTiles,
	posCurrent.y + root.y * chunkSizeTiles, 1)
	generateNature(1, posCurrent, root, rand)
	
"""Generates the Dark Grass Floor
None of these Tiles have Collision"""
func generateGrassDark(posCurrent, root, rand) -> void:
	groundLayer.set_cell(posCurrent.x + root.x * chunkSizeTiles,
	posCurrent.y + root.y * chunkSizeTiles, 2)
	generateNature(2, posCurrent, root, rand)
	
"""Generates Grass on top of the Grass Floor
None of these Tiles have Collision"""
func generateGrassTop(posCurrent, root, rand, randGrass, type) -> void:
	if type == 1:
		randGrass += 5
	if type == 2:
		randGrass += 10
	if rand < SpawnRates.grassTop:
		topLayer.set_cell(posCurrent.x + root.x * chunkSizeTiles,
		posCurrent.y + root.y * chunkSizeTiles, randGrass)
	
"""Generates Nature-Objects on top of the Floor
All of these Tiles have Collision"""
func generateNature(type, posCurrent, root, rand) -> void:
	var rng = RandomNumberGenerator.new()
	var spawnResource
	var randCheck
	var randResource
	rng.randomize()
	if type == 0:
		randResource = rng.randi_range(0, SpawnRates.dirt.size() - 1)
		if randResource == 0:
			spawnResource = preload("res://Objects/Rock.tscn")
			randCheck = SpawnRates.dirt.rock
		elif randResource == 1:
			spawnResource = preload("res://Objects/RockCopper.tscn")
			randCheck = SpawnRates.dirt.copper
		elif randResource == 2:
			spawnResource = preload("res://Objects/RockSmall.tscn")
			randCheck = SpawnRates.dirt.rocksmall
	elif type == 1:
		randResource = rng.randi_range(0, SpawnRates.grass.size() - 1)
		if randResource == 0:
			spawnResource = preload("res://Objects/Tree.tscn")
			randCheck = SpawnRates.grass.tree
		elif randResource == 1:
			spawnResource = preload("res://Objects/Stick.tscn")
			randCheck = SpawnRates.grass.stick
	elif type == 2:
		randResource = rng.randi_range(0, SpawnRates.grassdark.size() - 1)
		if randResource == 0:
			spawnResource = preload("res://Objects/TreeDark.tscn")
			randCheck = SpawnRates.grassdark.treedark
	if rand < randCheck:
		instanceAndAddObject(spawnResource, Vector2(posCurrent.x * tileSizePixels
		+ root.x * chunkSizePixels,
		posCurrent.y * tileSizePixels
		+ root.y * chunkSizePixels))
	
"""Removes a Chunk from the World and from the Generated Chunks Array"""
func removeChunk(root) -> void:
	removeDirt(root)
	removeGrass(root)
	removeGrassTop(root)
	removeNature()
	ww.removeGeneratedChunks(root)
	
"""Removes the Dirt"""
func removeDirt(root) -> void:
	for x in chunkSizeTiles:
		for y in chunkSizeTiles:
			groundLayer.set_cell(x + root.x * chunkSizeTiles,
			y + root.y * chunkSizeTiles, -1)
	
"""Removes the Grass"""
func removeGrass(root) -> void:
	for x in range(chunkSizeTiles):
		for y in range(chunkSizeTiles):
			groundLayer.set_cell(x + root.x * chunkSizeTiles,
			y + root.y * chunkSizeTiles, -1)
	
"""Removes the Grass on top of the Grass Floor"""
func removeGrassTop(root) -> void:
	for x in range(chunkSizeTiles):
		for y in range(chunkSizeTiles):
			topLayer.set_cell(x + root.x * chunkSizeTiles,
			y + root.y * chunkSizeTiles, -1)
	
"""Removes the Nature-Objects"""
func removeNature() -> void:
	for x in get_tree().get_nodes_in_group("Objects"):
		if player.isFarFromObject(x.global_position):
			x.queue_free()
	
"""Places the Blueprint of an Object in Increments of the Tile Size in Pixels
So they can only be placed in specific Increments of the World
Switches between different Textures
Depending on if the Object can be placed or not
Uses the Blueprint Textures which must be included in the Object Scene"""
func blueprint(object) -> void:
	var posXRest = fmod(get_global_mouse_position().x, tileSizePixels)
	var posYRest = fmod(get_global_mouse_position().y, tileSizePixels)
	var posX = get_global_mouse_position().x - posXRest - tileSizePixels
	var posY = get_global_mouse_position().y - posYRest - tileSizePixels
	if get_global_mouse_position().x > 0:
		posX += tileSizePixels
	if get_global_mouse_position().y > 0:
		posY += tileSizePixels
	var pos = Vector2(posX, posY)
	raycast.set_position(pos + raycastOffset)
	if raycast.is_colliding():
		object.setBlueprintState(0)
		areaClear = false
	else:
		object.setBlueprintState(1)
		areaClear = true
	positionObject(object, pos)
	
"""Instances an Object and adds it to the Scene Tree
Adds it to a Group of created Objects"""
func instanceAndAddObject(objectScene, position) -> void:
	var newObject = objectScene.instance()
	objects.call_deferred("add_child", newObject)
	positionObject(newObject, position)
	newObject.add_to_group("Objects")
	
"""Places an Object at a specific Position"""
func positionObject(instance, position) -> void:
	instance.global_position = position
	
"""Instance a new Object, add it to the Scene Tree
Show its Blueprint Texture which should be in the Scene"""
func instancePlaceableObject(item, position) -> void:
	raycast = newRayCast()
	var objectScene = item.getObject()
	var newObject = objectScene.instance()
	objects.add_child(newObject)
	positionObject(newObject, position)
	newObject.setCollision(0)
	currentObject = newObject
	blueprint(currentObject)
	
"""Checks if the Player clicked LMB to place an object"""
func checkPlaceObject() -> bool:
	blueprint(currentObject)
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and !Input.is_action_pressed("ctrl") and areaClear:
		return true
	return false
	
"""Places an Object"""
func placeObject() -> void:
	if checkPlaceObject():
		currentObject.setState(0)
		currentObject.setCollision(1)
		currentObject.add_to_group("Objects")
		currentObject = null
		raycast.queue_free()
		emit_signal("stopped_placing", true)
	
func cancel() -> void:
	Inventories.removeFurnaceInventory(currentObject.ui.sourceInventory.id)
	currentObject.queue_free()
	currentObject = null
	raycast.queue_free()
	emit_signal("stopped_placing", false)
	
func newRayCast() -> RayCast2D:
	var newRaycast = RayCast2D.new()
	newRaycast.enabled = true
	newRaycast.collide_with_areas = true
	newRaycast.collide_with_bodies = false
	newRaycast.collision_mask = 8
	newRaycast.cast_to = Vector2(1, 1)
	get_node("/root/Main").call_deferred("add_child", newRaycast)
	return newRaycast
