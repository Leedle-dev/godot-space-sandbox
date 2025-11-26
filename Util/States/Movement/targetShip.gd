extends State
class_name TargetShipState

@onready var myStateMachine : StateMachine = get_parent()
@export var targetShip : Ship

var targetShipPosition : Vector2
signal targetPostion

func setTargetPosition():
	targetShipPosition = stateMachine.ship.primaryTarget.position
	targetPostion.emit()

func Enter():
	setTargetPosition()

# Called when the node enters the scene tree for the first time.
func update(delta: float):
	#if !targetShip.position.is_equal_approx(targetShipPosition):
	setTargetPosition()
	ship.seekTargetPos(delta, targetShipPosition)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
