extends Node


var ship_types := {}
var allShipTypes : Array[ShipStats] = []
var sceneShips : Array[PackedScene] = []

func _ready():
	load_all_ships("res://Resources/Ship/Ships/")
	load_all_ship_scenes("res://Objects/Scenes/Ships/")

func pickRandomShipResource() -> ShipStats:
	return allShipTypes.pick_random()

func pickRandomShipScene() -> PackedScene:
	return sceneShips.pick_random()
	
func pickShipScene(index : int) -> PackedScene :
	if index > -1 && index < sceneShips.size():
		return sceneShips[index]
	return sceneShips[0]

func addShipResource(shipType: String, sizeAbbr: int, shipName: String, version: int, resource: ShipStats) -> void:
	## Needs to be implemented
	#if faction not in ship_types:
	#	ship_types[faction] = {}

	if shipType not in ship_types:
		ship_types[shipType] = {}

	if sizeAbbr not in ship_types[shipType]:
		ship_types[shipType][sizeAbbr] = {}
		
	if shipName not in ship_types[shipType][sizeAbbr]:
		ship_types[shipType][sizeAbbr][shipName] = {}
	
	if version not in ship_types[shipType][sizeAbbr][shipName]:
		ship_types[shipType][sizeAbbr][shipName][version] = {}

	# Finally assign the ship resource
		ship_types[shipType][sizeAbbr][shipName][version] = resource

""" Add Ship With Faction Example
func add_ship(faction: String, size: String, shipClass: String, role: String, resource: Resource) -> void:
	## Needs to be implemented
	#if faction not in ship_types:
	#	ship_types[faction] = {}

	if size not in ship_types:
		ship_types[faction][size] = {}

	if shipClass not in ship_types[faction][size]:
		ship_types[faction][size][shipClass] = {}

	# Finally assign the ship resource
		ship_types[faction][size][shipClass][role] = resource
	
"""

func load_all_ships(path: String):
	var dir = DirAccess.open(path)
	for f in dir.get_files():
		if f.ends_with(".tres"):
			var res = load(path + f)
			if res is ShipStats:
				var shipRes : ShipStats = res
				addShipResource(shipRes.shipClass.shipType.shipType, shipRes.shipClass.sizeClass.sizeAbbreviation, shipRes.name, shipRes.version, shipRes)
				allShipTypes.append(shipRes)
				print_debug(shipRes.shipClass.shipType.shipType + str(shipRes.shipClass.sizeClass.sizeAbbreviation) + shipRes.name + str(shipRes.version))

func load_all_ship_scenes(path: String):
	var dir = DirAccess.open(path)
	for f in dir.get_files():
		if f.ends_with(".tscn"):
			var res = load(path + f)
			if res is PackedScene:
				sceneShips.append(res)
				print_debug("Ship Scene added to Ship Database")
