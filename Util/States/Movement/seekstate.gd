## SeekState represents having a target and moving toward them.
extends State


func update(delta):
	if not ship.target:
		stateMachine.onChildTransition(self, "idlestate")
	var target = ship.target.global_position
	ship.seekTarget(delta)

	# If close enough, transition to attack/orbit
	if ship.global_position.distance_to(target) < 150:
		stateMachine.onChildTransition(self, "attackrunstate")
