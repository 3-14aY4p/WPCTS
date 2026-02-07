class_name DialogueArea extends Area2D


const DialogueSystemPreload = preload("uid://cqkcij54l0o6a")

@export var activate_instant: bool
@export var only_activate_once: bool
@export var override_dialogue_position: bool
@export var override_position: Vector2
@export var dialogue: Array[DE]

var dialogue_top_pos: Vector2 = Vector2(160, 48)
var dialogue_bottom_pos: Vector2 = Vector2(160, 192)

var player_in_body: bool = false
var has_activated_already: bool = false
var desired_dialogue_pos: Vector2

@onready var player: Player = get_tree().get_first_node_in_group("player")


func _process(delta: float) -> void:
	if !activate_instant and has_activated_already:
		set_process(false)
		return
		
	if Input.is_action_just_pressed("_interact"):
		_activate_dialogue()
		player_in_body = false

func _activate_dialogue() -> void:
	player.state_machine.change_state("playerdialogue")
	
	var new_dialogue = DialogueSystemPreload.instantiate()
	if override_dialogue_position:
		desired_dialogue_pos = override_position
	else:
		if player.global_position.y > get_viewport().get_camera_2d().get_screen_center_position().y:
			desired_dialogue_pos = dialogue_top_pos
		else:
			desired_dialogue_pos = dialogue_bottom_pos
	
	new_dialogue.global_position = desired_dialogue_pos
	new_dialogue.dialogue = dialogue
	get_parent().add_child(new_dialogue)

func _on_body_entered(body: Node2D) -> void:
	if only_activate_once and has_activated_already:
		return
	
	if body.is_in_group("player"):
		player_in_body = true
		if activate_instant:
			_activate_dialogue()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_body = false
