class_name PlayerIdle extends State


var player: Player


func enter():
	player = state_machine.get_parent()

func physics_update(delta: float):
	player._handle_sprt_dir()
	player.animation_player.play("player/idle")

func handle_input(event: InputEvent):
	if Input.is_action_just_pressed("_up") or Input.is_action_just_pressed("_down") or Input.is_action_just_pressed("_left") or Input.is_action_just_pressed("_right"):
		state_machine.change_state("playerwalk")
		
	elif Input.is_action_just_pressed("_shove"):
		state_machine.change_state("playershove")
