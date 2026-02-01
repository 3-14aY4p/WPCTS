extends State
class_name PlayerWalk


func enter():
	pass

func physics_update(delta: float):
	var player: Player = state_machine.get_parent()
	player.velocity = Input.get_vector("left", "right", "up", "down") * player.speed
	
	player.animation_player.play("walk_%s" % player.last_dir)
	if player.velocity.y > 0:
		player.last_dir = "down"
	elif player.velocity.y < 0:
		player.last_dir = "up"
		
	if player.velocity.x > 0:
		player.sprite_2d.flip_h = false
	elif player.velocity.x < 0:
		player.sprite_2d.flip_h = true
		
	player.move_and_slide()
	
	if player.velocity == Vector2.ZERO:
		player.animation_player.play("idle_%s" % player.last_dir)
		state_machine.change_state("playeridle")
