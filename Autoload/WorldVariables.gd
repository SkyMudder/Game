extends Node


const __tileSizePixels : int = 32	# Tile Size in Engine Units
const __chunkSizeTiles : int = 10	# Chunk Size in Tiles
const __chunkSizePixels : int = __tileSizePixels * __chunkSizeTiles	# Chunk Size in Enigne Units

var __root : Vector2 = Vector2.ZERO	# Where the first Chunk gets generated
var __renderDistance : int = 5	# Render distance in Chunks (Must be higher than 1)
var __generatedChunks = []	# Array that stores all generated Chunks
var __nextToGenerate = []	# Array that stores all the Chunks that are up next
							# to generate (Neighbours of generated Chunks)

"""Getter-Methods"""

func getRoot():
	return __root

func getRenderDistance():
	return __renderDistance

func getTileSizePixels():
	return __tileSizePixels
	
func getChunkSizeTiles():
	return __chunkSizeTiles
	
func getChunkSizePixels():
	return __chunkSizePixels
	
func getGeneratedChunks():
	return __generatedChunks
	
func getNextToGenerate():
	return __nextToGenerate

"""Setter-Methods"""

func setRenderDistance(val):
	__renderDistance = val

func setGeneratedChunks(value):
	__generatedChunks.push_back(value)

func setNextToGenerate(value):
	__nextToGenerate.push_back(value)

"""Methods to remove elements from Array"""

func removeGeneratedChunks(value):
	__generatedChunks.erase(value)
	
func removeNextToGenerate(value):
	__nextToGenerate.erase(value)

"""Other Methods"""

"""Remove Chunks that are too far away from
the nextToGenerate Array"""
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
