extends Node3D

enum levels {Home,Workplace,Bahnhof,WalkingHome}
@export var transit_to : levels

func _on_area_3d_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	print("body in area")
	if body.is_in_group("player_root"):
		print("player body in area")
		Global.next_level = str(transit_to)
		get_tree().change_scene_to_file("res://Scenes/menues/loadscreen.tscn")
