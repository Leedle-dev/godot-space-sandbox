extends Node2D
class_name Galaxy

## These are the layers of the galaxy, in order of closest to center -> furthest from center.
enum GalaxyLayer {ORIGIN, INNER, OUTER, PERIMETER, EXPANSE, EDGE}

## The SystemInfo Resources, organized by their location in the Galaxy. 
# Originally tried this, but I don't think can type arrays that are child of dict
#@export var starSystems : Dictionary = {
#	GalaxyLayer.ORIGIN : Array[SystemInfo],
#	GalaxyLayer.INNER : Array[SystemInfo],
#	GalaxyLayer.OUTER : Array[SystemInfo],
#	GalaxyLayer.PERIMETER : Array[SystemInfo],
#	GalaxyLayer.EXPANSE : Array[SystemInfo],
#	GalaxyLayer.EDGE : Array[SystemInfo]
#	}

@export var originSystems : Array[SystemInfo] = []
@export var innerSystems : Array[SystemInfo] = []
@export var outerSystems : Array[SystemInfo] = []
@export var perimeterSystems : Array[SystemInfo] = []
@export var expanseSystems : Array[SystemInfo] = []
@export var edgeSystems : Array[SystemInfo] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
