class_name Player extends CharacterBody2D


@onready var state_machine: StateMachine = $StateMachine

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var force_meter: ProgressBar = $MiniHUD/ForceMeter

@onready var aim_ray_cast: RayCast2D = $PlayerAim/AimRayCast
@onready var aim_direction: Marker2D = $PlayerAim/AimRayCast/AimDirection
@onready var carry_position: Marker2D = $Sprite2D/CarryPosition


@export var default_speed = 60

var grabbed_obj = null
var mouse_dir: Vector2


func _physics_process(delta: float) -> void:
	mouse_dir = get_local_mouse_position().normalized()
	aim_ray_cast.look_at(get_global_mouse_position())

func _handle_movement(speed: float = default_speed):
	velocity = Input.get_vector("_left", "_right", "_up", "_down") * speed
	move_and_slide()

func _handle_sprt_dir(isAiming: bool = false):
	if isAiming:
		if mouse_dir.x < 0:
			sprite_2d.flip_h = true
		elif mouse_dir.x > 0:
			sprite_2d.flip_h = false
	else:
		if velocity.x < 0:
			sprite_2d.flip_h = true
			
		elif velocity.x > 0:
			sprite_2d.flip_h = false

func _handle_raycast_collision():
	var c = aim_ray_cast.get_collider()
	if c is Objects and aim_ray_cast.is_colliding():
		return c
