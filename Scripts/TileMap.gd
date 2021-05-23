extends TileMap


onready var tileMapDirt = get_parent().get_node("Dirt")	# Dirt TileMap
onready var tileMapGrass = get_parent().get_node("Grass")	# Grass TileMap
onready var tileMapNature = get_parent().get_node("Nature")	# Nature TileMap

var size : int = WorldVariables.getChunkSizeTiles()	# Chunk Size
var noise : OpenSimplexNoise = OpenSimplexNoise.new()	#Holds Noise Texture

"""Ready Method"""
"""Generates first Chunk"""
func _ready():
	generateChunk(WorldVariables.getRoot())
	noise.seed = 1
	
"""Updates every Frame
Cleans up the nextToGenerate Array"""
func _process(delta):
	WorldVariables.updateNextToGenerate()
	tileMapGrass.update_bitmask_region()
	
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
	
"""Removes a Chunk from the world and from the generatedChunks Array"""
func removeChunk(root):
	removeDirt(root)
	removeGrass(root)
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
	
"""Removes the Nature-Objects"""
func removeNature(root):
	for x in range(size):
		for y in range(size):
			tileMapNature.set_cell(x + root.x * size, y + root.y * size, -1)
	
"""Creates a noise texture to generate specific tiles based on the noise value
Currently generates Dirt and Grass with varying Objects on top of it"""
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
				generateGrass(posCurrent, root, rand)
	
"""Generates the Dirt Floor
None of these Tiles have Collision"""
func generateDirt(posCurrent, root, rand, randDirt):
	tileMapDirt.set_cell(posCurrent.x + root.x * size, posCurrent.y + root.y * size, 0)
	if rand < SpawnRates.getDirt():
		tileMapDirt.set_cell(posCurrent.x + root.x * size, posCurrent.y + root.y * size, randDirt)
	else:
		tileMapDirt.set_cell(posCurrent.x + root.x * size, posCurrent.y + root.y * size, 4)
	generateNature(16, posCurrent, root, rand)
	
"""Generates the Grass Floor
None of these Tiles have Collision"""
func generateGrass(posCurrent, root, rand):
	tileMapGrass.set_cell(posCurrent.x + root.x * size, posCurrent.y + root.y * size, 0)
	generateNature(17, posCurrent, root, rand)
	
"""Generates Nature-Objects on top of the Floor
Some of these Tiles have Collision"""
func generateNature(type, posCurrent, root, rand):
	if type == 16:
		if rand < SpawnRates.getRock():
			tileMapNature.set_cell(posCurrent.x + root.x * size, posCurrent.y + root.y * size, type)
	if type == 17:
		if rand < SpawnRates.getTree():
			tileMapNature.set_cell(posCurrent.x + root.x * size, posCurrent.y + root.y * size, type)
