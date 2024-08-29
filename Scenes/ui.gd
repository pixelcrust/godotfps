extends CanvasGroup

@onready var icon_ammo: Sprite2D = $icon_ammo
@onready var icon_heart: Sprite2D = $icon_heart

@onready var player: CharacterBody3D = $"../../../../../../.."

var icon_bullet_pistol = preload("res://Sprites/pistol_bullet_icon.png")
var icon_shell = preload("res://Sprites/shotgun_shell_icon.png")
var icon_explosion = preload("res://Sprites/explosion_icon.png")

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
			icon_ammo.visible = true
			icon_ammo.texture = icon_bullet_pistol
		1:
			icon_ammo.visible = true
			icon_ammo.texture = icon_shell
		5:
			icon_ammo.visible = true
			icon_ammo.texture = icon_explosion
		_:
			icon_ammo.visible = false
			icon_ammo.texture = null
