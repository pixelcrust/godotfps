extends Node3D

@onready var heal_amount = 100
@onready var interactiontime = .01
@onready var player = 0
@onready var area_3d = $Area3D




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func use():
	#check if in area
	player.is_on_ladder = true
	player.interacted_with_ladder = true
