class_name PlayerShove extends State


var player: Player


func enter():
	player = state_machine.get_parent()
	player.shove_meter.show()
	player.set_collision_layer_value(4, false)
	
	player.animation_player.play("player/shove_charge")

func physics_update(delta: float):
	player._handle_sprt_dir(true)
	player.shove_meter.value += 1

func handle_input(event: InputEvent):
	if Input.is_action_just_released("_shove"):
		player.animation_player.play("player/shove_release")
		player.shove_meter.hide()
		player.shove_meter.value = 0
		
		await player.animation_player.animation_finished
		player.set_collision_layer_value(4, true)
		
		if player.velocity == Vector2.ZERO:
			state_machine.change_state("playeridle")
		else:
			state_machine.change_state("playerwalk")
