extends Node3D

enum levels {Home,Workplace,Bahnhof,WalkingHome,Baustelle}
@export var transit_to : levels
@export var use_spawn_nr : int = 0

func _on_area_3d_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player_root"):
		print(str(transit_to))
		Global.next_level = str(transit_to)
		Global.next_level_spawn_nr=use_spawn_nr
		body.queue_free()
		get_tree().change_scene_to_file("res://Scenes/menues/loadscreen.tscn")
