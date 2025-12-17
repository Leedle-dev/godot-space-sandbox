extends Node2D
class_name SectorRingNode

@export var gateRects : Array[Sprite2D]
@onready var nameLabel : Label = $SectorName_SectorView
@onready var nameLabelStar : Label = $SectorName_StarView


func setGateVisibility(sector: SectorInfo):
	for i in range(8):
		gateRects[i].visible = sector.discovered[i]


func setSectorName(sector: SectorInfo):
	nameLabel.text = sector.name

func _draw():
	draw_circle(Vector2.ZERO, 50, Color.RED)