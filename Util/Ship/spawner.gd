extends Node2D


var shipWrapper : PackedScene = preload("res://Objects/Scenes/shipwrapper.tscn")
var shipScene : PackedScene = preload("res://Objects/Scenes/ship.tscn")

var ship_stats: Array[ShipStats] = [
	preload("res://Resources/Ship/Ships/bastion1.tres")
	
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("spawn_enemy"):
		#spawnShipResource(ShipDatabase.pickRandomShipResource())
		spawnShipScene(ShipDatabase.pickRandomShipScene())

func spawnShipResource(stats: ShipStats):
	var spawnedShip : Ship = shipScene.instantiate()
	spawnedShip.stats = stats
	spawnedShip.pilot = spawnPilot(spawnedShip)
	get_tree().root.add_child(spawnedShip)
	spawnedShip.global_position = get_global_mouse_position()

func spawnPilot(myShip : Ship) -> Individual:
	var pilot = Individual.new()
	pilot.alignedFaction = FactionRelations.factions.pick_random()
	pilot.currentShip = myShip
	pilot.pilotLevel = randi_range(0, 5)
	return pilot

func spawnShipScene(shipScene: PackedScene):
	var spawnedShip : Ship = shipScene.instantiate()
	var pilot = Individual.new()
	pilot.alignedFaction = FactionRelations.factions.pick_random()
	pilot.currentShip = spawnedShip
	pilot.pilotLevel = randi_range(0, 5)
	spawnedShip.pilot = pilot
	get_tree().root.add_child(spawnedShip)
	spawnedShip.global_position = get_global_mouse_position()
