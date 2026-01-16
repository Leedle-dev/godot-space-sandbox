extends Control
class_name GalaxyRings

## NOTE
# Rings currently clips if the center of the ring is not visible in the viewport
########

const GALAXY_RING_COLORS := {
	Galaxy.GalaxyLayer.ORIGIN:    Color(0.90, 0.85, 0.60, 0.30), # warm pale gold
	Galaxy.GalaxyLayer.INNER:     Color(0.60, 0.90, 0.80, 0.27), # mint-cyan (NOT blue)
	Galaxy.GalaxyLayer.OUTER:     Color(0.85, 0.65, 0.90, 0.25), # lavender-violet
	Galaxy.GalaxyLayer.PERIMETER: Color(0.95, 0.75, 0.55, 0.22), # soft amber
	Galaxy.GalaxyLayer.EXPANSE:   Color(0.65, 0.85, 0.55, 0.20), # pale green
	Galaxy.GalaxyLayer.EDGE:      Color(0.90, 0.55, 0.55, 0.18)  # muted red-pink
}

const OUTLINETHICKNESS : float = 32.0
const PRESSEDTHICKNESS : float = 64.0

signal ringHovered(layer)
signal ringPressed(layer)
signal ringClicked(layer)


@export var radii: PackedFloat32Array = [2048, 4096, 6144, 8192, 10240, 12288]
@export var thickness : float = 4.0
@export var center : Vector2 = Vector2.ZERO

@export var rings := []

var hoverIndex = -1
var pressedIndex = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	#custom_minimum_size = Vector2(20000,20000)
	#pivot_offset = Vector2(custom_minimum_size.x/2, custom_minimum_size.y/2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mapContainer := get_parent() as Control
	if mapContainer == null:
		return
	
	var mousePosition : Vector2 = mapContainer.get_local_mouse_position()
	var index := mouseRingPosition(mousePosition.length())

	if index != hoverIndex:
		hoverIndex = index
		if hoverIndex >= 0:
			ringHovered.emit(rings[hoverIndex].layer)
		queue_redraw()

func _gui_input(event: InputEvent) -> void:
	if hoverIndex < 0:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			pressedIndex = hoverIndex
			ringPressed.emit(rings[pressedIndex].layer)
			queue_redraw()
		else:
			if pressedIndex == hoverIndex:
				ringClicked.emit(rings[hoverIndex].layer)
			pressedIndex = -1
			queue_redraw()


## Gets the index of the ring that the mouse is hovering over
func mouseRingPosition(radius : float) -> int:
	for i in range(rings.size()):
		if radius >= rings[i].inner && radius <= rings[i].outer:
			return i
	return -1

func _draw() -> void:
	for ring in rings:
		drawRing(center, ring.inner, ring.outer, getColorFromLayer(ring.layer))
	# If the mouse is hovering over a galaxy ring, highlight it
	if hoverIndex == 0:
		drawInteractArc(float(rings[hoverIndex].outer), Color.BLACK, OUTLINETHICKNESS)
	elif hoverIndex > 0:
		drawInteractArc(float(rings[hoverIndex].inner), Color.BLACK, OUTLINETHICKNESS)
		drawInteractArc(float(rings[hoverIndex].outer), Color.BLACK, OUTLINETHICKNESS)
	if pressedIndex == 0:
		drawInteractArc(float(rings[hoverIndex].outer), Color.WHITE, PRESSEDTHICKNESS)
	elif pressedIndex > 0:
		drawInteractArc(float(rings[hoverIndex].inner), Color.WHITE, PRESSEDTHICKNESS)
		drawInteractArc(float(rings[hoverIndex].outer), Color.WHITE, PRESSEDTHICKNESS)

func drawInteractArc(outerRadius: float, color : Color, thickness : float):
	draw_arc(Vector2.ZERO, outerRadius, 0.0, TAU, 64, color, thickness, true)

func drawRing(center: Vector2, innerRadius : float, outerRadius: float, color: Color, steps := 64):
	var points := PackedVector2Array()
	var edgePoints := PackedVector2Array()

	#outer edge
	for i in range(steps + 1):
		var t = TAU * i / steps
		points.append(center + Vector2(cos(t), sin(t)) * outerRadius)
		#edgePoints.append(center + Vector2(cos(t), sin(t)) * outerRadius)

	#inner edge (reverse)
	for i in range(steps, -1, -1):
		var t = TAU * i / steps
		points.append(center + Vector2(cos(t), sin(t)) * innerRadius)
		#edgePoints.append(center + Vector2(cos(t), sin(t)) * (outerRadius-64))

	draw_colored_polygon(points, color)
	#draw_colored_polygon(edgePoints, Color.BLACK)

func getColorFromLayer(layer : Galaxy.GalaxyLayer) -> Color:
	return GALAXY_RING_COLORS.get(layer)
