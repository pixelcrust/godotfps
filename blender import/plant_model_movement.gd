extends Node3D

const SPEED_MOVEMENT = .1
const DISTANCE_MOVEMENT = 10
var direction_movement = 1
@onready var plane = $Plane
@onready var plane_2 = $Plane2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	plane.rotation.x += SPEED_MOVEMENT*direction_movement*delta
	plane_2.rotation.x += SPEED_MOVEMENT*direction_movement*delta
	#print(str(rad_to_deg(plane.rotation.x)))
	if rad_to_deg(plane.rotation.x) >= DISTANCE_MOVEMENT:
		direction_movement = -1
	elif rad_to_deg(plane.rotation.x) <= -DISTANCE_MOVEMENT:
		direction_movement = 1
