class_name ProjectileStats
extends Resource

## The speed the projectile travels
@export var projectileSpeed : float = 100.0
## The duration the projectile exists, in seconds. 
@export_range(0, 60, 0.5) var lifetime : float = 1.0
## The damage the weapon projectile deals to the shield, per projectile
@export var shieldDamage : int = 1
## The damage the weapon projectile deals to the ship hull (health), per projectile
@export var hullDamage : int = 1
## Set to true for a homing projectile. False for a straight traveling weapon.
@export var bIsHoming : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
