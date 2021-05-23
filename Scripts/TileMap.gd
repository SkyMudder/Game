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
	createNoise(root, size)
	# generateFloor(root)
	# generateGrass(root)
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
	WorldVariables.removeGeneratedChunks(root)
	
"""Generates the Dirt using the Dirt TileMap
None of these Tiles have collision"""
func generateDirt(root):
	for x in size:
		for y in size:
			tileMapDirt.set_cell(x + root.x * size, y + root.y * size, 20)
	
"""Generates the Grass using the Grass TileMap
None of these Tiles have collision"""
func generateGrass(root):
	var rng = RandomNumberGenerator.new()
	rng.seed = root.x * root.y
	for x in range(size):
		for y in range(size):
			var rand = rng.randi_range(16, 17)	# Chooses a random Tile
			var gen = rng.randi_range(1, 20)	# Chooses a random number
			if gen % 19 == 0:	# which is used to determine if a Tile gets added
				tileMapGrass.set_cell(x + root.x * size, y + root.y * size, rand)
				# Cells get added to the World
	
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
	
"""Creates a noise texture to generate specific tiles based on the noise value
Currently generates Dirt and Grass with varying Objects on top of it"""
func createNoise(root, size):
	var rng = RandomNumberGenerator.new()
	for x in range(size):
		for y in range(size):
			var noise2D = noise.get_noise_2d(x + root.x * size, y + root.y * size) + 1
			if noise2D < 1:
				var rand = rng.randi_range(0, 50)
				if rand < 10:
					tileMapDirt.set_cell(x + root.x * size, y + root.y * size, rand / 2)
				else:
					tileMapDirt.set_cell(x + root.x * size, y + root.y * size, 4)
				if rand == 10:
					tileMapNature.set_cell(x + root.x * size, y + root.y * size, 16)
					
			elif noise2D > 1:
				var rand = rng.randi_range(0, 15)
				tileMapGrass.set_cell(x + root.x * size, y + root.y * size, 0)
				tileMapNature.set_cell(x + root.x * size, y + root.y * size, rand)
