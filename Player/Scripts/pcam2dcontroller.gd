## Main Camera 2D script of the player in the viewport of the game.
## Currently using Phantom Camera, an awesome addon that essentially allows easily swapping to specific cameras.
## The Phantom Cameras support free panning modes, follow modes, strict follow, and group follow modes. 
## The transition between cameras is pre-implemented with Tweens that can easily be adjusted in the editor.
## Camera states can easily be tracked for logic purposes, and be adjusted depending on player input, creating smooth camera transitions.

## TODO Refactor and implement into player UI (whenever that's a thing)
## Maybe shift some camera swaps to signals, and compress with some methods.
## Review dragLevels. These are just hard coded values for panning the screen.

extends Camera2D
class_name PCam2DController
#                                                     0                               1                         2                          3                         4                      5                   6           7
# Previous vectors. Zoom too far with tac map and smaller scale ships. Vector2(0.0078125,0.0078125), Vector2(0.015625,0.015625), Vector2(0.03125,0.03125), Vector2(0.0625, 0.0625),
# Previous Drag. 64.0, 32.0, 16.0, 8.0,
#                                                   0                   1                    2                 3                 4                  5                6           
static var zoomLevels = PackedVector2Array([ Vector2(0.125,0.125), Vector2(0.25,0.25), Vector2(0.5,0.5), Vector2(1.0,1.0), Vector2(2.0,2.0), Vector2(4.0,4.0), Vector2(8.0,8.0)])
static var dragLevels = PackedFloat64Array([4.0, 2.0, 1.0, 0.5, 0.25, 0.125, 0.0625])

var focusUI : bool = false

var currentZoomIndex = 3
var minIndex = 0
var maxIndex = zoomLevels.size() - 1
var targetZoom : Vector2 = zoomLevels[currentZoomIndex]

@export var pCamHost : PhantomCameraHost
@export var pCam2dNoFollow : PhantomCamera2D
@export var pCam2dGlued : PhantomCamera2D
@export var pCam2dGroup : PhantomCamera2D
@export var pCam2dSimpleFollow : PhantomCamera2D
@export var pCam2dGroupFollow : PhantomCamera2D

var currentPCam : PhantomCamera2D

signal zoomChanged(value)

func changeZoom(event : InputEvent) -> void:
	pass

func zoomIn():
	if (currentZoomIndex < maxIndex):
		currentZoomIndex += 1
		targetZoom = zoomLevels[currentZoomIndex]
		zoomChanged.emit()

func zoomOut():
	if (currentZoomIndex > minIndex):
		currentZoomIndex -= 1
		targetZoom = zoomLevels[currentZoomIndex]
		zoomChanged.emit()

func activatePCam(pcam : PhantomCamera2D):
	pcam.priority = 10
	currentPCam = pcam
	
func swapPCamNoFollow():
	activatePCam(pCam2dNoFollow)

func swapPCamGlued():
	activatePCam(pCam2dGlued)

func swapPCamGroup():
	activatePCam(pCam2dGroup)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentPCam = pCam2dNoFollow
	
## TODO - refactor to not call every frame.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	setZoom(delta, pCam2dNoFollow)
	setZoom(delta, pCam2dGlued)
	setZoom(delta, pCam2dGroup)
	setZoom(delta, pCam2dSimpleFollow)
	setZoom(delta, pCam2dGroupFollow)
	#global_position = global_position.round()
	#roundCam(pCam2dNoFollow)
	#roundCam(pCam2dGlued)
	#roundCam(pCam2dGroup)
	#roundCam(pCam2dSimpleFollow)
	#roundCam(pCam2dGroupFollow)
	
func setZoom(delta : float, pcam : PhantomCamera2D):
	if (!(pcam.get_zoom().is_equal_approx(targetZoom))):
		pcam.set_zoom(pcam.get_zoom().lerp(targetZoom, delta * 4))
	else:
		pcam.set_zoom(targetZoom)

func roundCam(pcam : PhantomCamera2D):
	pcam.global_position = pcam.global_position.round()

# ty rybadour
# https://forum.godotengine.org/t/how-to-drag-camera-with-mouse/28508/2


var _previousPosition: Vector2 = Vector2(0, 0);
var _moveCamera: bool = false;


func registerLMBHold(event : InputEvent):
	get_viewport().set_input_as_handled();
	if event.is_pressed():
		_previousPosition = event.position;
		_moveCamera = true;
	else:
		_moveCamera = false;
		if (currentPCam == pCam2dSimpleFollow):
			activatePCam(pCam2dGlued)
			pCam2dSimpleFollow.follow_offset = Vector2(0,0)
		elif (currentPCam == pCam2dGroupFollow):
			activatePCam(pCam2dGroup)
			pCam2dGroupFollow.follow_offset = Vector2(0,0)

func registerLMBMove(event : InputEvent):
	if _moveCamera:
		get_viewport().set_input_as_handled();
		if currentPCam == pCam2dGlued:
			activatePCam(pCam2dSimpleFollow)
		elif currentPCam == pCam2dGroup:
			activatePCam(pCam2dGroupFollow)
		currentPCam.position += (_previousPosition - event.position) * inverseZoomIndex()
		currentPCam.follow_offset += (_previousPosition - event.position) * inverseZoomIndex()
		_previousPosition = event.position;

func inverseZoomIndex() -> float :
	var returnee = dragLevels[currentZoomIndex]
	#print_debug(returnee)
	return returnee
