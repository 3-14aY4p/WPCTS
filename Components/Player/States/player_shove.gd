class_name PlayerShove extends State


var player: Player
@onready var kb: KnockbackComponent = $"../../Components/KnockbackComponent"


func enter():
	player = state_machine.get_parent()
	player.shove_meter.show()
	player.set_collision_layer_value(4, false)
	
	InteractionManager.can_interact = false
	
	player.animation_player.play("player/shove_charge")

func physics_update(delta: float):
	player._handle_sprt_dir(true)
	player.shove_meter.value += 1

	if Input.is_action_just_released("_shove"):
		player.animation_player.play("player/shove_release")
		player.shove_meter.hide()
		
		var c = player.aim_ray_cast.get_collider()
		if c is Objects and player.aim_ray_cast.is_colliding():
			c.apply_central_impulse(-player.mouse_dir * player.shove_meter.value)
			
		#kb._run_knockback_timer(player)
		#kb._apply_knockback(player.mouse_dir, -1000, 1)
		#
		#player.move_and_slide()
			
		player.set_collision_layer_value(4, true)
		player.shove_meter.value = 0
		
		await player.animation_player.animation_finished
		InteractionManager.can_interact = true
		
		if player.velocity == Vector2.ZERO:
			state_machine.change_state("playeridle")
		else:
			state_machine.change_state("playerwalk")
