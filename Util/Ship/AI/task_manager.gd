# Task Manager is the highest level AI local to a Ship.
# It represents what the ship wants to do at a strategic level.
# Orders can come from:
#	# Faction AI
#	# Player commands
#	# Squad leaders
#	# Reactive events (under attack → flee)
#
# The General design pattern will follow:
#	# 1. Vision updates targets
#	# 2. TaskManager (THIS) decides desired behavior
#	# 3. StateMachine transitions appropriately
#	# 4. StateMachine provides desired:
#       - heading
#       - speed
#       - orbit radius
#       - evade vector
#       - attack run parameters
#	# 5. FlightController handles movement & applies forces
#
# This is the brain that controls the ship.
#
# Task Manager will decide on what to do with Jobs and Tasks.
# Jobs are the logic and strategy for executign a series of Tasks properly, and continueing those tasks
# Tasks are the individual isntructions that together complete the Job.

class_name TaskManager
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
