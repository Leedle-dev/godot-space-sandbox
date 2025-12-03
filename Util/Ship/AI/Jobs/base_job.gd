# Basically an Interface for the Job class
# These will be implemented for functionality
# Should hold a queue or some sort of array of tasks that create the jobs.

class_name BaseJob

var ship : Ship
var currentTask : BaseTask
var taskQueue : Array[BaseTask]

func enter(_ship):
	ship = _ship

func update(delta: float):
	if currentTask:
		currentTask.update(delta)
		if currentTask.isComplete():
			currentTask.exit()
			currentTask = getNextTask()
			if currentTask:
				currentTask.enter(ship)

func getNextTask() -> BaseTask:
	return taskQueue.pop_front()

func exitTask():
	if currentTask:
		currentTask.exit()

