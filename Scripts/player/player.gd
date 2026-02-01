extends CharacterBody2D
class_name Player


# TO-DO
# [] Push/Shove Mechanic
# [] Player State Machine

@export var SPEED = 75.0
var direction = "down"

@onready var push_meter_bar: ProgressBar = $PlayerMeters/PushMeterBar
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	velocity = Input.get_vector("left", "right", "up", "down") * SPEED
	
	if Input.is_action_pressed("down"):
		direction = "down"
	elif Input.is_action_pressed("up"):
		direction = "up"
		
	if velocity.x > 0:
		sprite_2d.flip_h = false
	elif velocity.x < 0:
		sprite_2d.flip_h = true
		
	if velocity != Vector2.ZERO:
		animation_player.play("walk_%s" % direction)
	else: 
		animation_player.play("idle_%s" % direction)
		
	move_and_slide()
	
	# This represents the player's inertia.
	var push_force = 0
	
	if Input.is_action_pressed("push"):
		push_meter_bar.show()
		push_meter_bar.value += 1
	elif Input.is_action_just_released("push"):
		push_force = push_meter_bar.value
		push_meter_bar.value = 0
		
	if push_meter_bar.value > 0: push_meter_bar.show()
	else: push_meter_bar.hide()
