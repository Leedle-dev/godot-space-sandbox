## Vision controls the ship's vision radius.
## A ship uses a single area2D (VisionArea) + a CircleShape2D for checking vision.
## Check ships/onjects in radius to determine the vision with angles checks.

extends Node2D

@export var visionRadius := 1500.0
@export var forwardConeAngle := 90.0   # 90° for small ships
@export var rearConeAngle := 25.0      # narrow evasion detection
@export var omniDirectional := false     # large ships TODO refactor this to remove. Large ships will just have a large forward cone?

var myShip : Ship

# Will probably use this
# Stores a reference to every ship in this ship's vision range.
# Sorted by size class
var bodiesInRadius := {
	SizeClass.sizeAbbreviations.XS : {}, 
	SizeClass.sizeAbbreviations.S : {}, 
	SizeClass.sizeAbbreviations.M : {}, 
	SizeClass.sizeAbbreviations.L : {},
	SizeClass.sizeAbbreviations.XL : {},
	SizeClass.sizeAbbreviations.XXL : {}
}

func getBodiesInRadiusBySize(size : SizeClass.sizeAbbreviations) -> Dictionary:
	return bodiesInRadius[size]

# On second thoughts, probably won't be able to use this
# The logic for vision and such needs to be stored in 1 Dict. 
# Determination of enemy or not from the get go could pigeonhole into literally everything being hostile that's an enemy.
var enemiesInRadiusBySize := {
SizeClass.sizeAbbreviations.XS : {}, 
SizeClass.sizeAbbreviations.S : {}, 
SizeClass.sizeAbbreviations.M : {}, 
SizeClass.sizeAbbreviations.L : {},
SizeClass.sizeAbbreviations.XL : {},
SizeClass.sizeAbbreviations.XXL : {}
}



var enemiesInWeaponRadius := {}

## Prepares the node. attempting to get the shape from editor doesn't seem to allow radius setting in the CircleShape2D.
## So I just added the shape and adjusted the radius here
func _ready():
	myShip = $".."
	#var shape := CircleShape2D.new()
	#shape.radius = visionRadius
	#$VisionArea/CollisionShape2D.shape = shape
	$VisionArea.body_entered.connect(onBodyEntered)
	$VisionArea.body_exited.connect(onBodyExited)

func onBodyEntered(body):
	bodiesInRadius[body.getSizeAbbr()].set(body, body)
	# This should check the relation map, determine if the ship is hostile.
	# If it's hostile, add the ship to the enemiesInRadiusBySize Dict depending on its size class.
	if body is Ship:
		#print_debug("ship detected: " + str(body))
		# Checks if we are the same faction, if so, ignore, if not, add to radius
		# Might want to adjust this later
		if body.pilot != null:
			if body.pilot.alignedFaction != myShip.pilot.alignedFaction:
				if FactionRelations.factionRelationMap[myShip.pilot.alignedFaction][body.pilot.alignedFaction] == FactionRelations.attitude.Hostile:
					enemiesInRadiusBySize[body.getSizeAbbr()].set(body, body)

func onBodyExited(body):
	bodiesInRadius.erase(body)
#	enemiesInRadius.erase(body)

func acquireTarget() -> Ship:
	# This just looks for ships in the same size class marked as enemies
	for enemy in enemiesInRadiusBySize[myShip.getSizeAbbr()]:
		if isInForwardCone(enemy):
			if enemy is Ship:
				return enemy
	return null

"""
func determineShipSize(body : Ship) :
	body.size
	"""
## Should return an array of ships that are inside of the radius of our vision area AND within our vision cone
func getVisibleTargets() -> Array:
	var results := []
	for body in bodiesInRadius:
		if is_instance_valid(body): 
			if omniDirectional:
				results.append(body)
			else:
				if isInForwardCone(body):
					results.append(body)
	return results

## Should return an array of ships that are inside of the radius of our vision area AND behind is in the rear vision cone
func getRearThreats() -> Array:
	var results := []
	for body in bodiesInRadius:
		if is_instance_valid(body):
			if isInRearCone(body):
				results.append(body)
	return results

func isInForwardCone(target) -> bool:
	return computeTargetAngle(target) <= (forwardConeAngle * 0.5)

func isInRearCone(target) -> bool:
	return computeTargetAngle(target) >= (180 - (rearConeAngle * 0.5))
	
## Computes in degrees to a target
func computeTargetAngle(target) -> float:
	var toTarget = (target.global_position - global_position).normalized()
	var angle = rad_to_deg(global_transform.x.angle_to(toTarget))
	return angle
