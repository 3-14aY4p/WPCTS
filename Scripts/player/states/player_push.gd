extends State
class_name PlayerPush


var player: Player
var player_input: Vector2

func enter():
	player = state_machine.get_parent()

func physics_update(delta: float):
	player_input = Input.get_vector("left", "right", "up", "down")
	player.velocity = player_input * (player.speed / 3) #i wanna lock it into one direction
	
	player.animation_player.play("push_%s" % player.last_sprt_dir)
	player.move_and_slide()
	
	if Input.is_action_just_released("push") and player_input == Vector2.ZERO:
		state_machine.change_state("playeridle")
		
	elif Input.is_action_just_released("push") and player_input != Vector2.ZERO:
		state_machine.change_state("playerwalk")
