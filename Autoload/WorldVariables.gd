extends Node


const tileSizePixels : int = 32	# Tile Size in Engine Units
const chunkSizeTiles : int = 10	# Chunk Size in Tiles
const chunkSizePixels : int = tileSizePixels * chunkSizeTiles	# Chunk Size in Enigne Units
const pickupRange : float = 100.0
const damageRange : float = 180.0

var root : Vector2 = Vector2.ZERO	# Where the first Chunk gets generated
var renderDistance : int = 10	# Render distance in Chunks (Must be higher than 1)
var generatedChunks : Array = []	# Array that stores all generated Chunks
var nextToGenerate : Array = []	# Array that stores all the Chunks that are up next
							# to generate (Neighbours of generated Chunks)
	
var placeableObjects = [preload("res://PlaceableObjects/Furnace.tscn")]

enum type{WOOD, MINERAL}

"""Getter-Methods"""

func getRoot() -> Vector2:
	return root

func getRenderDistance() -> int:
	return renderDistance

func getTileSizePixels() -> int:
	return tileSizePixels
	
func getChunkSizeTiles() -> int:
	return chunkSizeTiles
	
func getChunkSizePixels()  -> int:
	return chunkSizePixels
	
func getGeneratedChunks() -> Array:
	return generatedChunks
	
func getNextToGenerate() -> Array:
	return nextToGenerate

"""Setter-Methods"""

func setRenderDistance(val) -> void:
	renderDistance = val

func setGeneratedChunks(value) -> void:
	generatedChunks.push_back(value)

func setNextToGenerate(value) -> void:
	nextToGenerate.push_back(value)

"""Methods to remove Elements from Array"""

func removeGeneratedChunks(value) -> void:
	generatedChunks.erase(value)
	
func removeNextToGenerate(value) -> void:
	nextToGenerate.erase(value)
	
"""Other Methods"""

"""Remove Chunks that are too far away from
the Next To Generate Array"""
func updateNextToGenerate() -> void:
	var rootLeft : = Vector2.LEFT
	var rootRight : = Vector2.RIGHT
	var rootDown : = Vector2.DOWN
	var rootUp : = Vector2.UP
	
	for x in nextToGenerate:
		if !generatedChunks.has(x + rootLeft):
			if !generatedChunks.has(x + rootRight):
				if !generatedChunks.has(x + rootDown):
					if !generatedChunks.has(x + rootUp):
						removeNextToGenerate(x)
