extends State
class_name PlayerGrab


var player: Player
var player_input: Vector2

func enter():
	player = state_machine.get_parent()

func physics_update(delta: float):
	player_input = Input.get_vector("left", "right", "up", "down")
	player.velocity = player_input * (player.speed / 3)
	
	player.animation_player.play("grab_%s" % player.last_sprt_dir)
	player.move_and_slide()

func handle_input(event: InputEvent):
	if Input.is_action_just_released("grab"):
		if player_input == Vector2.ZERO:
			state_machine.change_state("playeridle")
		elif player_input != Vector2.ZERO:
			state_machine.change_state("playerwalk")
