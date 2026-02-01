extends State
class_name PlayerPush


var player: Player

func physics_update(delta: float):
	player = state_machine.get_parent()
	player.velocity = player.last_move_dir * (player.speed / 3)
	
	player.animation_player.play("push_%s" % player.last_sprt_dir)
	player.move_and_slide()
	
	var player_input = Input.get_vector("left", "right", "up", "down") 
	
	if player_input == Vector2.ZERO:
		state_machine.change_state("playeridle")
	elif Input.is_action_just_released("push"):
		state_machine.change_state("playerwalk")
