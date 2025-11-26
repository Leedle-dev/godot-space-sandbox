class_name Individual
extends Node

# Individual represents the smallest form of logic for the game's Nation Hierachy
# It is literally the individual pilot, in control of a ship, so realistically a pilot.

var characterPortrait : Sprite2D
var squadron : Squadron
var alignedFaction : Faction
var currentShip : Ship

var firstName : String
var lastName : String
var birthday : String

var pilotLevel : int = 0
