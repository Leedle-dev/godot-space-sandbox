extends Control
class_name GalaxyRings

const GALAXY_RING_COLORS := {
	Galaxy.GalaxyLayer.ORIGIN:    Color(0.90, 0.85, 0.60, 0.30), # warm pale gold
	Galaxy.GalaxyLayer.INNER:     Color(0.60, 0.90, 0.80, 0.27), # mint-cyan (NOT blue)
	Galaxy.GalaxyLayer.OUTER:     Color(0.85, 0.65, 0.90, 0.25), # lavender-violet
	Galaxy.GalaxyLayer.PERIMETER: Color(0.95, 0.75, 0.55, 0.22), # soft amber
	Galaxy.GalaxyLayer.EXPANSE:   Color(0.65, 0.85, 0.55, 0.20), # pale green
	Galaxy.GalaxyLayer.EDGE:      Color(0.90, 0.55, 0.55, 0.18)  # muted red-pink
}

@export var radii: PackedFloat32Array = [2048, 4096, 6144, 8192, 10240, 12288]
@export var thickness : float = 4.0
@export var center : Vector2 = Vector2.ZERO

@export var rings := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	#custom_minimum_size = Vector2(30000,30000)

func _draw() -> void:
	for ring in rings:
		drawRing(center, ring.inner, ring.outer, getColorFromLayer(ring.layer))


func drawRing(center: Vector2, innerRadius : float, outerRadius: float, color: Color, steps := 180):
	var points := PackedVector2Array()

	#outer edge
	for i in range(steps + 1):
		var t = TAU * i / steps
		points.append(center + Vector2(cos(t), sin(t)) * outerRadius)

	#inner edge (reverse)
	for i in range(steps, -1, -1):
		var t = TAU * i / steps
		points.append(center + Vector2(cos(t), sin(t)) * innerRadius)

	draw_colored_polygon(points, color)

func getColorFromLayer(layer : Galaxy.GalaxyLayer) -> Color:
	match layer:
		Galaxy.GalaxyLayer.ORIGIN:
			return GALAXY_RING_COLORS.get(layer)
		Galaxy.GalaxyLayer.INNER:
			return GALAXY_RING_COLORS.get(layer)
		Galaxy.GalaxyLayer.OUTER:
			return GALAXY_RING_COLORS.get(layer)
		Galaxy.GalaxyLayer.PERIMETER:
			return GALAXY_RING_COLORS.get(layer)
		Galaxy.GalaxyLayer.EXPANSE:
			return GALAXY_RING_COLORS.get(layer)
		Galaxy.GalaxyLayer.EDGE:
			return GALAXY_RING_COLORS.get(layer)
		_:
			return Color(1,1,1,0.02)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
