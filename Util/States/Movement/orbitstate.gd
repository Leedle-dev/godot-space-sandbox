## OrbitState should simulate the ship orbiting a target

extends State


var orbitDistance := 200.0
var orbitDirection := 1  # 1 = clockwise, -1 = counter

func enter():
	orbitDirection = [1, -1].pick_random()

func update(delta):
	var target = ship.target.global_position

	# Compute orbit point
	var toTarget = ship.global_position.direction_to(target)
	var tangent = toTarget.rotated(orbitDirection * PI/2)

	var desiredPosistion = target + toTarget * orbitDistance + tangent * 80
	ship.turn_toward(desiredPosistion, delta)

	ship.reduceSideDrift()
	ship.thrustForward(0.5)

	# chance to reattempt attack run
	if randf() < 0.01:
		stateMachine.onChildTransition(self, "attackrunstate")
