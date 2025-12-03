extends Resource
## This contains the information that a Sector needs to exist in the game.
class_name SectorInfo

## The name of the Sector. 
@export var name : String
## The description of the Sector.
@export var description : String
## A list of Sectors that this sector connects to.
## These are outgoing connections. The index of the connection determines the location of the jump gate in level.
@export var neighbors : Array[SectorInfo] = [null,null,null,null,null,null,null,null]

var discovered : Array[bool] = [false, false, false, false, false, false, false, false]

