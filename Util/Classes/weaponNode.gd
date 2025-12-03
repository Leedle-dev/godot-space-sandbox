class_name WeaponNode
extends Node2D

var projectileScene : PackedScene = preload("res://Objects/Scenes/projectile.tscn")

## Simple little Matrix here to help with deciding weapon priority.
## Each weapon has a main priority of ship size to target, along with a secondary target.
## We can compare our weapon's desired target ship class (First dimension) against the ship class that is being targeted (second dimension) to determine a target score. 
## The highest value should be 9

# Example use cases:
# L class ship's main battery has priority targets L and alt priority XL (Main batteries on L+ class ships shouldn't realistically be used on M class and smaller)
# We lookup against an L class ship with targetScoreMatrix[l][l] and get 5
# Alt is XL, so we lookup against that targetScorMatrix[xl][l] and get 4.
# Added they are 9, highest score possible.

# Let's say an L class ship has a laser turret. Good against small ships. Especially XS ships. favored and alt target priority can be xs and s. 
static var targetScoreMatrix : Dictionary = {
	"xs": {"xs":5, "s":4, "m":3, "l":1, "xl":0, "xxl":-1},
	"s" : {"xs":4, "s":5, "m":4, "l":2, "xl":1, "xxl":0},
	"m" : {"xs":3, "s":4, "m":5, "l":3, "xl":2, "xxl":1},
	"l" : {"xs":-1, "s":-1, "m":0, "l":5, "xl":4, "xxl":3},
	"xl": {"xs":-1, "s":-1, "m":-1, "l":4, "xl":5, "xxl":4},
	"xxl":{"xs":-1, "s":-1, "m":-1, "l":3, "xl":4, "xxl":5}
}

@export var weaponStats : WeaponStats


var target : Node2D = null
var shipAttachedTo : Ship
var hardpointAttachedTo : Hardpoint
var cooldown : float = 0
var burstCount := 0

var bCanFire : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initStats()
	initProjectile()

func initStats():
	# Testing to see if I need this? Hardpoint technically is this portion of data...
#	rotation = hardpointAttachedTo.global_rotation
#	global_position = hardpointAttachedTo.global_position
	cooldown = weaponStats.firingCooldown
	burstCount = weaponStats.projectileShotsPerBurst
	projectileScene = weaponStats.projectileScene

func initProjectile():
	pass

func _process(delta: float) -> void:
	if bCanFire && target != null:
		#print_debug("calling fire weapon")
		fireWeapon()
		if burstCount <= 0:
			resetCooldown()
	## If We cannot fire, subtract the weapon cooldown, then check if cooldown is less than or 0. If less than or 0, canFire == true
	if bCanFire == false:
		cooldown -= delta
		if cooldown <= 0:
			bCanFire = true
	pass

func fireWeapon():
	#print_debug("firing: " + str(self))
	fireProjectile()
	burstCount -= 1
	cooldown = weaponStats.burstDelay

func resetCooldown():
	cooldown = weaponStats.firingCooldown
	burstCount = weaponStats.projectileShotsPerBurst
	bCanFire = false

func fireProjectile():
	var projectile : Projectile = projectileScene.instantiate()
	projectile.global_position = global_position
	projectile.rotation = global_rotation
	projectile.stats = weaponStats.projectileStats
	projectile.scale = shipAttachedTo.determineScale()
	get_tree().current_scene.add_child(projectile)

func acquireTarget(enemyList, primaryTarget : Ship):
	target = calcBestTarget(enemyList, primaryTarget)


func calcBestTarget(enemyList, primaryTarget : Ship):
	# Prioritize primary target if It's within out firing arc and our weapon class matches the target.
	if primaryTarget != null:
		if primaryTarget.getSizeAbbrKey().to_lower() == weaponStats.priorityTargetClass.to_lower() and isInFiringArc(primaryTarget):
			return primaryTarget

	var bestTarget = null
	var bestScore = -10
	# Threw this in to hopefully help with processing speed in large volume battles.
	# Basically if the target scores a 9 in the target priorty matrix, the loop breaks. 
	# This should be helpful for turrets and weapons that prioritize smaller targets, especially if there's a bunch of enemies in the cones.
	# Main batteries will hopefully just use the targetting above.
	var count = 10
	for tar in enemyList:
		if isInFiringArc(tar):
			var d = determineTargetPriorityScore(tar)
			if d > bestScore:
				bestTarget = tar
				bestScore = d
			count -= 1
		if bestScore > count && bestTarget != null:
			return bestTarget
	return bestTarget


func determineTargetPriorityScore(tar : Ship) -> int:
	var targetScore = 0
	targetScore += targetScoreMatrix[weaponStats.priorityTargetClass.to_lower()][tar.getSizeAbbrKey().to_lower()]
	targetScore += targetScoreMatrix[weaponStats.secondaryTargetClass.to_lower()][tar.getSizeAbbrKey().to_lower()]
	return targetScore


func isInFiringArc(tar):
	var distanceToTarget = (tar.global_position - global_position).normalized()
	var forward = global_transform.x.normalized()
	var angle = rad_to_deg(acos(forward.dot(distanceToTarget)))

	return angle <= weaponStats.gimbal / 2

"""
func _physics_process(delta):
	## If weapon has no target, pass
	if not is_instance_valid(target):
		return
	rotate_toward_target(delta)
	handle_firing(delta)


func rotate_toward_target(delta):
	var to_target = (target.global_position - global_position)
	var desired_angle = to_target.angle()
	var diff = wrapf(desired_angle - global_rotation, -PI, PI)

	# limit rotation speed
	global_rotation += clamp(diff, -weapon_stats.turn_speed * delta, weapon_stats.turn_speed * delta)

func handle_firing(delta):
	cooldown -= delta
	if cooldown > 0:
		return

	if burst_remaining > 0:
		fire_projectile()
		burst_remaining -= 1
		cooldown = weapon_stats.burst_delay
		return

	# Start new burst if in range & aligned
	if is_target_in_firing_arc():
		burst_remaining = weapon_stats.burst_size
		cooldown = 0   # fire immediately

func is_target_in_firing_arc() -> bool:
	var to_target = target.global_position - global_position
	if to_target.length() > weapon_stats.range:
		return false

	var angle_diff = abs(wrapf(to_target.angle() - global_rotation, -PI, PI))
	return angle_diff < deg_to_rad(5)  # within +/- 5 degrees

func fire_projectile():
	var proj = weapon_stats.projectile_scene.instantiate()
	proj.global_position = global_position
	proj.global_rotation = global_rotation
	proj.damage = weapon_stats.damage
	proj.speed = weapon_stats.projectile_speed
	get_tree().current_scene.add_child(proj)
	"""
