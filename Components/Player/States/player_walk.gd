class_name PlayerWalk extends State


var player: Player


func enter():
	player = state_machine.get_parent()

func physics_update(delta: float):
	player._handle_sprt_dir()
	player._handle_movement()
	player.animation_player.play("player/walk")
	
	if player.velocity == Vector2.ZERO:
		state_machine.change_state("playeridle")

func handle_input(event: InputEvent):
	if Input.is_action_just_pressed("_shove"):
		state_machine.change_state("playershove")
