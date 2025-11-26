# StaggeredUpdateManager.gd
# An autoload script that manages the AI updates of all ships
# Objects (Basically always ships?) register and get pinged when an update occurs.
extends Node

## 
var buckets = []

## How many batches updates are split into
## Increase this number to increase AI latency, but reduce CPU stress.
var bucketCount := 12
var currentBucket := 0

func _ready():
	buckets.resize(bucketCount)
	for i in range(bucketCount):
		buckets[i] = []

## Use this to register anything that needs to be updated on the staggered schedule
func register(object, bucketIndex = -1):
	if bucketIndex == -1:
		bucketIndex = randi() % bucketCount
	else: 
		return
	buckets[bucketIndex].append(object)
	object.updateBucketIndex = bucketIndex

func unRegister(object):
	if object.updateBucketIndex < 0: 
		return
	elif object.updateBucketIndex >= bucketCount: 
		return
	buckets[object.updateBucketIndex].erase(object)

# Update all objects in currentBucket
# Then move index to next bucket
func _process(delta):
	var bucket = buckets[currentBucket]
	for obj in bucket:
		if obj.is_inside_tree():
			obj.staggeredUpdate(delta)
	currentBucket = (currentBucket + 1) % bucketCount
