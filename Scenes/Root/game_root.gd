extends Node2D

@onready var playerController : PlayerController = $PlayerController
@onready var cameraController :PCam2DController = $Camera2D
@onready var viewManager : ViewManager = $ViewManager
@onready var background : ColorRect = $BackgroundLayer/Background


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerController.cameraController = cameraController
	playerController.viewManager = viewManager
	#viewManager.tacticalMapLayer = $TacticalMapLayer
	#viewManager.sectorRing = $TacticalMapLayer/SectorRingMapElement
	#viewManager.starMapLayer = $StarMapLayer
	#viewManager.starMapControl = $StarMapLayer/StarSystemUINode
	#viewManager.background = background
	#background.color = ProjectSettings.get_setting("rendering/environment/defaults/default_clear_color");
	#background.color.a = 0.0
	print("GameRoot READY")
	print("Camera2D exists:", has_node("Camera2D"))
	print("CameraController exists:", has_node("Camera2D"))
	print("PlayerController exists:", has_node("PlayerController"))
	print("ViewModeManager exists:", has_node("ViewManager"))
	#playerController.unHandledInput.connect(cameraController.changeZoom)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
