extends CharacterBody2D
class_name Player


@export var default_speed : float = 50.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var shove_meter: ProgressBar = $MetersUI/ShoveMeter

@onready var look_direction: RayCast2D = $LookDirection/RayCast2D

var last_sprt_dir: String = "down" #for sprite face direction
var mouse_dir: Vector2 #for aiming shove

func _physics_process(delta: float) -> void:
	mouse_dir = get_local_mouse_position().normalized()
	look_direction.look_at(get_global_mouse_position())

func handle_sprt_dir():
	if mouse_dir.y > 0:
		last_sprt_dir = "down"
	elif mouse_dir.y < 0:
		last_sprt_dir = "up"
		
	if mouse_dir.x > 0:
		sprite_2d.flip_h = false
	elif mouse_dir.x < 0:
		sprite_2d.flip_h = true

func handle_movement(speed : float = default_speed):
	var player_input: Vector2 = Input.get_vector("left", "right", "up", "down") 
	velocity = player_input * speed
		
	move_and_slide()
