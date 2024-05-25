extends StaticBody3D

@onready var outline_mesh = $MeshInstance3D2
@onready var interactiontime = .1
@onready var player = 0
@onready var save_data = []
var file = null
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	save_data.append(player.inventory)
	save_data.append(player.hp)
	file = FileAccess.open("C:/Users/save-/OneDrive/Dokumente/GameDev/fps-save.txt",FileAccess.READ)
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
	save_data.append(Time.get_date_dict_from_system)
	save_data.append(Global.player_inventory)
	save_data.append(Global.player_health)
	save_data.append(Global.player_position)
	save_data.append(Global.player_rotation)
	save_data.append(Global.player_camera_rotation)
	file = FileAccess.open("C:/Users/save-/OneDrive/Dokumente/GameDev/fps-save.txt",FileAccess.WRITE)
	file.store_pascal_string(str(save_data))
	file.close()
	print(save_data)
