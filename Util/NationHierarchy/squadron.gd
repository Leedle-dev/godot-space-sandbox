class_name Squadron
extends Node

# Squadron represents a group of pilots for the game's Nation Hierachy
# They can be commanded as a group, and are normally always associated with a Faction.
# They may have certain objectives/jobs/roles within a faction

var squadronInsignia : Sprite2D
var squadronName : String

var alignedFaction : Faction
var sqaudronLeader : Individual
var squadronMembers = Array([], TYPE_OBJECT, "Node", Individual) # Array[Individuals]
var squadronFormation
