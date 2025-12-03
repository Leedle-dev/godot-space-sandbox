class_name ShipStats 
extends Resource

@export var texture : Texture2D
@export var textureLOD1 : Texture2D
@export var shipClass : ShipClass
@export var name : String
@export var hardpoints : Hardpoints
@export var weaponSystems : Dictionary[Hardpoints.hardpointTypes, WeaponStats] = {} 
static var versionPrefix : String = "Mk"
@export_range(1, 5, 1) var version : int

@export var health : int = 10
@export var shield : int = 10

@export var carryCapacity : int = 10

# Pulled from GDScript Ref

@export var variation_range : float = 10.0
@export var acceleration_time :float = 2.5
@export var friction : float = 1.0

## Max Thrust for the ship
@export var maxThrust : float = 70.0
## Turn rate for the ship
@export var turnRate : float = 90.0
## Brake Speed of the ship
@export var brakeForce : float = 50.0
## Side Braking force of the ship
@export var sideBrake : float = 3.0
