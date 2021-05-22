extends Node

var __root : Vector2 = Vector2.ZERO
var __renderDistance : int = 5
const __tileSize : int = 32
const __chunkSizeTiles : int = 10
const __chunkSizePixels : int = __tileSize * __chunkSizeTiles
var __generatedChunks = []
var __nextToGenerate = []

func _ready():
	pass

func getRoot():
	return __root
	
func getRenderDistance():
	return __renderDistance
	
func getTileSize():
	return __tileSize
	
func getChunkSizeTiles():
	return __chunkSizeTiles
	
func getChunkSizePixels():
	return __chunkSizePixels
	
func getGeneratedChunks():
	return __generatedChunks
	
func getNextToGenerate():
	return __nextToGenerate

func setRenderDistance(val):
	__renderDistance = val

func setGeneratedChunks(value):
	__generatedChunks.push_back(value)

func setNextToGenerate(value):
	__nextToGenerate.push_back(value)
	
func removeGeneratedChunks(value):
	__generatedChunks.erase(value)
	
func removeNextToGenerate(value):
	__nextToGenerate.erase(value)

func updateNextToGenerate():
	var rootLeft = Vector2.LEFT
	var rootRight = Vector2.RIGHT
	var rootDown = Vector2.DOWN
	var rootUp = Vector2.UP
	
	for x in __nextToGenerate:
		if !__generatedChunks.has(x + rootLeft):
			if !__generatedChunks.has(x + rootRight):
				if !__generatedChunks.has(x + rootDown):
					if !__generatedChunks.has(x + rootUp):
						removeNextToGenerate(x)
