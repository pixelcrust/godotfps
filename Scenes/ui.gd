extends CanvasGroup

@onready var icon_ammo: Sprite2D = $icon_ammo
@onready var icon_heart: Sprite2D = $icon_heart

@onready var player: CharacterBody3D = $"../../../../../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon_ammo.visible = false
	ammo_choose()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func heart_shake():
	pass
	
func ammo_shake():
	pass
	
func ammo_choose():
	match player.equipped_id:
		0:
			icon_ammo.texture =
		1:
			pass
		2:
			pass
		_:
			pass
