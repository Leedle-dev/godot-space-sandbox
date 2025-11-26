extends Node
class_name StateMachine

## IMPORT
# Might want to shift these to logic states that determine / calculate where the ship needs to go, rather than where / how to move.

@export var initialState : State

var ship : Ship
var states : Dictionary = {}
var currentState : State


func _ready():
	ship = get_parent()
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.stateMachine = self
			child.ship = ship
			child.Transitioned.connect(onChildTransition)
	
	if initialState:
		initialState.Enter()
		currentState = initialState

func manualProcess(delta : float):
	if currentState:
		currentState.update(delta)

"""
func _process(delta):
	if currentState:
		currentState.update(delta)
		
func _physics_process(delta):
	if currentState:
		currentState.PhysicsUpdate(delta)
		
"""
func onChildTransition(state, newStateName):
	if state != currentState:
		return
		
	var newState = states.get(newStateName.to_lower())
	if !newState:
		return
	if currentState:
		currentState.Exit()
		
	newState.Enter()
	currentState = newState
