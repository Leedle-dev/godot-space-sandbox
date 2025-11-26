## FleeState is a state where the pilot has decided to flee from it's active target.
extends State


func update(delta):
	var target = ship.target.global_position
	var oppositeTarget = ship.global_position + (ship.global_position - target)

	ship.turnToward(oppositeTarget, delta)
	ship.reduceSideDrift()
	ship.thrustForward(1.5)

	if ship.global_position.distance_to(target) > 1500:
		stateMachine.onChildTransition(self, "IdleState")
