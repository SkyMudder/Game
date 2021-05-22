extends TileMap


onready var tileMapFloor = get_parent().get_node("Floor")	# Floor TileMap
onready var tileMapNature = get_parent().get_node("Nature")	# Nature TileMap

var size : int = WorldVariables.getChunkSizeTiles()	# Chunk Size
var noise : OpenSimplexNoise = OpenSimplexNoise.new()	#Holds Noise Texture

"""Ready Method"""
"""Generates first Chunk"""
func _ready():
	generateChunk(WorldVariables.getRoot())
	
"""Updates every Frame
Cleans up the nextToGenerate Array"""
func _process(delta):
	WorldVariables.updateNextToGenerate()
	
"""Generates a Chunk and keeps track of the currently
generated and next to generate Chunks"""
func generateChunk(root):
	# createNoise(root, size)
	generateFloor(root)
	generateNature(root)
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
	removeFloor(root)
	removeNature(root)
	WorldVariables.removeGeneratedChunks(root)
	
"""Generates the floor using the Floor TileMap
None of these Tiles have collision"""
func generateFloor(root):
	for x in size:
		for y in size:
			tileMapFloor.set_cell(x + root.x * size, y + root.y * size, 20)
	
"""Generates Objects on top of the Floor using the Nature TileMap
Some of these Tiles have collision"""
func generateNature(root):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for x in range(size):
		for y in range(size):
			var rand = rng.randi_range(-1, 20)	# Chooses a random Tile
			var gen = rng.randi_range(1, 10)	# Chooses a random number
			if gen % 3:	# which is used to determine if a Tile gets added
				tileMapNature.set_cell(x + root.x * size, y + root.y * size, -1)
			else:
				tileMapNature.set_cell(x + root.x * size, y + root.y * size, rand)
				# Cells get added to the World
	
"""Removes the Floor"""
func removeFloor(root):
	for x in size:
		for y in size:
			tileMapFloor.set_cell(x + root.x * size, y + root.y * size, -1)
	
"""Removes the Objects on top of the Floor"""
func removeNature(root):
	for x in range(size):
		for y in range(size):
			tileMapNature.set_cell(x + root.x * size, y + root.y * size, -1)
	
"""Creates a noise texture to generate specific tiles based on the noise value
***UNFINISHED***"""
func createNoise(root, size):
	var rng = RandomNumberGenerator.new()
	for x in range(size):
		for y in range(size):
			var noise2D = noise.get_noise_2d(x + root.x * size, y + root.y * size) * 5 + 3
			if noise2D < 1:
				tileMapFloor.set_cell(x + root.x * size, y + root.y * size, 0)
				tileMapNature.set_cell(x + root.x * size, y + root.y * size, 0)
			elif noise2D < 2:
				var rand = rng.randi_range(1, 5)
				tileMapFloor.set_cell(x + root.x * size, y + root.y * size, rand)
				tileMapNature.set_cell(x + root.x * size, y + root.y * size, rand)
			elif noise2D < 3:
				var rand = rng.randi_range(6, 10)
				tileMapFloor.set_cell(x + root.x * size, y + root.y * size, rand)
				tileMapNature.set_cell(x + root.x * size, y + root.y * size, rand)
			elif noise2D < 4:
				var rand = rng.randi_range(11, 15)
				tileMapFloor.set_cell(x + root.x * size, y + root.y * size, rand)
				tileMapNature.set_cell(x + root.x * size, y + root.y * size, rand)
			elif noise2D > 4:
				var rand = rng.randi_range(16, 20)
				tileMapFloor.set_cell(x + root.x * size, y + root.y * size, rand)
				tileMapNature.set_cell(x + root.x * size, y + root.y * size, rand)
