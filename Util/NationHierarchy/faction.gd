class_name Faction
extends Node

# Factions are large groups of squadrons for the game's Nation Hierachy.
# They CANNOT be commanded as a group, and are controlled via their Sqauadrons.
# They can own and build stations.
# They can control and defend sectors. Once they own a sector, they are considered a Nation
# They can initiate diplomacy with other factions.
# They may have certain objectives/jobs/roles that they distibute to the squadrons of the faction.

var factionStats : FactionInfo
var stations
var squadrons = Array([], TYPE_OBJECT, "Node", Squadron) # Array[Squadron]

func getName() -> String:
	return factionStats.factionName
