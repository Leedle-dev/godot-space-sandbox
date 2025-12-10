extends Node2D
class_name SectorRing

@export var gateRects : Array[TextureRect]
@onready var nameLabel : Label = $SectorName_SectorView
@onready var nameLabelStar : Label = $SectorName_StarView


func setGateVisibility(sector: SectorInfo):
	for i in range(8):
		gateRects[i].visible = sector.discovered[i]


func setSectorName(sector: SectorInfo):
	nameLabel.text = sector.name
