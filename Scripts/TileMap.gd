extends TileMap


onready var tileMapDirt = get_parent().get_node("Dirt")
onready var tileMapGrass = get_parent().get_node("Grass")
onready var tileMapNature = get_parent().get_node("Nature")
onready var tileMapGrassTop = get_parent().get_node("GrassTop")

var size : int = WorldVariables.getChunkSizeTiles()	# Chunk Size
var noise : OpenSimplexNoise = OpenSimplexNoise.new()	#Holds Noise Texture
var thread	# Used to update the nextToGenerate Array and the Bitmask Region
var flag = 0

"""Ready Method
Generates first Chunk"""
func _ready():
	WorldVariables.setNextToGenerate(WorldVariables.getRoot())
	noise.seed = 1
	
"""Updates every Frame
Cleans up the nextToGenerate Array and updates the Bitmask Region"""
func _process(delta):
	WorldVariables.updateNextToGenerate()
	
"""Generates a Chunk and keeps track of the currently
generated and next to generate Chunks"""
func generateChunk(root):
	createNoiseAndGenerate(root, size)
	WorldVariables.setGeneratedChunks(root)
	WorldVariables.removeNextToGenerate(root)
	var rootLeft = root + Vector2.LEFT
	var rootRight = root + Vector2.RIGHT
	var rootDown = root + Vector2.DOWN
	var rootUp = root + Vector2.UP
	
	# Adds next to generate chunks if they are not already generated to an Array
	if !WorldVariables.getGeneratedChunks().has(rootLeft):
		WorldVariables.setNextToGenerate(rootLeft)
	if !WorldVariables.getGeneratedChunks().has(rootRight):
		WorldVariables.setNextToGenerate(rootRight)
	if !WorldVariables.getGeneratedChunks().has(rootDown):
		WorldVariables.setNextToGenerate(rootDown)
	if !WorldVariables.getGeneratedChunks().has(rootUp):
		WorldVariables.setNextToGenerate(rootUp)
	
"""Creates a noise texture to generate specific tiles based on the noise value"""
func createNoiseAndGenerate(root, size):
	var percentage = SpawnRates.getPercentage()
	var rng = RandomNumberGenerator.new()
	rng.seed = root.x * root.y
	
	for x in range(size):
		for y in range(size):
			var rand = rng.randi_range(0, percentage)
			var posCurrent = Vector2(x, y)
			var noise2D = noise.get_noise_2d(x + root.x * size, y + root.y * size) + 1
			if noise2D < 1:
				var randDirt = rng.randi_range(0, 3)
				generateDirt(posCurrent, root, rand, randDirt)
			elif noise2D > 1:
				var randGrass = rng.randi_range(0, 4)
				generateGrass(posCurrent, root, rand)
				generateGrassTop(posCurrent, root, rand, randGrass)
				update_bitmask_area(Vector2(x + root.x * size, y + root.y * size))
	
"""Generates the Dirt Floor
None of these Tiles have Collision"""
func generateDirt(posCurrent, root, rand, randDirt):
	tileMapDirt.set_cell(posCurrent.x + root.x * size, posCurrent.y + root.y * size, 0)
	if rand < SpawnRates.getDirt():
		tileMapDirt.set_cell(posCurrent.x + root.x * size, posCurrent.y + root.y * size, randDirt)
	else:
		tileMapDirt.set_cell(posCurrent.x + root.x * size, posCurrent.y + root.y * size, 4)
	generateNature(0, posCurrent, root, rand)
	
"""Generates the Grass Floor
None of these Tiles have Collision"""
func generateGrass(posCurrent, root, rand):
	tileMapGrass.set_cell(posCurrent.x + root.x * size, posCurrent.y + root.y * size, 0)
	generateNature(1, posCurrent, root, rand)
	flag = 1
	
"""Generates Grass on top of the Grass Floor"""
func generateGrassTop(posCurrent, root, rand, randGrass):
	if rand < SpawnRates.getGrass():
		tileMapGrassTop.set_cell(posCurrent.x + root.x * size, posCurrent.y + root.y * size, randGrass)
	
"""Generates Nature-Objects on top of the Floor
Some of these Tiles have Collision"""
func generateNature(type, posCurrent, root, rand):
	if type == 0:
		if rand < SpawnRates.getRock():
			tileMapNature.set_cell(posCurrent.x + root.x * size, posCurrent.y + root.y * size, type)
	if type == 1:
		if rand < SpawnRates.getTree():
			tileMapNature.set_cell(posCurrent.x + root.x * size, posCurrent.y + root.y * size, type)
	
"""Removes a Chunk from the world and from the generatedChunks Array"""
func removeChunk(root):
	removeDirt(root)
	removeGrass(root)
	removeGrassTop(root)
	removeNature(root)
	WorldVariables.removeGeneratedChunks(root)
	
"""Removes the Dirt"""
func removeDirt(root):
	for x in size:
		for y in size:
			tileMapDirt.set_cell(x + root.x * size, y + root.y * size, -1)
	
"""Removes the Grass"""
func removeGrass(root):
	for x in range(size):
		for y in range(size):
			tileMapGrass.set_cell(x + root.x * size, y + root.y * size, -1)
	
"""Removes the Grass on top of the Grass Floor"""
func removeGrassTop(root):
	for x in range(size):
		for y in range(size):
			tileMapGrassTop.set_cell(x + root.x * size, y + root.y * size, -1)
	
"""Removes the Nature-Objects"""
func removeNature(root):
	for x in range(size):
		for y in range(size):
			tileMapNature.set_cell(x + root.x * size, y + root.y * size, -1)
