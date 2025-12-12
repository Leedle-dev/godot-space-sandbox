extends Node2D
class_name ViewManager

enum MODE {GAMEPLAY, TACTICAL, STAR, GALAXY}

const TWEEN_DURATION : float = 1.5

var currentMode : MODE
var previousMode : MODE
var camera : PCam2DController
var tacticalMapLayer : CanvasLayer
var starMapLayer : CanvasLayer
#var colorRect : ColorRect

var switchingLayers : bool = false
#var sectorRing : SectorRingUI

var sectorRing : SectorRingMapElement

var starMap : StarSystemUI




func switchMode(mode : MODE):
	currentMode = mode
	match currentMode:
		MODE.GAMEPLAY:
			#sectorRing.fadeOut()
			resetTween(true)
			fade(sectorRing, 0.0, TWEEN_DURATION, 1.0, 2.0)
			previousMode = currentMode
		MODE.TACTICAL:
			#sectorRing.fadeIn()
			resetTween(true)
			if previousMode == MODE.GAMEPLAY:
				fade(sectorRing, 1.0, TWEEN_DURATION, 2.0, 1.0)
				fade(starMap, 0.0, TWEEN_DURATION, 1.0, 4.0)
			elif previousMode == MODE.STAR:
				fade(sectorRing, 1.0, TWEEN_DURATION, 0.25, 1.0)
				fade(starMap, 0.0, TWEEN_DURATION, 1.0, 4.0)
			previousMode = currentMode
		MODE.STAR:
			resetTween(true)
			var offset = starMap.offsets[7] * starMap.radius
			#shift(starMap, offset, 1.0)
			starMap.position = offset
			#starMap.pivot_offset = offset
			#await tweens[starMap].finished
			fade(sectorRing, 0.0, TWEEN_DURATION, 1.0, 0.25)
			fade(starMap, 1.0, TWEEN_DURATION, 4.0, 1.0)
			previousMode = currentMode
			pass
		MODE.GALAXY:
			pass

func changeView(mode : MODE):
	pass

#var tween := create_tween()
	
var tweens := {}

func killTween(node : Control):
	if tweens.has(node):
		if tweens[node].is_valid():
			tweens[node].kill()
	tweens[node] = null

func resetTween(parallel : bool = false) -> Tween:
	var returnee
	if parallel:
		returnee = create_tween().set_parallel(parallel)
	else:
		returnee = create_tween()
	return returnee

func fade(variant : Control, alpha := 0.0, duration := 0.4, startScale := 0.25, endScale : = 1.0):
	killTween(variant)
	var tween = resetTween(true)
	tweens[variant] = tween
	variant.scale = Vector2(startScale, startScale)
	tween.set_trans(Tween.TRANS_CUBIC)
	#tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(variant, "modulate:a", alpha, duration)
	tween.tween_property(variant, "scale", Vector2(endScale, endScale), duration)

func shift(variant : Control, pixelShift := Vector2(0,0), duration := 0.3):
	killTween(variant)
	var tween = resetTween()
	tweens[variant] = tween
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(variant, "position", pixelShift, duration)
	variant.position = pixelShift
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentMode = MODE.GAMEPLAY



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		pass

	
