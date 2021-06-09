extends TileMap


onready var tileMapDirt = get_parent().get_node("Dirt")
onready var tileMapGrass = get_parent().get_node("Grass")
onready var tileMapGrassTopGreen = get_parent().get_node("GrassTopGreen")
onready var tileMapGrassTopBrown= get_parent().get_node("GrassTopBrown")
onready var player = get_node("../KinematicBody2D")

var ww = WorldVariables

# Chunk Size in Tiles
var chunkSizeTiles : int = ww.getChunkSizeTiles()
# Chunk Size in Pixels
var chunkSizePixels : int = ww.getChunkSizePixels()
# Tile Size in Pixels
var tileSizePixels : int = ww.getTileSizePixels()
# Holds Noise Texture
var noise : OpenSimplexNoise = OpenSimplexNoise.new()

"""Ready Method
Sets the Seed and the First Chunk as the Next To Generate"""
func _ready():
	ww.setNextToGenerate(ww.getRoot())
	noise.seed = 1
	
"""Updates the Mouse Pointer Hitbox"""
func _process(_delta):
	var mousePointer = get_parent().get_node("MousePointer")
	mousePointer.global_position = get_global_mouse_position()
	
"""Generates a Chunk and keeps track of the Currently
Generated and Next To Generate Chunks"""
func generateChunk(root):
	createNoiseAndGenerate(root)
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
	
"""Creates a Noise Texture 
Used generate specific Tiles based on the Noise Value"""
func createNoiseAndGenerate(root):
	var percentage = SpawnRates.getPercentage()
	var rng = RandomNumberGenerator.new()
	rng.seed = root.x * root.y
	
	for x in range(chunkSizeTiles):
		for y in range(chunkSizeTiles):
			var rand = rng.randi_range(0, percentage)
			var randGrass = rng.randi_range(0, 4)
			var posCurrent = Vector2(x, y)
			var noise2D = noise.get_noise_2d(x + root.x * chunkSizeTiles,
			y + root.y * chunkSizeTiles) + 1
			if noise2D <= 1:
				var randDirt = rng.randi_range(0, 3)
				generateDirt(posCurrent, root, rand, randDirt)
				generateGrassTop(posCurrent, root, rand, randGrass, 1)
			elif noise2D > 1:
				generateGrass(posCurrent, root, rand)
				generateGrassTop(posCurrent, root, rand, randGrass, 0)
				update_bitmask_area(Vector2(x + root.x * chunkSizeTiles,
				y + root.y * chunkSizeTiles))
	
"""Generates the Dirt Floor
None of these Tiles have Collision"""
func generateDirt(posCurrent, root, rand, randDirt):
	tileMapDirt.set_cell(posCurrent.x + root.x * chunkSizeTiles,
	posCurrent.y + root.y * chunkSizeTiles, 0)
	if rand < SpawnRates.getDirt():
		tileMapDirt.set_cell(posCurrent.x + root.x * chunkSizeTiles,
		posCurrent.y + root.y * chunkSizeTiles, randDirt)
	else:
		tileMapDirt.set_cell(posCurrent.x + root.x * chunkSizeTiles,
		posCurrent.y + root.y * chunkSizeTiles, 4)
	generateNature(1, posCurrent, root, rand)
	
"""Generates the Grass Floor
None of these Tiles have Collision"""
func generateGrass(posCurrent, root, rand):
	tileMapGrass.set_cell(posCurrent.x + root.x * chunkSizeTiles,
	posCurrent.y + root.y * chunkSizeTiles, 0)
	generateNature(0, posCurrent, root, rand)
	
"""Generates Grass on top of the Grass Floor
None of these Tiles have Collision"""
func generateGrassTop(posCurrent, root, rand, randGrass, type):
	var tileMap
	if type == 0:
		tileMap = tileMapGrassTopGreen
	elif type == 1:
		tileMap = tileMapGrassTopBrown
	if rand < SpawnRates.getGrass():
		tileMap.set_cell(posCurrent.x + root.x * chunkSizeTiles,
		posCurrent.y + root.y * chunkSizeTiles, randGrass)
	
"""Generates Nature-Objects on top of the Floor
All of these Tiles have Collision"""
func generateNature(type, posCurrent, root, rand):
	var rng = RandomNumberGenerator.new()
	var SpawnResource
	var randCheck
	var randResource
	var resource
	rng.randomize()
	if type == 0:
		randResource = rng.randi_range(0, 1)
		if randResource == 0:
			SpawnResource = preload("res://Scenes/Tree.tscn")
			randCheck = SpawnRates.getTree()
			resource = ww.type.TREE
		if randResource == 1:
			SpawnResource = preload("res://Scenes/Stick.tscn")
			randCheck = SpawnRates.getStick()
		if rand < SpawnRates.getTree():
			var spawnResource = SpawnResource.instance()
			var world = get_tree().current_scene
			world.add_child(spawnResource)
			spawnResource.global_position = Vector2(posCurrent.x * tileSizePixels
			+ root.x * chunkSizePixels,
			posCurrent.y * tileSizePixels
			+ root.y * chunkSizePixels)
			if resource != null:
				spawnResource.assignVariables(ww.getObjectVariables(resource))
			spawnResource.add_to_group("Objects")
	if type == 1:
		randResource = rng.randi_range(0, 1)
		if randResource == 0:
			SpawnResource = preload("res://Scenes/Rock.tscn")
			randCheck = SpawnRates.getRock()
			resource = ww.type.ROCK
		elif randResource == 1:
			SpawnResource = preload("res://Scenes/RockCopper.tscn")
			randCheck = SpawnRates.getCopper()
			resource = ww.type.ROCKCOPPER
		if rand < randCheck:
			var spawnResource = SpawnResource.instance()
			var world = get_tree().current_scene
			world.add_child(spawnResource)
			spawnResource.global_position = Vector2(posCurrent.x * tileSizePixels
			+ root.x * chunkSizePixels,
			posCurrent.y * tileSizePixels
			+ root.y * chunkSizePixels)
			spawnResource.assignVariables(ww.getObjectVariables(resource))
			spawnResource.add_to_group("Objects")
		
	
"""Removes a Chunk from the World and from the Generated Chunks Array"""
func removeChunk(root):
	removeDirt(root)
	removeGrass(root)
	removeGrassTop(root)
	removeNature()
	ww.removeGeneratedChunks(root)
	
"""Removes the Dirt"""
func removeDirt(root):
	for x in chunkSizeTiles:
		for y in chunkSizeTiles:
			tileMapDirt.set_cell(x + root.x * chunkSizeTiles,
			y + root.y * chunkSizeTiles, -1)
	
"""Removes the Grass"""
func removeGrass(root):
	for x in range(chunkSizeTiles):
		for y in range(chunkSizeTiles):
			tileMapGrass.set_cell(x + root.x * chunkSizeTiles,
			y + root.y * chunkSizeTiles, -1)
	
"""Removes the Grass on top of the Grass Floor"""
func removeGrassTop(root):
	for x in range(chunkSizeTiles):
		for y in range(chunkSizeTiles):
			tileMapGrassTopGreen.set_cell(x + root.x * chunkSizeTiles,
			y + root.y * chunkSizeTiles, -1)
	
"""Removes the Nature-Objects"""
func removeNature():
	for x in get_tree().get_nodes_in_group("Objects"):
		if player.isFarFromObject(x.global_position):
			x.queue_free()
