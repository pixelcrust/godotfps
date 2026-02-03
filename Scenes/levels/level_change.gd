extends Node3D

enum levels {Home,Workplace,Bahnhof,WalkingHome}
@export var transit_to : levels


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("body in area")
	if body.is_in_group("group_player"):
		print("player body in area")
		Global.next_level = str(transit_to)
		get_tree().change_scene_to_file("res://Scenes/menues/loadscreen.tscn")
