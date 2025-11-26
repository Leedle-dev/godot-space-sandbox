extends State

signal newTargetPostion

var previousTarget : Vector2
var targetPosition : Vector2
var wanderTime : float

func randomizeWander():
	targetPosition = Vector2(randf_range(-10000,10000), randf_range(-10000,10000))
	$Sprite2D.position = targetPosition
	wanderTime = randf_range(20,30)
	newTargetPostion.emit()
	print_debug("New Position")

func Enter():
	randomizeWander()
	$"../..".connect("newTargetAcquired", switchToSeek)

# Called when the node enters the scene tree for the first time.
func update(delta: float):
	if wanderTime > 0:
		wanderTime -= delta
		ship.seekTargetPos(delta, targetPosition)
	else:
		randomizeWander()
		
func PhysicsUpdate(delta: float):
	pass
	
func switchToSeek():
	stateMachine.onChildTransition(self, "targetship")
