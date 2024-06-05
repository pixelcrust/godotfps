extends StaticBody3D

@onready var outline_mesh = $MeshInstance3D2
@onready var interactiontime = .1
@onready var player = 0
@onready var save_data = []
var file = null
var json = JSON.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	file = FileAccess.open("user://fps-save.txt",FileAccess.READ)
	#file.close()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_interaction_time():
	return interactiontime
	
func use():
	player.start_conversation()
	player.display_conversation.clear()
	player.display_conversation.insert_text_at_caret("Game saved")
	
	#change global variables
	Global.player_health = player.hp
	Global.player_inventory = player.inventory
	Global.player_position = player.position
	Global.player_rotation = player.rotation
	Global.player_camera_rotation = player.camera.rotation
	
	#write variables into file
	save_data.append({
		"time" : Time.get_date_dict_from_system,
		"player_inventory" : Global.player_inventory,
		"player_health" : Global.player_health,
		"player_position" : Global.player_position,
		"player_rotation" : Global.player_rotation,
		"player_camera_rotation" : Global.player_camera_rotation
		})
		
	file = FileAccess.open("user://fps-save.txt",FileAccess.WRITE)
	var inhalt = json.stringify(save_data)
	print(inhalt)
	file.store_string(inhalt)
	file.close()
	#print(save_data)
