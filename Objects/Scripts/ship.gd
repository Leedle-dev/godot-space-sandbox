class_name Ship
extends RigidBody2D

var myWrapper : ShipWrapper
static var weaponNodePackedScene : PackedScene = load("res://Objects/Scenes/weaponNode.tscn")

#var camera : PCam2DController

#signal damaged(attack: Attack)
@export var stats: ShipStats
func getSizeAbbr() -> int :
	return stats.shipClass.sizeClass.sizeAbbreviation

func getSizeAbbrKey() -> String :
	return stats.shipClass.sizeClass.sizeAbbreviations.keys()[getSizeAbbr()]

## Pilot contains the pilot info, squadron, and faction info
var pilot : Individual

# Array index into which staggered update bucket this object exists. Used for removal.
# Init to -1, on register gets set.
var updateBucketIndex := -1

const LOD0_THRESHOLD = 1050    # pixels on screen
const LOD1_THRESHOLD = 1300
const LOD2_THRESHOLD = 50

@onready var state_machine := $StateMachine
@onready var sprite :Sprite2D = $Sprite2D
@onready var spriteLOD1 : Sprite2D = $Sprite2D_LOD1
@onready var godotSprite := $StateMachine/WanderState/Sprite2D
@onready var vision := $Vision
@onready var flightController := $FlightController

var primaryTarget: RigidBody2D = null
func getDetectedEnemies() -> Dictionary:
	return vision.enemiesInRadius

var weaponHardpoints: Array[Hardpoint] = []

# Movement tuning
var maxThrust := 250.0
var turnRate := 120.0
var brakeForce := 250.0
var sideBrake := 3.0

# TODO Logic to set this combat flag
var bIsInCombat : bool = true

signal newTargetAcquired

func _ready() -> void:
	initSprite()
	#adjustHitboxScale()
	initMovementStats()
	spawnHardpoints()
	attachWeapons()
	if pilot == null:
		pilot = Spawner.spawnPilot(self)
	#for hardpoint in weaponHardpoints:
	#	hardpoint.rotate(1.570796)

	#camera  = %Camera2D
	#camera.zoomChanged.connect(adjustSpriteFilter)
	StaggeredUpdateManager.register(self)


## Initializes the sprite for the ship.
# Sets the correct pixel filter and scale of the sprite.
# KEEP THIS
# Resource loading in the sprite will be useful when ship variants get introduced.
# Practically no performance hit.
func initSprite():
	sprite.texture = stats.texture
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	spriteLOD1.texture = stats.textureLOD1
	spriteLOD1.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.scale = determineScale()
	spriteLOD1.scale = determineScale()*2
	#sprite.rotate(1.570796)

func adjustSpriteFilter():
	"""
	if camera.currentZoomIndex <= 6:
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	elif camera.currentZoomIndex >= 7:
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	"""
	pass




## Initializes the movements stats for the ship
# Currently just setting the local variables from the ships' stats resource. Technically duplicating, but easy for testing.
func initMovementStats():
	maxThrust = stats.maxThrust
	turnRate = stats.turnRate
	brakeForce = stats.brakeForce
	sideBrake = stats.sideBrake

## staggeredUpdate is part of the StaggeredUpdateManager global.
## It calls update once every N frames where N is the bucket count within StaggeredUpdateManager.
func staggeredUpdate(delta : float) :
	if primaryTarget == null:
		primaryTarget = vision.acquireTarget()
		if primaryTarget != null:
			newTargetAcquired.emit()
	if bIsInCombat:
		for hardpoint in weaponHardpoints:
			# TODO Hardcoded for M class ships for testing
			hardpoint.weapon.acquireTarget(vision.getBodiesInRadiusBySize(getSizeAbbr()).keys(), primaryTarget)
	pass

var procCount: int  = 1
func _process(delta: float) -> void:
	#sprite.position = sprite.position.round()
	#updateLOD()
	pass

func updateLOD():
	var viewport := get_viewport()
	var camera := viewport.get_camera_2d()
	if camera == null: 
		print_debug("Camera null") 
		return
	# Project ship size to screen-space
	var zoom_factor := camera.zoom.x  # assuming uniform zoom
	var screen_size := sprite_visual_size() / zoom_factor
	if (procCount % 100 == 0 && getSizeAbbr() == SizeClass.sizeAbbreviations.XL):
		print_debug(screen_size)
		procCount = 1
	else:
		procCount += 1
	if screen_size < LOD0_THRESHOLD:
		set_lod(0)
	elif screen_size < LOD1_THRESHOLD:
		set_lod(1)

func sprite_visual_size() -> float:
	# approximate diagonal of LOD0 sprite
	var tex := stats.texture
	return sqrt(tex.get_width() * tex.get_width() + tex.get_height() * tex.get_height())

func set_lod(level : int):
	sprite.visible = level == 0
	spriteLOD1.visible = level == 1

func _physics_process(delta):
	state_machine.manualProcess(delta)
	


func spawnHardpoints() :
	var halfSpriteSize = $Sprite2D.texture.get_size() * 0.5
	var counter := 0
	while counter < stats.hardpoints.weaponAttachmentPoint.size():
		var newHardpoint : Hardpoint = Hardpoint.new()
		newHardpoint.weaponAttachmentPosition = stats.hardpoints.weaponAttachmentPoint[counter]
		newHardpoint.weaponType = stats.hardpoints.weaponTypes[counter]
		newHardpoint.rotationDegrees = stats.hardpoints.rotationDegrees[counter]
		newHardpoint.position = (newHardpoint.weaponAttachmentPosition - halfSpriteSize) * $Sprite2D.scale
		newHardpoint.rotation_degrees = newHardpoint.rotationDegrees
		add_child(newHardpoint)
		weaponHardpoints.append(newHardpoint)
		counter += 1
		

func attachWeapons():
	for hardpoint in weaponHardpoints:
		attachWeaponToHardpoint(hardpoint)

func attachWeaponToHardpoint(hardpoint : Hardpoint):
	var newWeapon : WeaponNode = weaponNodePackedScene.instantiate()
	newWeapon.weaponStats = getMatchingWeaponSystem(hardpoint.weaponType)
	newWeapon.shipAttachedTo = self
	newWeapon.hardpointAttachedTo = hardpoint
	hardpoint.weapon = newWeapon
	hardpoint.add_child(newWeapon)

func getMatchingWeaponSystem(hardpointType : Hardpoints.hardpointTypes) -> WeaponStats:
	#print_debug("hardpointType: " + str(hardpointType))
	#print_debug(stats.weaponSystems.get(hardpointType))
	return stats.weaponSystems.get(hardpointType)

func doesWeaponMatchHardpoint() -> bool:
	
	return false


static var shipVectorScale : PackedVector2Array = [Vector2(0.25,0.25), Vector2(0.5,0.5), Vector2(1,1), Vector2(1,1) ]
static var shipFloatScale : PackedFloat64Array = [0.25, 0.5, 1.0, 1.0]

func determineScale() -> Vector2:
	match getSizeAbbr():
		0: return shipVectorScale[0] ## XS class
		1: return shipVectorScale[0] ## S class		
		2: return shipVectorScale[1] ## M Class
		3: return shipVectorScale[2] ## L Class
		4: return shipVectorScale[3] ## XL Class
		5: return shipVectorScale[3] ## XXL Class
	return shipVectorScale[0]

func determineScaleFloat() -> float :
	match getSizeAbbr():
		0: return shipFloatScale[0] ## XS class
		1: return shipFloatScale[0] ## S class		
		2: return shipFloatScale[1] ## M Class
		3: return shipFloatScale[2] ## L Class
		4: return shipFloatScale[3] ## XL Class
		5: return shipFloatScale[3] ## XXL Class
	return shipFloatScale[0]

func determineThrustStrength() -> float:
	# --- DIRECTIONAL THRUST BLENDING ---
	# --- ANGLE DIFFERENCE ---
	var angleError = abs(wrapf((primaryTarget.position - global_position).angle() - rotation, -PI, PI))
	var maxAngleForThrust = .5
	var thrustFactor = 1.0 - clamp(angleError / maxAngleForThrust, 0.50, 1.0)
	thrustFactor = lerp(0.1, 1.0, thrustFactor)
	return thrustFactor
	
## Duplicate to test on raw Vector2 with wanderstate
func determineThrustStrengthPos(target : Vector2, maxAngleForThrust := .5) -> float:
	# --- DIRECTIONAL THRUST BLENDING ---
	# --- ANGLE DIFFERENCE ---
	var angleError = abs(wrapf((target - global_position).angle() - rotation, -PI, PI))
	var thrustFactor = 1.0 - clamp(angleError / maxAngleForThrust, 0.50, 1.0)
	thrustFactor = lerp(0.1, 1.0, thrustFactor)
	return thrustFactor

func thrustForward(strength := 1.0):
	apply_central_force(transform.x * maxThrust * strength)

func thrustBrake():
	var vel = linear_velocity
	apply_central_force(-vel.normalized() * brakeForce)

func reduceSideDrift():
	var right = transform.y
	var side_speed = linear_velocity.dot(right)
	var correction = right * -side_speed * sideBrake
	apply_central_force(correction)

func turnToward(pos: Vector2, delta):
	#print_debug("turning")
	var dir = (pos - global_position).normalized()
	var desired_angle = dir.angle()
	var angle_diff = wrapf(desired_angle - rotation, -PI, PI)
	#print_debug(angle_diff)
	#print_debug("linear velocity: " + str(linear_velocity))
	apply_torque(angle_diff * turnRate)
	
func turn_toward_two(pos: Vector2, delta: float) -> void:
	var dir = (pos - global_position).normalized()
	var desired_angle = dir.angle()
	var angle_diff = wrapf(desired_angle - rotation, -PI, PI)

	var turn_direction = sign(angle_diff)

	# target angular velocity
	var target_omega = turn_direction * turnRate

	# steer toward target angular velocity
	var omega_diff = target_omega - angular_velocity

	apply_torque(omega_diff * 1)# torque_strength)

func isFacing(pos: Vector2, tolerance_deg := 15.0) -> bool:
	var dir = (pos - global_position).normalized()
	var angle_to = abs(wrapf(dir.angle() - rotation, -PI, PI))
	return deg_to_rad(tolerance_deg) > angle_to
	
func seekTarget(delta : float) :
	turnToward(primaryTarget.global_position, delta)
	if isFacing(primaryTarget.global_position, 270):
		thrustForward(determineThrustStrength())
		reduceSideDrift()

## Duplicate to test on raw Vector2 with wanderstate
func seekTargetPos(delta: float, target : Vector2) :
	turnToward(target, delta)
	if isFacing(target, 25):
		thrustForward(determineThrustStrengthPos(target, 0.5))
		reduceSideDrift()
	#else:
	#	thrustBrake()
"""

@export var stats: ShipStats

var max_speed : float
var variation_range : float
var acceleration_time : float
var friction : float
var rotationRate : float

@onready var sprite : Sprite2D = $Sprite2D
@onready var health: Health = $Health

var alive := true
var stunned := false

#var current_speed := 0.0

#var item_drop : PackedScene = preload("res://Objects/Scenes/item_drop.tscn")


func _ready():
	randomize()
	
	# Distribute stats where they need to be
	health.max_health = stats.health
	health.max_shield = stats.shield
	
	max_speed = stats.max_speed
	variation_range = stats.variation_range
	acceleration_time = stats.acceleration_time
	friction = stats.friction
	rotationRate = stats.rotation_rate
	
	sprite.texture = stats.texture
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.scale = determine_scale()
	sprite.rotate(1.570796)
	
	max_speed += randf_range(-variation_range, variation_range)
	
	$StateMachine/WanderState.newTargetPostion.connect(func(): target_position = $StateMachine/WanderState.targetPosition)
	$StateMachine/TargetShip.targetPostion.connect(func(): target_position = $StateMachine/TargetShip.targetShipPosition)


#func on_damaged(attack: Attack) -> void:
#	damaged.emit(attack)


func on_death() -> void:
	#if stats.loot_table:
	#	for stack: ItemStack in stats.loot_table.roll_loot():
	#		var spawned_item : ItemDrop = item_drop.instantiate()
	#		spawned_item.stack = stack
	#		spawned_item.global_position = global_position
	#		get_tree().current_scene.add_child.call_deferred(spawned_item)
	pass


@export var thrust_force := 80.0
@export var turn_speed := 8.0
@export var max_angle_for_full_thrust := deg_to_rad(10)
@export var min_thrust := 0.2

@export var lateral_damping := 0.9   # 0 = no reduction, 1 = very strong reduction (tweak)
@export var brake_distance := 200.0
@export var max_brake_force := 40.0

var target_position: Vector2

# small helper remap (keeps result clamped)
func _remap_clamped(value: float, a: float, b: float, c: float, d: float) -> float:
	if b == a:
		return c
	var t = clamp((value - a) / (b - a), 0.0, 1.0)
	return lerp(c, d, t)

func _physics_process(delta: float) -> void:
		# --- ROTATION & MOVEMENT CONTROL ---
	var to_target: Vector2 = target_position - global_position
	var forward = Vector2.RIGHT.rotated(rotation)
	var distance = to_target.length()
	var speed = linear_velocity.length()
	var desired_angle := to_target.angle()
	var current_angle := rotation

	# --- ANGLE DIFFERENCE ---
	var angle_diff := wrapf(desired_angle - current_angle, -PI, PI)
	var angle_error = abs(angle_diff)

	# --- PREDICTIVE BRAKING ---
	# compute stopping distance for current speed
	var stopping_distance = ((speed * speed) * 0.9) / (2.0 * max_brake_force)

	# begin braking if we won't stop in time
	var needs_brake = stopping_distance >= distance

	# --- ARRIVAL BUBBLE ---
	# Commented out to test combat
	#var arrive_radius := 300.0  # tweak this

	#if distance < arrive_radius:
		# soft settle: reduce both rotation and movement drift
	#	angular_velocity *= 0.85
	#	linear_velocity *= 0.85

	# DO NOT ROTATE TOWARD TARGET ANYMORE
	# This prevents spinning around the target endlessly
	#else:
		# apply torque normally only when not in the arrival bubble
	apply_torque(angle_diff * turn_speed * 50)

# --- DIRECTIONAL THRUST BLENDING ---
	var thrust_factor = 1.0 - clamp(angle_error / max_angle_for_full_thrust, 0.50, 1.0)
	thrust_factor = lerp(min_thrust, 1.0, thrust_factor)
	# --- APPLY THRUST ---
	# Only apply forward thrust normally if not braking
	#if not needs_brake and distance > arrive_radius:
	apply_central_force(forward * thrust_force * thrust_factor)

	# --- BRAKE FORCE ---
	# Commented out to test combat
	#if needs_brake:
	#	if speed > 0.1 :
	#		var brake_dir = -linear_velocity.normalized()
	#		apply_central_force(brake_dir * max_brake_force)


"""

"""
# small helper remap (keeps result clamped)
func _remap_clamped(value: float, a: float, b: float, c: float, d: float) -> float:
	if b == a:
		return c
	var t = clamp((value - a) / (b - a), 0.0, 1.0)
	return lerp(c, d, t)

func _physics_process(delta: float) -> void:
	if target_position == null:
		return

	var to_target: Vector2 = target_position - global_position
	var distance := to_target.length()
	var desired_angle := to_target.angle()
	var current_angle := rotation

	# --- ANGLE DIFFERENCE ---
	var angle_diff := wrapf(desired_angle - current_angle, -PI, PI)
	var angle_error = abs(angle_diff)

	# --- ROTATION / TORQUE ---
	var stopping_radius := 100.0

	if distance > stopping_radius:
		# Rotate normally when not at target
		apply_torque(angle_diff * turn_speed * 50)
	else:
		# Inside target radius – stop spinning
		angular_velocity *= 0.85   # keep some floatiness
		# Optional: snap to correct angle
		# rotation = desired_angle

	# --- DIRECTIONAL THRUST BLENDING ---
	var thrust_factor = 1.0 - clamp(angle_error / max_angle_for_full_thrust, 0.0, 1.0)
	thrust_factor = lerp(min_thrust, 1.0, thrust_factor)

	var forward := Vector2.RIGHT.rotated(rotation)
	apply_central_force(forward * thrust_force * thrust_factor)

	# --- SIDE DRIFT REDUCTION ---
	# lateral (perpendicular) vector to forward:
	var lateral := Vector2(-forward.y, forward.x)   # 90° rotated forward
	var forward_speed := linear_velocity.dot(forward)
	var lateral_speed := linear_velocity.dot(lateral)

	# Remove a fraction of lateral velocity each frame. multiply by delta so effect is time-consistent.
	linear_velocity -= lateral * lateral_speed * lateral_damping * delta

	# --- BRAKING NEAR TARGET ---
	if distance < brake_distance:
		# desired speed reduces as we get closer (120 -> 5)
		var desired_speed := _remap_clamped(distance, brake_distance, 0.0, 120.0, 5.0)
		var current_speed := linear_velocity.length()
		if current_speed > desired_speed and current_speed > 0.01:
			var brake_dir := -linear_velocity.normalized()
			apply_central_force(brake_dir * max_brake_force)

"""
"""
@export var thrust_force := 40.0
@export var turn_speed := 4.0
@export var max_angle_for_full_thrust := deg_to_rad(90)
@export var min_thrust := 0.2
@export var lateral_damping := 0.9   # 0 = no reduction, 1 = very strong reduction
@export var brake_distance := 200.0
@export var max_brake_force := 60.0
var target_position: Vector2

func _physics_process(delta):
	if target_position == null:
		return

	var to_target = target_position - global_position
	var desired_angle = to_target.angle()
	var current_angle = rotation

	# --- ANGLE DIFFERENCE ---
	var angle_diff = wrapf(desired_angle - current_angle, -PI, PI)
	var angle_error = abs(angle_diff)

	# --- ROTATION: TORQUE ---
	apply_torque(angle_diff * turn_speed * 50)

	# --- DIRECTIONAL THRUST BLENDING ---
	var thrust_factor = 1.0 - clamp(angle_error / max_angle_for_full_thrust, 0.0, 1.0)
	thrust_factor = lerp(min_thrust, 1.0, thrust_factor)

	var forward = Vector2.RIGHT.rotated(rotation)
	apply_central_force(forward * thrust_force * thrust_factor)

	# --- SIDE DRIFT REDUCTION ---
	var forward_speed = linear_velocity.dot(forward)
	var lateral_speed = linear_velocity.dot(forward.tangent())

	linear_velocity -= forward.tangent() * lateral_speed * lateral_damping * delta

	# --- BRAKING NEAR TARGET ---
	var distance = to_target.length()
	var current_speed = linear_velocity.length()
	var desired_speed = current_speed

	if distance < brake_distance:
		desired_speed = remap(distance, brake_distance, 0, 120, 5)
		

	if current_speed > desired_speed:
		var brake_dir = -linear_velocity.normalized()
		apply_central_force(brake_dir * max_brake_force)
"""


"""

var target_position: Vector2

@export var thrust_force = 40.0
@export var turn_speed = 4.0
@export var max_angle_for_full_thrust := deg_to_rad(90)  # 90° = very forgiving


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#$StateMachine/WanderState.newTargetPostion.connect(func(): target_position = $StateMachine/WanderState.targetPostion)
	
func _physics_process(delta):
	if target_position == null:
		print_debug("target position is null")
		return
	var to_target = (target_position - global_position)
	var desired_angle = to_target.angle()
	var current_angle = rotation

	# Angle difference (shortest direction)
	var angle_diff = wrapf(desired_angle - current_angle, -PI, PI)

	# Apply torque to rotate toward target
	apply_torque(angle_diff * turn_speed * 50)


	# -----------------------------
	# THRUST BLENDING
	# -----------------------------
	# Convert angle difference to a 0..1 thrust multiplier
	var angle_error = abs(angle_diff)

	# angle_error == max_angle → thrust = 0  
	# angle_error == 0        → thrust = 1
	var thrust_multiplier = 1.0 - clamp(angle_error / max_angle_for_full_thrust, 0.0, 1.0)

	# Apply forward thrust based on multiplier
	var forward = Vector2.RIGHT.rotated(rotation)
	var forwardTan = Vector2.RIGHT.rotated(rotation)
	apply_central_force(forward * thrust_force * thrust_multiplier)
	
	var forward_speed = linear_velocity.dot(forward)
	var lateral_speed = linear_velocity.dot(forward.tangent())

	# Reduce lateral drift
	var lateral_reduction = 0.9  # 90% removed per second
	linear_velocity -= forward.tangent() * lateral_speed * lateral_reduction * delta
	# If facing mostly toward target, apply thrust
	#var facing_dot = Vector2.RIGHT.rotated(rotation).dot(to_target.normalized())

	#if facing_dot > 0.85:
	#	apply_central_force(Vector2.RIGHT.rotated(rotation) * thrust_force)
	#elif facing_dot > 0.5:
	#	apply_central_force(Vector2.RIGHT.rotated(rotation) * (thrust_force/2))
	#else:
	#	apply_central_force(Vector2.RIGHT.rotated(rotation) * (thrust_force/6))

"""
