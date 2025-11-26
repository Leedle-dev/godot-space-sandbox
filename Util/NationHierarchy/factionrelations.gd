extends Node

var attitude = {"Hostile" : -50, "Unfriendly" : -25, "Neutral" : 0, "Friendly" : 25, "Allied" : 50}
##enum factionNames {Jethari, Humanity, Cthunlu, Mantistan}

var factionStats : Array[FactionInfo]

var factions = Array([], TYPE_OBJECT, "Node", Faction) # Array[Squadron]
var factionRelationMap := {}

""" Old Faction Setup logic
func setupExampleFactions():
	for faction in factionNames:
		if faction not in factionRealtionMap:
			var factionToAdd = Faction.new()
			factionToAdd.name = faction
			factionRealtionMap[factionToAdd] = {}
			factions.append(factionToAdd)
	for faction in factionRealtionMap:
		for otherFaction in factionRealtionMap[faction]:
			factionRealtionMap[faction][otherFaction] = attitude.Hostile
			factionRealtionMap[otherFaction][faction] = attitude.Hostile
"""

func setupRelationMap():
	for faction in factions:
		if faction not in factionRelationMap:
			factionRelationMap[faction] = {}
	for faction in factionRelationMap:
		for otherFaction in factions:
			# If current faction == otherFaction, that is us, so skip
			if faction == otherFaction:
				continue
			# If currentFaction already has a value set in the relation map, skip
			if factionRelationMap[faction].has(otherFaction):
				continue
			# Otherwise, set relations
			setRelations(faction, otherFaction, attitude.get("Hostile"))
	pass

func setRelations(faction : Faction, otherFaction : Faction, relation : int):
	factionRelationMap[faction].set(otherFaction, relation)
	factionRelationMap[otherFaction].set(faction, relation)

func adjustRelations(faction : Faction, otherFaction : Faction, relationAdjustment : int):
	var currentRelation = factionRelationMap[faction].get(otherFaction)
	currentRelation += relationAdjustment
	setRelations(faction, otherFaction, currentRelation)

func createFactions():
	for stats in factionStats:
		var factionToAdd = Faction.new()
		factionToAdd.factionStats = stats
		factions.append(factionToAdd)

func addFactionStats(resource: FactionInfo) -> void:
	factionStats.append(resource)

func loadAllFactions(path: String):
	var dir = DirAccess.open(path)
	for f in dir.get_files():
		if f.ends_with(".tres"):
			var res = load(path + f)
			if res is FactionInfo:
				var factionRes : FactionInfo = res
				addFactionStats(factionRes)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loadAllFactions("res://Resources/Factions/")
	createFactions()
	setupRelationMap()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
