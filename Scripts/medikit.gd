extends Node3D

@onready var heal_amount = 100
@onready var interactiontime = 5
@onready var player = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_interaction_time():
	return interactiontime

func use():
	player.heal(heal_amount)
	
