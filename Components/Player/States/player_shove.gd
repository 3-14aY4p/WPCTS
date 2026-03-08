class_name PlayerShove extends State


var player: Player
@onready var kb: KnockbackComponent = $"../../Components/KnockbackComponent"


func enter():
	player = state_machine.get_parent()
	player.set_collision_layer_value(4, false)
	
	InteractionManager.can_interact = false
	player.force_meter.show()
	player.animation_player.play("player/shove_charge")

func physics_update(delta: float):
	player.handle_sprt_dir(true)
	player.force_meter.value += 1

	if Input.is_action_just_released("_shove"):
		player.animation_player.play("player/shove_release")
		player.force_meter.hide()
		
		var collided_obj = player.handle_raycast_collision()
		if collided_obj and collided_obj.is_in_group("shoveable"):
			collided_obj.apply_central_impulse(player.mouse_dir * (player.force_meter.value * 4))
			
		#kb._run_knockback_timer(player)
		#kb._apply_knockback(player.mouse_dir, -1000, 1)
		#
		#player.move_and_slide()
			
		player.set_collision_layer_value(4, true)
		player.force_meter.value = 0
		
		await player.animation_player.animation_finished
		InteractionManager.can_interact = true
		
		if player.velocity == Vector2.ZERO:
			state_machine.change_state("playeridle")
		else:
			state_machine.change_state("playerwalk")
