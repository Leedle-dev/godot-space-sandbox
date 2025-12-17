extends Control
class_name SectorRingUI

@onready var sectorRing : SectorRing = $SectorRing
@onready var sectorRingNode : SectorRingNode = $SectorRingNode


func scaleElements(scale : Vector2 = Vector2(1,1)) -> void:
	sectorRing.scale = scale

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sectorRingNode.position = size * 0.5
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
