class_name PlayerThrow extends State


var player: Player


func enter():
	player = state_machine.get_parent()
	
	InteractionManager.can_interact = false
	player.force_meter.show()
	player.animation_player.play("player/throw_charge")

func physics_update(delta: float):
	player._handle_sprt_dir(true)
	player.force_meter.value += 1

	if Input.is_action_just_released("_throw"):
		player.animation_player.play("player/throw_release")
		player.force_meter.hide()
		
		player.grabbed_obj.reparent(get_tree().get_first_node_in_group("container"))
		player.grabbed_obj.apply_central_impulse(player.mouse_dir * (player.force_meter.value * 3))
		
		player.grabbed_obj.set_collision_layer_value(2, true)
		player.grabbed_obj = null
		
		player.force_meter.value = 0
		
		await player.animation_player.animation_finished
		InteractionManager.can_interact = true
		
		if player.velocity == Vector2.ZERO:
			state_machine.change_state("playeridle")
		else:
			state_machine.change_state("playerwalk")
