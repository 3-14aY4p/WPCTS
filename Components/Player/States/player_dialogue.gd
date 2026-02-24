class_name PlayerDialogue extends State


var player: Player


func enter():
	player = state_machine.get_parent()

func physics_update(delta: float):
	player.animation_player.play("player/idle")
	InteractionManager.can_interact = false

func exit():
	InteractionManager.can_interact = true
