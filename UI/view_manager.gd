extends Node2D
class_name ViewManager

enum MODE {GAMEPLAY, TACTICAL, STAR, GALAXY}

var currentMode : MODE
var camera : PCam2DController
var tacticalMapLayer : CanvasLayer
#var colorRect : ColorRect

var switchingLayers : bool = false
#var sectorRing : SectorRingUI

var sectorRing : SectorRingMapElement


func switchMode(mode : MODE):
	currentMode = mode
	match currentMode:
		MODE.GAMEPLAY:
			sectorRing.fadeOut()
		MODE.TACTICAL:
			sectorRing.fadeIn()
		MODE.STAR:
			pass
		MODE.GALAXY:
			pass

func changeView(mode : MODE):
	pass


	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentMode = MODE.GAMEPLAY



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		pass

	
