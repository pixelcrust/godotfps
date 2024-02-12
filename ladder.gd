extends Node3D

@onready var heal_amount = 100
@onready var interactiontime = 3
@onready var player = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func use():
	player.is_on_ladder = true
