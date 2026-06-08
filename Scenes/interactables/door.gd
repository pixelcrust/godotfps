extends Node3D

@export var closed = true
@export var locked = false
@export var blocked = false

@onready var physics_door: RigidBody3D = $physics_door

func _ready() -> void:
	physics_door.closed = closed
	physics_door.locked = locked
	physics_door.blocked = blocked
