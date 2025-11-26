class_name ShipClass
extends Resource

# A combination of ShipType and SizeClass Resources for easily fleshing out and keeping track of how a ship is categorized by the game.
# The shipClassName variable here describes the "type" of ship. EG. Corvette, Frigate, Battlecruiser, etc.

@export var shipClassName : String = ""
@export var shipType : ShipType
@export var sizeClass : SizeClass
