class_name ShipType
extends Resource

# This Resource just holds the overarching ship type(s) and a brief description of their general functionality.
# EG. shipType is Battleship. Battleship has 3 subtypes depending on size, and those get represented by shipClass (ship_class.gd)

@export var description : String
@export var shipType : String
