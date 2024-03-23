extends Node3D

@onready var barrel = $barrel
@onready var ray_cast_3d = $barrel/MeshInstance3D/RayCast3D

@onready var state = 0
"""0 move left right
	1 aim directly
	2 shoot
"""

@onready var time_aiming = 120
@onready var time_between_bullets = 10
@export var angle = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var going_left = true
	var current_angle = 0
	match state:
		0:
			if going_left:
				current_angle += delta
				if current_angle >= angle:
					going_left = false
			else:
				current_angle -= delta
				if current_angle <= -angle:
					going_left = true
			barrel.rotate_y(current_angle)
			#if spott player
			if ray_cast_3d.is_colliding():
				if ray_cast_3d.get_collider().is_in_group("has_blood"):
					state = 1
		1:#state follow player
			#return to state 0
			if ray_cast_3d.is_colliding() == false:
				state = 0
			else:
				if ray_cast_3d.get_collider().is_in_group("has_blood") == false:
					state = 0
		2:
			pass
		_:
			pass
