extends Camera2D
class_name PlayerCamera

static var zoomLevels = PackedVector2Array([Vector2(0.0078125,0.0078125), Vector2(0.015625,0.015625), Vector2(0.03125,0.03125), Vector2(0.0625, 0.0625), Vector2(0.125,0.125), Vector2(0.25,0.25), Vector2(0.5,0.5), Vector2(1.0,1.0), Vector2(2.0,2.0), Vector2(4.0,4.0), Vector2(8.0,8.0)])

var currentZoomIndex = 7
var minIndex = 0
var maxIndex = zoomLevels.size() - 1
var targetZoom : Vector2 = zoomLevels[currentZoomIndex]

signal zoomChanged(value)

func changeZoom(event: InputEvent) -> void:
	if (event.is_action_pressed("mouse_wheel_up")):
		if (currentZoomIndex < maxIndex):
			currentZoomIndex += 1
			targetZoom = zoomLevels[currentZoomIndex]
			zoomChanged.emit(currentZoomIndex)
		#print_debug("Current Zoom: " + var_to_str(zoom))
		#print_debug("Target  Zoom: " + var_to_str(zoom))
	elif (event.is_action_pressed("mouse_wheel_down")):
		if (currentZoomIndex > minIndex):
			currentZoomIndex -= 1
			targetZoom = zoomLevels[currentZoomIndex]
			zoomChanged.emit(currentZoomIndex)
		#print_debug("Current Zoom: " + var_to_str(zoom))
		#print_debug("Target  Zoom: " + var_to_str(zoom))
		
	if (event is InputEventMouseMotion):
		#if (event.is_action_pressed("mouse_left_button")):
		self.position = event.relative

"""
func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("mouse_wheel_up")):
		if (currentZoomIndex < maxIndex):
			currentZoomIndex += 1
			targetZoom = zoomLevels[currentZoomIndex]
		#print_debug("Current Zoom: " + var_to_str(zoom))
		#print_debug("Target  Zoom: " + var_to_str(zoom))
	elif (event.is_action_pressed("mouse_wheel_down")):
		if (currentZoomIndex > minIndex):
			currentZoomIndex -= 1
			targetZoom = zoomLevels[currentZoomIndex]
		#print_debug("Current Zoom: " + var_to_str(zoom))
		#print_debug("Target  Zoom: " + var_to_str(zoom))
		
	if (event is InputEventMouseMotion):
		#if (event.is_action_pressed("mouse_left_button")):
		self.position = event.relative
	pass
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!(zoom.is_equal_approx(targetZoom))):
		zoom = zoom.lerp(targetZoom, delta*4)
	pass
