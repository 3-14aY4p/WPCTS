class_name PlayerCarry extends State


var player: Player


func enter():
	player = state_machine.get_parent()
	InteractionManager.can_interact = false
	
	player.grabbed_obj.set_collision_layer_value(2, false)
	player.grabbed_obj.reparent(player.carry_position)

func physics_update(delta: float):
	player.grabbed_obj.global_position = player.carry_position.global_position
	
	var speed_modifier = player.grabbed_obj.mass/2
	if speed_modifier < 2:
		speed_modifier = 2
	
	player.handle_movement(player.default_speed/speed_modifier)
	player.handle_sprt_dir(true)
	
	if player.velocity == Vector2.ZERO:
		player.animation_player.play("player/carry_idle")
	else:
		player.animation_player.play("player/carry_walk")

func handle_input(event: InputEvent):
	if Input.is_action_just_pressed("_drop"):
		if not player.aim_ray_cast.is_colliding():
			player.grabbed_obj.reparent(get_tree().get_first_node_in_group("obj_container"))
			player.grabbed_obj.global_position = player.aim_direction.global_position
			
			player.grabbed_obj.set_collision_layer_value(2, true)
			player.grabbed_obj = null
			
			state_machine.change_state("playeridle")
	
	# we already have shove; throw is a bit redundant
	#elif Input.is_action_just_pressed("_throw"):
		#state_machine.change_state("playerthrow")

func exit():
	InteractionManager.can_interact = true
