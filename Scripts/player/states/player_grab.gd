extends State
class_name PlayerGrab


var player: Player
var player_input: Vector2
var grabbed_obj: Objects

func enter():
	player = state_machine.get_parent()
	var c = player.look_direction.get_collider()
	if c is Objects and player.look_direction.is_colliding():
		grabbed_obj = c
		grabbed_obj.z_index = 0
		grabbed_obj.reparent(player)

func physics_update(delta: float):
	player.handle_movement(player.default_speed/3) # device formula that incorporates object mass
	player.animation_player.play("grab_%s" % player.last_sprt_dir)

func handle_input(event: InputEvent):
	if Input.is_action_just_released("grab"):
		if player_input == Vector2.ZERO:
			grabbed_obj.z_index = 1
			grabbed_obj.reparent(get_node("../../../Objects"))
			state_machine.change_state("playeridle")
		elif player_input != Vector2.ZERO:
			state_machine.change_state("playerwalk")
