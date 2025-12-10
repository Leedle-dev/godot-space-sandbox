extends Control
class_name SectorRingMapElement

@onready var sectorRing : SectorRingUI = $SectorRingUI
@onready var background : ColorRect = $Background

var default_clear_color
var tween := create_tween()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_clear_color = ProjectSettings.get_setting("rendering/environment/defaults/default_clear_color");
	background.color = default_clear_color
	background.color.a = 0.0

func fadeOut(duration := 1.0):
	resetTween()
	tween.tween_property(background, "modulate:a", 0.0, duration)

func fadeIn(duration := 1.0):
	resetTween()
	tween.tween_property(background, "color:a", 1.0, duration).set_trans(Tween.TRANS_LINEAR)
	
func resetTween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
