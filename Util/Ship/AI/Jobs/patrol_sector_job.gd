extends "res://Util/Ship/AI/Jobs/base_job.gd"
class_name PatrolSectorJob

# A Job for having a ship Patrol a sector (sector defence patrol)

## The Sector to Patrol
var sectorTarget
## Should I move between the stations in the sector?
var patrolStations : bool = false
## Should I patrol outside the normal bounds of the sector?
var patrolOutskirts : bool = false

func enter(_ship):
    super.enter(_ship)
    currentTask = getNextTask()
    if currentTask: 
        currentTask.enter(ship)

func getNextTask() -> BaseTask:
    return null
    ## if we've patrolled for a minute or so, move to next patrol point

    ## if we're in range of target patrol area, begin patroling in a range

func makeMoveToTask() -> BaseTask:
    return null
