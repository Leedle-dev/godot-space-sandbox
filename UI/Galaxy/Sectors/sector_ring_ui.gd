extends Control
class_name SectorRingUI

@export var gateRects : Array[TextureRect]
@onready var nameLabel : Label = $SectorName


func setGateVisibility(sector: SectorInfo):
	for i in range(8):
		gateRects[i].visible = sector.discovered[i]

func setSectorName(sector: SectorInfo):
	nameLabel.text = sector.name
