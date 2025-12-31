extends Control
class_name StarSystemUI

##
# Offset Constants - used for building out the star system map using normalized vector offsets for relative positioning on the screen
##

@export var starSystemInfo : SystemInfo

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
	self.modulate.a = 0.0
	for sector in sectors:
		sector.modulate.a = 0.0
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
		if starSystemInfo.sectors[i] != null:
			sectors[i].sectorRing.setSectorName(starSystemInfo.sectors[i])
			sectors[i].sectorRing.nameLabel.modulate.a = 0.0
			sectors[i].sectorRing.nameLabelStar.modulate.a = 1.0
		else:
			sectors[i].sectorRing.visible = false

	
func placeSector(index : int, center : Vector2, radius : float) -> void:
	sectors[index].position = center + offsets[index] * radius

func getNextValidIndex(currentIndex : int) -> int:
	for i in range(starSystemInfo.sectors.size()):
		#if i + currentIndex + 1 >= starSystemInfo.sectors.size():
		#	print_debug("i (" + str(i) + ") greater than size. setting i to " + str(starSystemInfo.sectors.size() - (currentIndex + 1)))
		#	i = starSystemInfo.sectors.size() - (currentIndex + 1)
		if starSystemInfo.sectors[(i + currentIndex + 1) % starSystemInfo.sectors.size()] != null:
			return (i + currentIndex + 1) % starSystemInfo.sectors.size()
	return 0
