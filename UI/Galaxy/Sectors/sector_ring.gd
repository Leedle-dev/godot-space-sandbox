extends Control

@export var gateRects : Array[TextureRect]

func setGateVisibility(sector: SectorInfo):
	for i in range(8):
		gateRects[i].visible = sector.discovered[i]
