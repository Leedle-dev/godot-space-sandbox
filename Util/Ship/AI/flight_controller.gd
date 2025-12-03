class_name FlightController
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# -------------------------------------------------------------------
# External references
# -------------------------------------------------------------------
@export var myShip: RigidBody2D        # The physical body to control
@export var max_thrust := 600.0
@export var acceleration : float = 75.0
@export var max_turn_torque := 300.0
@export var brake_force := 800.0
@export var side_brake_force := 300.0
@export var lead_prediction_time := 0.6   # seconds into future to aim
@export var max_thrust_angle := deg_to_rad(90) # 90° = full thrust if within this angle

# These get set by AI states
var target: Node2D = null
var desired_mode: String = "idle"   # "idle", "pursue", "brake", "flee", etc

# Cached each frame
var forward := Vector2.RIGHT
var right := Vector2.DOWN


# ============================================================
# PROCESS INPUTS (called by AI state machine every frame)
# ============================================================

func set_target(t):
	target = t

func set_mode(m):
	desired_mode = m


# ============================================================
# FLIGHT CONTROL UPDATE (call from _physics_process)
# ============================================================

func update_control(delta):
	if not myShip:
		return

	forward = Vector2.RIGHT.rotated(myShip.global_rotation)
	right = forward.rotated(-PI/2.0)

	match desired_mode:
		"pursue":
			pursue_target(delta)
		"brake":
			brake_in_place(delta)
		"flee":
			flee_target(delta)
		"strafe":
			strafe_around_target(delta)
		_:
			passive_stabilize(delta)  # idle behavior


# ============================================================
# FLIGHT BEHAVIORS
# ============================================================

# ------------------------------
# PURSUIT BEHAVIOR
# ------------------------------
func pursue_target(delta):
	if not target:
		return

	var aim_pos = compute_lead_point(target, lead_prediction_time)
	turn_toward(aim_pos)

	var angle_diff = angle_to_point(aim_pos)
	apply_forward_thrust(angle_diff)


# ------------------------------
# BRAKE / STOP
# ------------------------------
func brake_in_place(delta):
	# Forward/backward braking
	var forward_speed = myShip.linear_velocity.dot(forward)
	myShip.apply_central_force(-forward * forward_speed * brake_force)

	# Lateral drift braking
	var lateral_speed = myShip.linear_velocity.dot(right)
	myShip.apply_central_force(-right * lateral_speed * side_brake_force)

	# Rotation damping
	myShip.apply_torque(-myShip.angular_velocity * max_turn_torque * 0.3)


# ------------------------------
# FLEE OPPOSITE TARGET
# ------------------------------
func flee_target(delta):
	if not target:
		return

	var away_dir = myShip.global_position.direction_to(target.global_position) * -1
	var aim_pos = myShip.global_position + away_dir * 200
	turn_toward(aim_pos)
	apply_forward_thrust(0)  # full thrust because angle diff is 0


# ------------------------------
# STRAFING (ORBIT INTENTIONALLY)
# ------------------------------
func strafe_around_target(delta):
	if not target:
		return

	var dir = myShip.global_position.direction_to(target.global_position)
	var tangent_point = myShip.global_position + dir.tangent() * 100
	turn_toward(tangent_point)

	apply_forward_thrust(angle_to_point(tangent_point))


# ------------------------------
# PASSIVE STABILIZE (IDLE)
# ------------------------------
func passive_stabilize(delta):
	brake_in_place(delta)


# ============================================================
# SUPPORT FUNCTIONS
# ============================================================

func compute_lead_point(t: Node2D, predict_time: float) -> Vector2:
	if not t or not t.has_method("get_velocity"):
		return t.global_position

	var target_vel = t.get_velocity()
	return t.global_position + target_vel * predict_time


func angle_to_point(p: Vector2) -> float:
	var desired = (p - myShip.global_position).angle()
	return wrapf(desired - myShip.global_rotation, -PI, PI)


func turn_toward(point: Vector2):
	var angle_diff = angle_to_point(point)
	myShip.apply_torque(angle_diff * max_turn_torque)


func apply_forward_thrust(angle_diff: float):
	# Convert angle difference into thrust scalar
	var thrust_scalar = clamp(1.0 - abs(angle_diff) / max_thrust_angle, 0.0, 1.0)
	myShip.apply_central_force(forward * thrust_scalar * max_thrust)

	# Apply lateral drift correction
	var lateral_speed = myShip.linear_velocity.dot(right)
	myShip.apply_central_force(-right * lateral_speed * side_brake_force * 0.5)


func get_velocity() -> Vector2:
	return myShip.linear_velocity