class_name Health
extends Node


##############################
# Health Component for enemies
##############################

signal health_changed(health: int)
signal max_health_changed(max_health: int)
signal shield_changed(shield: int)
signal max_shield_changed(max_shield: int)
signal died()

@export var hitbox : Hitbox
@export var animation_player : AnimationPlayer

@export var max_health := 10 :
	set(val):
		max_health = val
		max_health_changed.emit(max_health)
		health = max_health
@onready var health := max_health:
	set(val):
		health = val
		health_changed.emit(health)
		
@export var max_shield := 10 :
	set(val):
		max_shield = val
		max_shield_changed.emit(max_shield)
		shield = max_shield
@onready var shield := max_shield:
	set(val):
		shield = val
		shield_changed.emit(shield)


func _ready():
	if hitbox:
		hitbox.damaged.connect(on_damaged)
	
	max_health_changed.emit(max_health)
	health_changed.emit(health)
	max_shield_changed.emit(max_shield)
	shield_changed.emit(shield)


func on_damaged(attack: Attack):
	shield -= attack.shieldDamage
	if (shield < 1):
		health -= attack.healthDamage
	health = max(0, health)
	
	if health <= 0:
		died.emit()
		if animation_player:
			animation_player.play("death")
