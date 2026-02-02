extends State
class_name PlayerIdle


var player: Player

func enter():
	player = state_machine.get_parent()

func physics_update(delta: float):
	player.animation_player.play("idle_%s" % player.last_sprt_dir)

func handle_input(event: InputEvent):
	if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("up") or Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		state_machine.change_state("playerwalk")
		
	elif Input.is_action_just_pressed("grab"):
		state_machine.change_state("playergrab")
		
	elif Input.is_action_just_pressed("shove"):
		state_machine.change_state("playershove")
