extends Control
class_name StarSystemUINode

##
# Offset Constants - used for building out the star system map using normalized vector offsets for relative positioning on the screen
##

const CENTER : float = 0.0

const LEFTMOST: float = -0.75
const LEFT: float = -0.375
const CENTERLEFT : float = -0.1875
 
const CENTERRIGHT : float = 0.1875
const RIGHT : float = 0.375
const RIGHTMOST : float = 0.75

const UPMOST: float = -0.75
const UP: float = -0.375
const CENTERUP : float = -0.1875

const CENTERDOWN : float = 0.1875
const DOWN : float = 0.375
const DOWNMOST : float = 0.75
	

var radius: float
@onready var originalPosition := self.position
## Array of offests for node positions
# This is the grid ->
# Positions are as follows ->
#
#	9	  10  11	12
#
#		1	2	3
#	13				14
#		4	0	5
#	15				16
#		6	7	8
#	
#	17	  18  19	20
#
##

var offsets : Dictionary[int, Vector2] = {
	0: Vector2(CENTER,CENTER),
	1: Vector2(LEFT, UP),
	2: Vector2(CENTER, UP),
	3: Vector2(RIGHT, UP),
	4: Vector2(LEFT,CENTER),
	5: Vector2(RIGHT, CENTER),
	6: Vector2(LEFT, DOWN),
	7: Vector2(CENTER, DOWN),
	8: Vector2(RIGHT,DOWN),
	9: Vector2(LEFTMOST, UPMOST),
	10: Vector2(CENTERLEFT, UPMOST),
	11: Vector2(CENTERRIGHT, UPMOST),
	12: Vector2(RIGHTMOST, UPMOST),
	13: Vector2(LEFTMOST,CENTERUP),
	14: Vector2(RIGHTMOST,CENTERUP),
	15: Vector2(LEFTMOST,CENTERDOWN),
	16: Vector2(RIGHTMOST,CENTERDOWN),
	17: Vector2(LEFTMOST,DOWNMOST),
	18: Vector2(CENTERLEFT,DOWNMOST),
	19: Vector2(CENTERRIGHT,DOWNMOST),
	20: Vector2(RIGHTMOST,DOWNMOST)
	}

@onready var sectors : Array[SectorRing] = [
	$StarSystem/SectorRing1,
	$StarSystem/SectorRing2, 
	$StarSystem/SectorRing3,
	$StarSystem/SectorRing4,
	$StarSystem/SectorRing5,
	$StarSystem/SectorRing6,
	$StarSystem/SectorRing7,
	$StarSystem/SectorRing8,
	$StarSystem/SectorRing9,
	$StarSystem/SectorRing10, 
	$StarSystem/SectorRing11,
	$StarSystem/SectorRing12,
	$StarSystem/SectorRing13,
	$StarSystem/SectorRing14,
	$StarSystem/SectorRing15,
	$StarSystem/SectorRing16,
	$StarSystem/SectorRing17,
	$StarSystem/SectorRing18, 
	$StarSystem/SectorRing19,
	$StarSystem/SectorRing20,
	$StarSystem/SectorRing21
]

@onready var starSystem : Node2D = $StarSystem

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	layoutSectors()
	self.modulate.a = 0.0
	pivot_offset = size / 2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func layoutSectors() -> void:
	var center = size * 0.5
	center.x = center.x - 128
	center.y = center.y - 128
	print_debug(center)
	radius = min(size.x, size.y) * 0.5
	for i in range(sectors.size()):
		placeSector(i, center, radius)
		sectors[i].nameLabel.modulate.a = 0.0
		sectors[i].nameLabelStar.modulate.a = 1.0
	
func placeSector(index : int, center : Vector2, radius : float) -> void:
	sectors[index].position = center + offsets[index] * radius
