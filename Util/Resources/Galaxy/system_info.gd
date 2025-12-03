extends Resource
# This will group sectors together into Star Systems. 
class_name SystemInfo



## The name of the Star System
@export var name : String
## The description of the Star System
@export var description : String
## The Sectors within the Star System
@export var sectors : Array[SectorInfo]
## The layer of the galaxy that this sector sits in.
@export var galaxyLayer : Galaxy.GalaxyLayer
