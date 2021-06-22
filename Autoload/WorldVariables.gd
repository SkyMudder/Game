extends Node


const __tileSizePixels : int = 32	# Tile Size in Engine Units
const __chunkSizeTiles : int = 10	# Chunk Size in Tiles
const __chunkSizePixels : int = __tileSizePixels * __chunkSizeTiles	# Chunk Size in Enigne Units

var __root : Vector2 = Vector2.ZERO	# Where the first Chunk gets generated
var __renderDistance : int = 5	# Render distance in Chunks (Must be higher than 1)
var __generatedChunks : Array = []	# Array that stores all generated Chunks
var __nextToGenerate : Array = []	# Array that stores all the Chunks that are up next
							# to generate (Neighbours of generated Chunks)
var placeableObjects = [preload("res://PlaceableObjects/Furnace.tscn")]

enum type{WOOD, MINERAL}

"""Getter-Methods"""

func getRoot() -> Vector2:
	return __root

func getRenderDistance() -> int:
	return __renderDistance

func getTileSizePixels() -> int:
	return __tileSizePixels
	
func getChunkSizeTiles() -> int:
	return __chunkSizeTiles
	
func getChunkSizePixels()  -> int:
	return __chunkSizePixels
	
func getGeneratedChunks() -> Array:
	return __generatedChunks
	
func getNextToGenerate() -> Array:
	return __nextToGenerate

"""Setter-Methods"""

func setRenderDistance(val) -> void:
	__renderDistance = val

func setGeneratedChunks(value) -> void:
	__generatedChunks.push_back(value)

func setNextToGenerate(value) -> void:
	__nextToGenerate.push_back(value)

"""Methods to remove Elements from Array"""

func removeGeneratedChunks(value) -> void:
	__generatedChunks.erase(value)
	
func removeNextToGenerate(value) -> void:
	__nextToGenerate.erase(value)

"""Other Methods"""

"""Remove Chunks that are too far away from
the Next To Generate Array"""
func updateNextToGenerate() -> void:
	var rootLeft : = Vector2.LEFT
	var rootRight : = Vector2.RIGHT
	var rootDown : = Vector2.DOWN
	var rootUp : = Vector2.UP
	
	for x in __nextToGenerate:
		if !__generatedChunks.has(x + rootLeft):
			if !__generatedChunks.has(x + rootRight):
				if !__generatedChunks.has(x + rootDown):
					if !__generatedChunks.has(x + rootUp):
						removeNextToGenerate(x)
