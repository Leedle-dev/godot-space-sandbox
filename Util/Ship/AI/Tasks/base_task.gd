# Basically an Interface for the Task class
# These will be implemented for functionality

class_name BaseTask

var ship : Ship

func enter(_ship) -> void:
	ship = _ship

func update(delta: float) -> void:
	pass

func isComplete() -> bool:
	return false

func exit():
	pass
