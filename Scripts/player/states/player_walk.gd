extends State
class_name PlayerWalk


var player: Player

func enter():
	player = state_machine.get_parent()

func physics_update(delta: float):
	player.handle_sprt_dir()
	player.handle_movement()
	player.animation_player.play("walk_%s" % player.last_sprt_dir)
	
	if player.velocity == Vector2.ZERO:
		player.animation_player.play("idle_%s" % player.last_sprt_dir)
		state_machine.change_state("playeridle")

func handle_input(event: InputEvent):
	if Input.is_action_just_pressed("grab"):
		state_machine.change_state("playergrab")
		
	elif Input.is_action_just_pressed("shove"):
		state_machine.change_state("playershove")
