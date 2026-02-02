extends CharacterBody2D
class_name Player


@export var speed = 50.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var shove_meter: ProgressBar = $MetersUI/ShoveMeter

var last_sprt_dir: String = "down" #for sprite face direction
var mouse_direction: Vector2 #for aiming shove


func _physics_process(delta: float) -> void:
	mouse_direction = get_local_mouse_position().normalized()
