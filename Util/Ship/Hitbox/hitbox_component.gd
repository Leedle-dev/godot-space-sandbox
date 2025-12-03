extends CollisionShape2D

var myShip : Ship
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	myShip = get_parent()
	shape = shape.duplicate(true)
	adjustHitboxScale()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func adjustHitboxScale():
	if  shape is CapsuleShape2D:
		print_debug("adjusting hitbox")
		print_debug("shape.height = " + str(shape.height) + " Multiplied by: " + str(myShip.determineScaleFloat()))
		var targetHeight: float = shape.height * myShip.determineScaleFloat()
		var targetRadius: float = shape.radius * myShip.determineScaleFloat()
		while (shape.height != targetHeight || shape.radius != targetRadius):
			adjustCapsuleHandles(shape, targetHeight, targetRadius)
		
		print("debug Line")
		#breaks eventually
		#shape.height = shape.height * myShip.determineScaleFloat()
		#shape.radius = shape.radius * myShip.determineScaleFloat()

func adjustCapsuleHandles(capsule : CapsuleShape2D, targetHeight : float, targetRadius : float):
	# max step for height, is the target height or double it's radius. If double radius, target height is to small
	var maxStepHeight: float = maxf(targetHeight, capsule.radius*2) 
	capsule.height = maxStepHeight
	# max step for radius, cannot be greater than half height
	var maxStepRadius: float = minf(targetRadius, capsule.height/2)
	capsule.radius = maxStepRadius
