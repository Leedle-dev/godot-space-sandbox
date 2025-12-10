extends Control

##
# Offset Constants - used for building out the star system map using normalized vector offsets for relative positioning on the screen
##

const CENTER : float = 0.0

const LEFTMOST: float = -0.5
const LEFT: float = -0.25 
const CENTERLEFT : float = -0.125
 
const CENTERRIGHT : float = 0.125
const RIGHT : float = 0.25
const RIGHTMOST : float = 0.5

const UPMOST: float = -0.5
const UP: float = -0.25
const CENTERUP : float = -0.125

const CENTERDOWN : float = 0.125
const DOWN : float = 0.25
const DOWNMOST : float = 0.5
	
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

@onready var sectors : Array[SectorRingUI] = [
	$Sectors/SectorRingUI1,
	$Sectors/SectorRingUI2, 
	$Sectors/SectorRingUI3,
	$Sectors/SectorRingUI4,
	$Sectors/SectorRingUI5,
	$Sectors/SectorRingUI6,
	$Sectors/SectorRingUI7,
	$Sectors/SectorRingUI8,
	$Sectors/SectorRingUI9,
	$Sectors/SectorRingUI10, 
	$Sectors/SectorRingUI11,
	$Sectors/SectorRingUI12,
	$Sectors/SectorRingUI13,
	$Sectors/SectorRingUI14,
	$Sectors/SectorRingUI15,
	$Sectors/SectorRingUI16,
	$Sectors/SectorRingUI17,
	$Sectors/SectorRingUI18, 
	$Sectors/SectorRingUI19,
	$Sectors/SectorRingUI20,
	$Sectors/SectorRingUI21
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	layoutSectors()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func layoutSectors() -> void:
	var center = size * 0.5
	var radius = min(size.x, size.y) * 0.5
	for i in range(sectors.size()):
		placeSector(i, center, radius)
	
func placeSector(index : int, center : Vector2, radius : float) -> void:
	sectors[index].position = center + offsets[index] * radius