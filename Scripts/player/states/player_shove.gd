extends State
class_name PlayerShove


var player: Player

func enter():
	player = state_machine.get_parent()
	player.set_collision_layer_value(3, false)
	player.shove_meter.show()
	
	player.animation_player.play("charge_shove_%s" % player.last_sprt_dir)

func physics_update(delta: float):
	player.shove_meter.value += 1

func handle_input(event: InputEvent):
	if Input.is_action_just_released("shove"):
		player.animation_player.play("release_shove_%s" % player.last_sprt_dir)
		player.set_collision_layer_value(3, true)
		
		var c = player.look_direction.get_collider()
		if c is Objects and player.look_direction.is_colliding():
			c.apply_central_impulse(player.mouse_dir * player.shove_meter.value)
		
		player.shove_meter.hide()
		player.shove_meter.value = 0
		
		if player.velocity == Vector2.ZERO:
			await player.animation_player.animation_finished
			state_machine.change_state("playeridle")
		else:
			await player.animation_player.animation_finished
			state_machine.change_state("playerwalk")
