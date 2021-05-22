extends TileMap


onready var tileMapFloor = get_parent().get_node("Floor")	# Floor TileMap
onready var tileMapNature = get_parent().get_node("Nature")	# Nature TileMap

var size : int = WorldVariables.getChunkSizeTiles()	# Chunk Size

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
	
	print("Generated Chunk at")
	print(root * WorldVariables.getChunkSizePixels())
	
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
			tileMapFloor.set_cell(x + root.x * size, y + root.y * size, 0)
	
"""Generates Objects on top of the Floor using the Nature TileMap
Some of these Tiles have collision"""
func generateNature(root):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for x in range(0, size):
		for y in range(0, size):
			var rand = rng.randi_range(-1, 6)	# Chooses a random Tile
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
	for x in range(0, size):
		for y in range(0, size):
			tileMapNature.set_cell(x + root.x * size, y + root.y * size, -1)
