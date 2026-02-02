extends Node3D

enum levels {Home,Workplace}
@export var transit_to : levels


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("group_player"):
		match transit_to:
			"Home" :
				pass
			"Workplace" :
				pass
