extends Control
class_name GalaxyMapUI

@onready var mapContainer = $MapContainer
@onready var markers = $MapContainer/Markers
@onready var backgroundRings = $MapContainer/GalaxyRings
var markerScene : PackedScene = preload("res://UI/Galaxy/GalaxyMap/StarSystemMarker.tscn")

const minStarTexSize = 256



var galaxyLimits : Dictionary[Galaxy.GalaxyLayer, Vector2] = {
	Galaxy.GalaxyLayer.ORIGIN: Vector2(-2048, 2048),
	Galaxy.GalaxyLayer.INNER: Vector2(-4096-minStarTexSize, 4096+minStarTexSize),
	Galaxy.GalaxyLayer.OUTER: Vector2(-6144-(minStarTexSize*2), 6144+(minStarTexSize*2)),
	Galaxy.GalaxyLayer.PERIMETER: Vector2(-8192-(minStarTexSize*3), 8192+(minStarTexSize*3)),
	Galaxy.GalaxyLayer.EXPANSE: Vector2(-10240-(minStarTexSize*4), 10240+(minStarTexSize*4)),
	Galaxy.GalaxyLayer.EDGE: Vector2(-12288-(minStarTexSize*5), 12288+(minStarTexSize*5))
}

## Example coordinates for star system markers.
## Refactor to Resource
var coords : Array[Vector2] = [Vector2(-500, -500), Vector2(-250,-250), Vector2(0,0), Vector2(500,500)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#for coord in coords:
	#	var marker = markerScene.instantiate()
	#	marker.position = coord
	#	markers.add_child(marker)
	for i in range(60):
		var layer = Galaxy.GalaxyLayer.values().pick_random()
		var marker : StarSystemMarker = markerScene.instantiate()
		marker.position = pickRandomPositionInRing(layer)
		markers.add_child(marker)
		marker.label.text = Galaxy.GalaxyLayer.keys()[layer] + " " + str(snapped(marker.position.x, 0.01)) + "x" + str(snapped(marker.position.y, 0.01))
	self.modulate.a = 0.0

	var ringData = buildRings()
	backgroundRings.rings = ringData
	backgroundRings.queue_redraw()



func pickRandomPosition(layer : Galaxy.GalaxyLayer) -> Vector2:
	var minLayer: Vector2
	var maxLayer: Vector2 = galaxyLimits.get(layer)
	if layer == 0:
		minLayer = Vector2.ZERO
	else:
		minLayer = galaxyLimits.get(layer-1)
		# y here is positive values, x is negative
	var coordOptions : Array[float] = [randf_range(minLayer.y, maxLayer.y), randf_range(maxLayer.x, minLayer.x)]
	var randOne = randf_range(minLayer.y, maxLayer.y)
	var randTwo = randf_range(maxLayer.x, minLayer.x)
	return Vector2(randOne, randTwo)

## Picks a random position in a ring to place a star system in the galaxy map
func pickRandomPositionInRing(layer : Galaxy.GalaxyLayer) -> Vector2:
	var minLayer: Vector2
	var maxLayer: Vector2 = galaxyLimits.get(layer)
	if layer == 0:
		minLayer = Vector2.ZERO
	else:
		minLayer = galaxyLimits.get(layer-1)
	var theta = randf() * TAU
	var u = randf()
	var r = sqrt(u * (maxLayer.y * maxLayer.y - minLayer.y * minLayer.y) + minLayer.y * minLayer.y)
	return Vector2(cos(theta), sin(theta)) * r

func buildRings() -> Array :
	var rings := []
	var previousRadius := 0.0
	for layer in Galaxy.GalaxyLayer:
		print_debug(layer)
		var limit : Vector2 = galaxyLimits[Galaxy.GalaxyLayer.get(layer)]
		var radius : float = abs(limit.y)
		rings.append({"layer" : Galaxy.GalaxyLayer.get(layer), "inner" : previousRadius, "outer" : radius})
		previousRadius = radius

	return rings


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
