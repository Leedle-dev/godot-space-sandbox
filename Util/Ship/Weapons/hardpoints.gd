## All arrays in this class must be the same length. All arrays are respective to one another. ie - hardpoints[0] uses weaponTypes[0] uses rotationDegrees[0]
class_name Hardpoints
extends Resource

enum hardpointTypes {MAIN, ALTERNATIVE, MISSILE, TURRET1, TURRET2, TURRET3, DOCK}

## These are the individual attachment points on a texture for a ship.
@export var weaponAttachmentPoint : Array[Vector2] = []
## This is the generic weapon type that will be used for the hardpoint.
@export var weaponTypes : Array[hardpointTypes] = []
## This is the rotation in degrees that the hardpoint will face.
@export var rotationDegrees : Array[float] = []
# TODO Review how to implement between this and weaponTypes ENUM
## This contains the WeaponStats to use for each hardpoint. 
#@export var weapons : Array[WeaponStats] = []
