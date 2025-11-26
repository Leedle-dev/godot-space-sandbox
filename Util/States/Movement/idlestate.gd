## Idlestate represents a ship that is actively doing absolutely nothing.
extends State


func enter():
	# Stop rotating, drifting, etc
	ship.body.angular_velocity = 0

func update(delta):
	ship.reduceSideDrift()
	if ship.primaryTarget == null:
		stateMachine.onChildTransition(self, "wanderstate")
		print_debug("No current target. swapping to wanderstate")
		#state_machine.change_state("SeekState")
	elif ship.primaryTarget:
		stateMachine.onChildTransition(self, "seekstate")
		print_debug("swapping to seekstate")
