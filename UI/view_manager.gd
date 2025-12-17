extends Node2D
class_name ViewManager

enum MODE {GAMEPLAY, TACTICAL, STAR, GALAXY}

const TWEEN_DURATION : float = 0.7

var currentMode : MODE
var previousMode : MODE
var camera : PCam2DController
@onready var backgroundLayer : CanvasLayer = $BackgroundLayer
@onready var background : ColorRect = $BackgroundLayer/Background
@onready var tacticalMapLayer : CanvasLayer = $TacticalMapLayer
@onready var sectorRingMapElement : SectorRingMapElement = $TacticalMapLayer/SectorRingMapElement
@onready var sectorRing : SectorRing = sectorRingMapElement.sectorRingUI.sectorRing
@onready var starMapLayer : CanvasLayer = $StarMapLayer
@onready var starMapUI : StarSystemUINode = $StarMapLayer/StarSystemUINode
@onready var starMap : Node2D = starMapUI.starSystem


var switchingLayers : bool = false
#var sectorRing : SectorRingUI



#var starMapControl : StarSystemUINode
#var starMap
var starMapOriginalPosition


var tween : Tween

var zoomFocus: Vector2
var zoomCenter: Vector2
var zoomBasePosition: Vector2
var zoomTarget: Node2D

var transitionID := 0

func switchMode(mode : MODE):
	if mode == currentMode:
		return
	transitionID += 1
	currentMode = mode
	resetTween()
	var id := transitionID
	call_deferred("buildTransition", currentMode, id)
	"""match currentMode:

		
		MODE.GAMEPLAY:
			#sectorRing.fadeOut()
			resetTween()
			print("Tween class:", tween.get_class())
			fade(sectorRing, 0.0, TWEEN_DURATION)
			scale(sectorRing, 1.0, 2.0, TWEEN_DURATION, true)
			fadeColor(background, 0.0)
			previousMode = currentMode
		MODE.TACTICAL:
			#sectorRing.fadeIn()
			resetTween()
			print("Tween class:", tween.get_class())
			if previousMode == MODE.GAMEPLAY:
				#tween.parallel()
				fade(sectorRing, 1.0, TWEEN_DURATION)
				scale(sectorRing, 2.0, 1.0, TWEEN_DURATION, true)
				fade(starMap, 0.0, TWEEN_DURATION, true)
				scale(starMap, 1.0, 4.0, TWEEN_DURATION, true)
				fadeColor(background, 1.0)
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
			print("Tween class:", tween.get_class())
			starMapOriginalPosition = starMap.position
			fade(sectorRing, 0.0, TWEEN_DURATION)
			scale(sectorRing, 1.0, 0.25, TWEEN_DURATION, true)
			fade(starMap, 1.0, TWEEN_DURATION, true)
			tween.parallel().tween_method(Callable(self, "setZoomScale"),  4.0, 1.0, TWEEN_DURATION)
			previousMode = currentMode
			pass
		MODE.GALAXY:
			pass
	"""
func setZoomScale(value : float):
	zoomTarget.scale = Vector2(value,value)
	zoomTarget.position = zoomBasePosition + (zoomFocus - zoomCenter) * (1.0 - value)

func changeView(mode : MODE):
	pass

func buildTransition(currentState: MODE, id: int):
	if id != transitionID:
		return
	if not tween or not tween.is_valid():
		return
	match currentState:
		MODE.GAMEPLAY:
			#sectorRing.fadeOut()
			#resetTween()
			#print("Tween class:", tween.get_class())
			tween.set_parallel()
			fade(sectorRingMapElement, 0.0, TWEEN_DURATION)
			scale(sectorRing, 1.0, 2.0, TWEEN_DURATION)
			fadeColorRect(background, 0.0, false)
			previousMode = currentMode
		MODE.TACTICAL:
			#sectorRing.fadeIn()
			#resetTween()
			#print("Tween class:", tween.get_class())
			if previousMode == MODE.GAMEPLAY:
				tween.set_parallel()
				fade(sectorRingMapElement, 1.0, TWEEN_DURATION)
				scale(sectorRing, 2.0, 1.0, TWEEN_DURATION)
				#fade(starMap, 0.0, TWEEN_DURATION, true)
				#scale(starMap, 1.0, 4.0, TWEEN_DURATION, true)
				fadeColorRect(background, 1.0, false)
			elif previousMode == MODE.STAR:
				#tween.set_parallel()
				#fade(sectorRing, 1.0, TWEEN_DURATION)
				tween.parallel().tween_property(sectorRing, "modulate:a", 1.0, TWEEN_DURATION)
				#scale(sectorRing, 0.25, 1.0, TWEEN_DURATION, false)
				tween.parallel().tween_property(sectorRing, "scale", Vector2(1.0, 1.0), TWEEN_DURATION)
				#fade(starMap, 0.0, TWEEN_DURATION, false)
				tween.parallel().tween_property(starMap, "modulate:a", 0.0, TWEEN_DURATION)
				tween.parallel().tween_method(Callable(self, "setZoomScale"),  1.0, 4.0, TWEEN_DURATION)
				#scale(starMap, 1.0, 4.0, TWEEN_DURATION, true)
				#shift(starMap, starMapOriginalPosition, TWEEN_DURATION, true)
			previousMode = currentMode
		MODE.STAR:
			#starMap.position = starMap.originalPosition
			starMap.position = starMapOriginalPosition
			starMap.scale = Vector2(4,4)
			zoomTarget = starMap
			#zoomCenter = starMap.size * 0.5
			zoomCenter = starMapUI.size * 0.5
			#var radius = starMap.radius
			var radius = starMapUI.radius
			var normalized := starMapUI.offsets[20]
			zoomFocus = zoomCenter + normalized * radius
			zoomBasePosition = starMap.position + (zoomCenter - zoomFocus)
			#resetTween()
			#print("Tween class:", tween.get_class())
			starMapOriginalPosition = starMap.position
			#tween.set_parallel()
			#fade(sectorRing, 0.0, TWEEN_DURATION)
			tween.parallel().tween_property(sectorRing, "modulate:a", 0.0, TWEEN_DURATION)
			#scale(sectorRing, 1.0, 0.25, TWEEN_DURATION)
			tween.parallel().tween_property(sectorRing, "scale", Vector2(0.25, 0.25), TWEEN_DURATION)
			#fade(starMap, 1.0, TWEEN_DURATION)
			tween.parallel().tween_property(starMap, "modulate:a", 1.0, TWEEN_DURATION)
			tween.parallel().tween_method(Callable(self, "setZoomScale"),  4.0, 1.0, TWEEN_DURATION)
			previousMode = currentMode
		MODE.GALAXY:
			pass
	#tween.finished.connect(func():
	#	if id != transitionID:
	#		return  # stale tween, ignore
	#	finalizeMode(currentState)
	#)

#var tween := create_tween()
"""	
var tweens := {}

func killTween(node : Control):
	if tweens.has(node):
		if tweens[node].is_valid():
			tweens[node].kill()
	tweens[node] = null
"""
func finalizeMode(mode : MODE):
	match mode:
		MODE.GAMEPLAY:
			sectorRing.modulate.a = 0.0
			starMap.modulate.a = 0.0
			background.color.a = 0.0
		MODE.TACTICAL:
			sectorRing.modulate.a = 1.0
			background.color.a = 1.0
			starMap.modulate.a = 0.0
		MODE.STAR:
			starMap.modulate.a = 1.0
			sectorRing.modulate.a = 0.0
			background.color.a = 1.0
		MODE.GALAXY:
			pass

func resetTween() -> void:
	if tween && tween.is_valid():
		tween.kill()
	#tween = null
	call_deferred("createTween")

func createTween() -> void:
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
		tween.parallel().tween_property(variant, "color:a", alpha, duration)
	else:
		tween.tween_property(variant, "color:a", alpha, duration)
	#tweenVar.tween_property(variant, "scale", Vector2(endScale, endScale), duration)

func fadeColorRect(variant : ColorRect, alpha := 0.0,  parallel := true, duration := TWEEN_DURATION):
	if parallel:
		tween.parallel().tween_property(variant, "color:a", alpha, duration)
	else:
		tween.tween_property(variant, "color:a", alpha, duration)

func scale(variant : Node2D,  startScale := 0.25, endScale : = 1.0, duration := 0.4, parallel := false):
	variant.scale = Vector2(startScale, startScale)
	if parallel:
		tween.parallel().tween_property(variant, "scale", Vector2(endScale, endScale), duration)
	else:
		tween.tween_property(variant, "scale", Vector2(endScale, endScale), duration)
	#return tween_property(variant, "scale", Vector2(endScale, endScale), duration)

func shift(variant : Node2D, pixelShift := Vector2(0,0), duration := 0.3, parallel := false):
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
	background.color = ProjectSettings.get_setting("rendering/environment/defaults/default_clear_color");
	background.color.a = 0.0
	starMapOriginalPosition = starMap.position



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		pass

	
