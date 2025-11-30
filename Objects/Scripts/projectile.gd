class_name Projectile
extends Area2D

## This class is the instantiated Projectile.
# 
# It contains the LOGIC for the projectile to move, hit stuff, lifetime, etc.
# It will also contain the hitbox and Sprite.

# Currently exported, but probably wont have to be. 
# The projectile stats can be assigned to the weaponNode or WeaponStats and those can assign to the Projectile themselves.
@export var stats : ProjectileStats

var velocity : Vector2 = Vector2.ZERO
var lifeTime : float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initProjectile()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocity * delta

	lifeTime += delta
	if lifeTime >= stats.lifetime:
		queue_free()

func initProjectile():
	velocity = Vector2.RIGHT.rotated(global_rotation) * stats.projectileSpeed
	
