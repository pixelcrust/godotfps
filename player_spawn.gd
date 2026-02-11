extends Node3D

@onready var player = preload("res://Scenes/player_parts/player.tscn")
@export var spawn_nr : int = 0
#@export var active : bool = false

func _ready() -> void:
	if spawn_nr == Global.next_level_spawn_nr:
		var new_player = player.instantiate()
		get_tree().root.get_children()[0].add_child(new_player)
		
		
