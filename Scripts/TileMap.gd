extends TileMap


onready var tileMapFloor = get_parent().get_node("Floor")
onready var tileMapNature = get_parent().get_node("Nature")

var size : int = WorldVariables.getChunkSizeTiles()

func _ready():
	generateChunk(WorldVariables.getRoot())
	
func generateChunk(root):
	generateFloor(root)
	generateNature(root)
	WorldVariables.setGeneratedChunks(root)
	WorldVariables.removeNextToGenerate(root)
	var rootLeft = root + Vector2.LEFT
	var rootRight = root + Vector2.RIGHT
	var rootDown = root + Vector2.DOWN
	var rootUp = root + Vector2.UP
	
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
	
func removeChunk(root):
	removeFloor(root)
	removeNature(root)
	WorldVariables.removeGeneratedChunks(root)
	
func generateFloor(root):
	for x in size:
		for y in size:
			tileMapFloor.set_cell(x + root.x * size, y + root.y * size, 0)
			
func generateNature(root):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for x in range(0, size):
		for y in range(0, size):
			var rand = rng.randi_range(-1, 6)
			var gen = rng.randi_range(1, 10)
			if gen % 3:
				tileMapNature.set_cell(x + root.x * size, y + root.y * size, -1)
			else:
				tileMapNature.set_cell(x + root.x * size, y + root.y * size, rand)
		
	
func removeFloor(root):
	for x in size:
		for y in size:
			tileMapFloor.set_cell(x + root.x * size, y + root.y * size, -1)
	
func removeNature(root):
	for x in range(0, size):
		for y in range(0, size):
			tileMapNature.set_cell(x + root.x * size, y + root.y * size, -1)
