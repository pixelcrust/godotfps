extends Node3D

@export var closed = true
@export var locked = false
@export var blocked = false

@onready var door: Node3D = $Door

func _ready() -> void:
	door.closed = closed
	door.locked = locked
	door.blocked = blocked
