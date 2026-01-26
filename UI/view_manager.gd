extends Node2D
class_name ViewManager

enum MODE {GAMEPLAY, TACTICAL, STAR, GALAXY}

const TWEEN_DURATION : float = 0.45
const BASEGALAXYZOOM : float = 0.5
const LIMITGALAXYZOOM : float = 0.0667

var camera : PCam2DController

@onready var backgroundLayer : CanvasLayer = $BackgroundLayer
@onready var background : ColorRect = $BackgroundLayer/Background
var default_clear_color

@onready var tacticalMapLayer : CanvasLayer = $TacticalMapLayer
@onready var sectorRing : SectorRingMapElement = $TacticalMapLayer/SectorRingMapElement
@onready var starMapLayer : CanvasLayer = $StarMapLayer
@onready var starMap : StarSystemUI = $StarMapLayer/StarSystemUI
@onready var galaxyMap : GalaxyMapUI = $StarMapLayer/GalaxyMapUI
@onready var panelLayer : CanvasLayer = $PanelLayer
@onready var infoPanel : InfoPanel = $PanelLayer/InfoPanel
#var colorRect : ColorRect

var switchingLayers : bool = false
#var sectorRing : SectorRingUI




var starMapOriginalPosition

var currentMode : MODE
var targetMode : MODE
var tween : Tween
var isTweening : bool = false
#
#var zoomFocus: Vector2
#var zoomCenter: Vector2
#var zoomBasePosition: Vector2
#var zoomTarget: Control

var currentSectorIndex : int = 0

func doneTween():
	isTweening = false
	currentMode = targetMode
	if currentMode == MODE.GAMEPLAY:
		currentSectorIndex = starMap.getNextValidIndex(currentSectorIndex)

func hideGalaxyUI():
	galaxyMap.setVisible(false)

func switchMode(mode : MODE, isZoomIn : bool):
	if isTweening:
		return
	targetMode = mode
	match targetMode:
		MODE.GAMEPLAY:
			resetTween()
			fadeColor(background)
			fade(starMap, 0.0, TWEEN_DURATION, true)
			setupStarZoom()
			tween.parallel().tween_method(Callable(self, "setZoomScaleStar"),  4.0, 8.0, TWEEN_DURATION)
			tween.finished.connect(doneTween)
		MODE.TACTICAL:
			resetTween()
			fadeColor(background, 1.0)
			fade(starMap, 1.0, TWEEN_DURATION, true)
			fade(starMap.sectors[currentSectorIndex].sectorRing.nameLabel, 1.0, TWEEN_DURATION, true)
			fade(starMap.sectors[currentSectorIndex].sectorRing.nameLabelStar, 0.0, TWEEN_DURATION, true)
			setupStarZoom()
			if not isZoomIn:
				starMap.sectors[currentSectorIndex].sectorRing.nameLabelStar.modulate.a = 0.0
				fadeArray(starMap.sectors, 0.0, TWEEN_DURATION/2, true, currentSectorIndex)
				fade(starMap.sectors[currentSectorIndex], 1.0, TWEEN_DURATION, true)
				tween.parallel().tween_method(Callable(self, "setZoomScaleStar"),  8.0, 4.0, TWEEN_DURATION)
			else:
				fadeArray(starMap.sectors, 0.0, TWEEN_DURATION, true, currentSectorIndex)
				tween.parallel().tween_method(Callable(self, "setZoomScaleStar"),  1.0, 4.0, TWEEN_DURATION)
			tween.finished.connect(doneTween)
		MODE.STAR:
			resetTween()
			galaxyMap.setInput(false)
			starMapOriginalPosition = starMap.position
			fade(starMap.sectors[currentSectorIndex].sectorRing.nameLabel, 0.0, TWEEN_DURATION, true)
			fade(starMap.sectors[currentSectorIndex].sectorRing.nameLabelStar, 1.0, TWEEN_DURATION, true)
			fadeArray(starMap.sectors, 1.0, TWEEN_DURATION, true)
			fade(starMap, 1.0, TWEEN_DURATION, true)
			setupStarZoom()
			if not isZoomIn:
				fade(sectorRing, 0.0, TWEEN_DURATION, true)
				scale(sectorRing, 1.0, 0.25, TWEEN_DURATION, true)
				tween.parallel().tween_method(Callable(self, "setZoomScaleStar"),  4.0, 1.0, TWEEN_DURATION)
			else:
				fade(galaxyMap, 0.0, TWEEN_DURATION, true)
				tween.parallel().tween_method(Callable(self, "setZoomScaleGalaxy"), galaxyMap.mapContainer.scale.x, 4.0, TWEEN_DURATION)
				tween.parallel().tween_method(Callable(self, "setZoomScaleStar"),  0.5, 1.0, TWEEN_DURATION)
			tween.finished.connect(doneTween)
			tween.finished.connect(hideGalaxyUI)
			#galaxyMap.setVisible(false)	
		MODE.GALAXY:
			resetTween()
			galaxyMap.setVisible(true)
			fade(starMap, 0.0, TWEEN_DURATION) # Fade Out StarMap
			setupStarZoom() # Set zoomtarget to 
			tween.parallel().tween_method(Callable(self, "setZoomScaleStar"),  1.0, 0.5, TWEEN_DURATION)

			fade(galaxyMap, 1.0, TWEEN_DURATION, true)
			setupGalaxyZoom()
			tween.parallel().tween_method(Callable(self, "setZoomScaleGalaxy"), 4.0, BASEGALAXYZOOM, TWEEN_DURATION)
			tween.finished.connect(doneTween)
			galaxyMap.setInput(true)
			#pass

## Zooming logic, called by the playerController on mousewheel input.
## mousePosition is a system call the gets the mouseposition
## direction is an int to indicate mouse scroll up (1) or down (-1)
var galaxyZoomScale : Vector2
"""
func galaxyZoom(mousePosition: Vector2, direction: int):
	galaxyZoomScale = galaxyMap.mapContainer.scale
	# Mouse wheel up, zoom in
	if direction > 0:
		# If we are as zoomed in as possible, shift back to star map
		if galaxyMap.mapContainer.scale.x * 1.1 > BASEGALAXYZOOM:
			
		else:
			setZoomScaleGalaxy(galaxyZoomScale.x * 1.1)
	elif direction < 0:
		#if galaxyMap.mapContainer.scale.x > 0.25:
			setZoomScaleGalaxy(galaxyZoomScale.x * 0.9)
			#scale(galaxyMap.mapContainer, galaxyMap.mapContainer.scale.x, galaxyMap.mapContainer.scale.x*0.9, 0.05, false)
			#tween.finished.connect(doneTween)
"""
func panGalaxy(delta: Vector2):
	galaxyMapFocus -= delta / galaxyMap.mapContainer.scale.x
	applyGalaxyTransform()

func applyGalaxyTransform():
	galaxyMap.mapContainer.position = galaxyMapCenter - galaxyMapFocus * galaxyMap.mapContainer.scale.x

func zoomIn() -> void:
	match currentMode:
		MODE.GAMEPLAY:
			return
		MODE.TACTICAL:
			switchMode(MODE.GAMEPLAY, true)
		MODE.STAR:
			switchMode(MODE.TACTICAL, true)
		MODE.GALAXY:
			if galaxyMap.mapContainer.scale.x * 1.1 > BASEGALAXYZOOM:
				switchMode(MODE.STAR, true)
			else:
				setZoomScaleGalaxy(galaxyMap.mapContainer.scale.x * 1.1)

func zoomOut() -> void:
	match currentMode:
		MODE.GAMEPLAY:
			switchMode(MODE.TACTICAL, false)
		MODE.TACTICAL:
			switchMode(MODE.STAR, false)
		MODE.STAR:
			switchMode(MODE.GALAXY, false)
		MODE.GALAXY:
			if galaxyMap.mapContainer.scale.x * 0.9 < LIMITGALAXYZOOM:
				return
			else:
				setZoomScaleGalaxy(galaxyMap.mapContainer.scale.x * 0.9)

var starMapFocus : Vector2
var starMapBasePosition : Vector2
var starMapCenter : Vector2
func setupStarZoom():
	starMap.position = starMap.originalPosition
	#starMap.scale = Vector2(4,4) This line is being overwritten in setZoomScaleStar()
	starMapCenter = starMap.size * 0.5
	starMapFocus = starMapCenter + starMap.offsets[currentSectorIndex] * starMap.radius
	starMapBasePosition = starMap.position + (starMapCenter - starMapFocus)

var galaxyMapFocus : Vector2
var galaxyMapBasePosition : Vector2
var galaxyMapCenter : Vector2
func setupGalaxyZoom():
	print_debug("getting random star system")
	print_debug("galaxy.mapcontainer.size = " + str(galaxyMap.mapContainer.size))
	galaxyMapCenter = get_viewport_rect().size * 0.5
	var marker = galaxyMap.markers.get_child(
		randi_range(
			0, galaxyMap.markers.get_child_count()-1
		)
	)
	galaxyMapFocus = marker.position + marker.texture.size * 0.5
	galaxyMapBasePosition = galaxyMap.mapContainer.position + (galaxyMapCenter - galaxyMapFocus)
	

func setZoomScaleStar(value : float):
	setupStarZoom()
	starMap.scale = Vector2(value,value)
	starMap.position = starMapBasePosition + (starMapFocus - starMapCenter) * (1.0 - value)

func setZoomScaleGalaxy(value : float):
	#setupGalaxyZoom()
	galaxyMap.mapContainer.scale = Vector2(value,value)
	#galaxyMap.mapContainer.position = galaxyMapBasePosition + (galaxyMapFocus - galaxyMapCenter) * (1.0 - value)
	galaxyMap.mapContainer.position = galaxyMapCenter - galaxyMapFocus * value



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
	isTweening = true
	#var returnee
	#if parallel:
	#	returnee = create_tween().set_parallel(parallel)
	#else:
	#	returnee = create_tween()
	#return returnee

func fadeArray(variant : Array[SectorRingUI], alpha := 0.0, duration:= 0.4, parallel := false, exclude := -1):
	for i in range(variant.size()):
		if exclude != i:
			fade(variant[i], alpha, duration, parallel)
	pass

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

func fadeColor(variant : Control, alpha := 0.0, duration := TWEEN_DURATION, parallel := true):
	if parallel:
		tween.parallel().tween_property(variant, "color:a", alpha, duration)
	else:
		tween.tween_property(variant, "color:a", alpha, duration)

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
	default_clear_color = ProjectSettings.get_setting("rendering/environment/defaults/default_clear_color");
	background.color = default_clear_color
	background.color.a = 0.0
	starMap.position = starMap.originalPosition
	starMap.scale = Vector2(4,4)
	galaxyMap.ringClicked.connect(openInfoPanel)

var exampleModel = {
	"title": "Galaxy Ring: INNER",
	"sections": [
		{"header":"Summary","rows":[
			{"type":"kv","k":"Systems","v":"12"},
		]},
		{"header":"Star Systems","rows":[
			{"type":"button","text":"Sol","action":"open_system","id":"sol"},
			{"type":"button","text":"Tau Ceti","action":"open_system","id":"sol"},
			{"type":"button","text":"Volton","action":"open_system","id":"sol"},
			{"type":"button","text":"Scarabis","action":"open_system","id":"sol"}
		]}
	]
}

func openInfoPanel(layer) -> void:
	print_debug("open info panel called")
	infoPanel.openPanelWithData(exampleModel)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		pass

	
