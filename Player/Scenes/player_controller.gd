extends Node2D
class_name PlayerController


var cameraController : PCam2DController
var viewManager : ViewManager

#signal unHandledInput(event: InputEvent)

#func _unhandled_input(event: InputEvent) -> void:
#	unHandledInput.emit(event)


func _unhandled_input(event: InputEvent):
	if not viewManager.isTweening:
		match viewManager.currentMode:
			viewManager.MODE.GAMEPLAY:
				gameplayInput(event)
			viewManager.MODE.TACTICAL:
				tacticalInput(event)
			viewManager.MODE.STAR:
				systemInput(event)
			viewManager.MODE.GALAXY:
				systemInput(event)


func gameplayInput(event : InputEvent) -> void:
	if event.is_action_pressed("mouse_wheel_up"):
		cameraController.zoomIn()

	if event.is_action_pressed("mouse_wheel_down"):
		# If player zooms out while camera zoom is max, swap to Tac view
		if cameraController.currentZoomIndex == 1:
			viewManager.switchMode(viewManager.MODE.TACTICAL, false)
		cameraController.zoomOut()

	if (event.is_action_pressed("swap_pcam_nofollow")):
		cameraController.swapPCamNoFollow()

	if (event.is_action_pressed("swap_pcam_follow")):
		cameraController.swapPCamGlued()

	if (event.is_action_pressed("swap_pcam_group")):
		cameraController.swapPCamGroup()

	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		cameraController.registerLMBHold(event)

	elif event is InputEventMouseMotion:
		cameraController.registerLMBMove(event)

func tacticalInput(event : InputEvent) -> void:
	if event.is_action_pressed("mouse_wheel_up"):
		viewManager.switchMode(viewManager.MODE.GAMEPLAY, true)
		cameraController.zoomIn()
	if event.is_action_pressed("mouse_wheel_down"):
		viewManager.switchMode(viewManager.MODE.STAR, false)

func systemInput(event : InputEvent) -> void:
	if event.is_action_pressed("mouse_wheel_up"):
		viewManager.switchMode(viewManager.MODE.TACTICAL, true)
	
	
func galaxyInput(event : InputEvent) -> void:
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
