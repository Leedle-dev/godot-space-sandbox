extends Control
class_name SectorRingMapElement

@onready var centerContainer : CenterContainer = $CenterContainer
@onready var sectorRingUI : SectorRingUI = $CenterContainer/SectorRingUI
@onready var background : ColorRect = $Background

var default_clear_color
var tween := create_tween()

@export var scaleSize: float = 4.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_clear_color = ProjectSettings.get_setting("rendering/environment/defaults/default_clear_color");
	background.color = default_clear_color
	background.color.a = 1.0
	self.modulate.a = 0.0
	pivot_offset = size / 2
	sectorRingUI.scaleElements(Vector2(scaleSize,scaleSize))
	sectorRingUI.custom_minimum_size = Vector2(sectorRingUI.custom_minimum_size * scaleSize)

func fadeOut(duration := 0.5, endScale:= 0.05):
	resetTween(true)
	scale = Vector2(1,1)
	tween.tween_property(self, "modulate:a", 0.0, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2(endScale, endScale), duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

func fadeIn(duration := 0.5, startScale := 0.05):
	resetTween(true)
	scale = Vector2(startScale, startScale)
	tween.tween_property(self, "modulate:a", 1.0, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1,1), duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
func resetTween(parallel : bool = false) -> void:
	if tween:
		tween.kill()
	if parallel:
		tween = create_tween().set_parallel(parallel)
	else:
		tween = create_tween()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
