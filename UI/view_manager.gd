extends Node2D
class_name ViewManager

enum MODE {GAMEPLAY, TACTICAL, STAR, GALAXY}

const TWEEN_DURATION : float = 0.8

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
var starMapOriginalPosition


var tween : Tween

var zoomFocus: Vector2
var zoomCenter: Vector2
var zoomBasePosition: Vector2
var zoomTarget: Control

func switchMode(mode : MODE):
	currentMode = mode
	match currentMode:
		MODE.GAMEPLAY:
			#sectorRing.fadeOut()
			resetTween()
			fade(sectorRing, 0.0, TWEEN_DURATION)
			scale(sectorRing, 1.0, 2.0, TWEEN_DURATION, true)
			previousMode = currentMode
		MODE.TACTICAL:
			#sectorRing.fadeIn()
			resetTween()
			if previousMode == MODE.GAMEPLAY:
				#tween.parallel()
				fade(sectorRing, 1.0, TWEEN_DURATION)
				scale(sectorRing, 2.0, 1.0, TWEEN_DURATION, true)
				fade(starMap, 0.0, TWEEN_DURATION, true)
				scale(starMap, 1.0, 4.0, TWEEN_DURATION, true)
			elif previousMode == MODE.STAR:
				#tween.parallel()
				fade(sectorRing, 1.0, TWEEN_DURATION)
				scale(sectorRing, 0.25, 1.0, TWEEN_DURATION, true)
				fade(starMap, 0.0, TWEEN_DURATION, true)
				tween.parallel().tween_method(Callable(self, "setZoomScale"),  1.0, 4.0, TWEEN_DURATION)
				#scale(starMap, 1.0, 4.0, TWEEN_DURATION, true)
				#shift(starMap, starMapOriginalPosition, TWEEN_DURATION, true)
			previousMode = currentMode
		MODE.STAR:
			starMap.position = starMap.originalPosition
			starMap.scale = Vector2(4,4)
			zoomTarget = starMap
			zoomCenter = starMap.size * 0.5
			var radius = starMap.radius
			var normalized := starMap.offsets[20]
			zoomFocus = zoomCenter + normalized * radius
			zoomBasePosition = starMap.position + (zoomCenter - zoomFocus)
			resetTween()
			starMapOriginalPosition = starMap.position
			fade(sectorRing, 0.0, TWEEN_DURATION)
			scale(sectorRing, 1.0, 0.25, TWEEN_DURATION, true)
			fade(starMap, 1.0, TWEEN_DURATION, true)
			tween.parallel().tween_method(Callable(self, "setZoomScale"),  4.0, 1.0, TWEEN_DURATION)
			previousMode = currentMode
			pass
		MODE.GALAXY:
			pass

func setZoomScale(value : float):
	zoomTarget.scale = Vector2(value,value)
	zoomTarget.position = zoomBasePosition + (zoomFocus - zoomCenter) * (1.0 - value)

func changeView(mode : MODE):
	pass

#var tween := create_tween()
"""	
var tweens := {}

func killTween(node : Control):
	if tweens.has(node):
		if tweens[node].is_valid():
			tweens[node].kill()
	tweens[node] = null
"""
func resetTween() -> void:
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	#var returnee
	#if parallel:
	#	returnee = create_tween().set_parallel(parallel)
	#else:
	#	returnee = create_tween()
	#return returnee

func fade(variant : Control, alpha := 0.0, duration := 0.4, parallel := false):
	#killTween(variant)
	#var tween = resetTween(true)
	#tweens[variant] = tween
	#variant.scale = Vector2(startScale, startScale)
	#tween.set_ease(Tween.EASE_OUT)
	if parallel:
		tween.parallel().tween_property(variant, "modulate:a", alpha, duration)
	else:
		tween.tween_property(variant, "modulate:a", alpha, duration)
	#tweenVar.tween_property(variant, "scale", Vector2(endScale, endScale), duration)

func scale(variant : Control,  startScale := 0.25, endScale : = 1.0, duration := 0.4, parallel := false):
	variant.scale = Vector2(startScale, startScale)
	if parallel:
		tween.parallel().tween_property(variant, "scale", Vector2(endScale, endScale), duration)
	else:
		tween.tween_property(variant, "scale", Vector2(endScale, endScale), duration)
	#return tween_property(variant, "scale", Vector2(endScale, endScale), duration)

func shift(variant : Control, pixelShift := Vector2(0,0), duration := 0.3, parallel := false):
	#killTween(variant)
	#var tween = resetTween()
	#tweens[variant] = tween
	if parallel:
		tween.parallel().tween_property(variant, "position", pixelShift, duration)
	else:
		tween.tween_property(variant, "position", pixelShift, duration)
	variant.position = pixelShift
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentMode = MODE.GAMEPLAY



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		pass

	
