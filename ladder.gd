extends Node3D

@onready var heal_amount = 100
@onready var interactiontime = .01
@onready var player = 0
@onready var area_3d = $Area3D




# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0] # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func use():
	#check if in area
	player.is_on_ladder = true
	player.interacted_with_ladder = true


func _on_area_3d_body_entered(body):
	print("body entered")
	player.is_on_ladder = true # Replace with function body.

