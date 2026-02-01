extends State
class_name PlayerWalk


func physics_update(delta: float):
	var player: Player = state_machine.get_parent()
	var player_input = Input.get_vector("left", "right", "up", "down") 
	
	player.velocity = player_input * player.speed
	player.last_move_dir = player_input
	
	player.animation_player.play("walk_%s" % player.last_sprt_dir)
	if player.velocity.y > 0:
		player.last_sprt_dir = "down"
	elif player.velocity.y < 0:
		player.last_sprt_dir = "up"
		
	if player.velocity.x > 0:
		player.sprite_2d.flip_h = false
	elif player.velocity.x < 0:
		player.sprite_2d.flip_h = true
		
	player.move_and_slide()
	
	if player.velocity == Vector2.ZERO:
		player.animation_player.play("idle_%s" % player.last_sprt_dir)
		state_machine.change_state("playeridle")

func handle_input(event: InputEvent):
	if Input.is_action_just_pressed("push"):
		state_machine.change_state("playerpush")
	elif Input.is_action_just_pressed("shove"):
		state_machine.change_state("playershove")
