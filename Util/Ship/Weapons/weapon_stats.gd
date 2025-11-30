class_name WeaponStats
extends Resource


## The generic cooldown for the weapon. Use this to adjust the time between shots
@export_range(0, 30, 0.02) var firingCooldown : float = 1.0
## A charge time applied to the weapon. Use this to have a charge up time. Set to 0.0 to fire immediately on firingCooldown
@export_range(0, 30, 0.02) var chargeTime : float = 1.0
## The amount of projectiles the weapon shoots. Set to 1.0 for a single projectile per shot. Only accepts whole numbers. This is for a shotgun effect.
@export_range(0, 100, 1) var projectileCountPerShot : int = 1
## The amount of shots per burst. Whole numbers only
@export_range(0, 100, 1) var projectileShotsPerBurst : int = 1
## The interval between burst. Not the same as cooldown. Set to 0.0 for all projectiles to be fired at the same time.
@export_range(0, 100, 0.1) var burstDelay : float = 0.1
## Random projectile variation in degrees
@export_range(0, 120, 1.0) var inaccuracy : float = 1.0
## Maximum allowed gimbal for weapon targeting. In degrees (This is essentially the "weapons vision cone"
@export_range(0, 360, 1.0) var gimbal : float = 1.0
## Maximum weapon range for target acquisition and firing. 
@export_range(500.0, 30000.0, 100.0) var range : float = 500.0
## The stats that the projectile will have (Used to influence damage, speed, lifetime, etc.)
@export var projectileStats: ProjectileStats
## The projectile scene that will be fired (Used to adjust sprite and hitbox)
@export var projectileScene: PackedScene

## The weapon system's primary target size
@export var priorityTargetClass : String = "S"
## The weapon system's alternative target size
@export var secondaryTargetClass : String = "XS"
@export var weaponType : Hardpoints.hardpointTypes
