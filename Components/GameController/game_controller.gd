class_name GameController extends Node


@export var world_2d: Node2D
@export var gui: Control

@export var current_2d_scene: Node2D
@export var current_gui_scene: Control

@export var transition_controller: SceneTransitionController

@onready var player: Player = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	Global.game_controller = self

func change_2d_scene(new_scene: String, delete: bool =  true, keep_running: bool = false,
transition: bool = true, transition_in: String = "fade_in", transition_out: String = "fade_out", 
seconds: float = .2) -> void:
	if transition:
		transition_controller = preload("uid://comj5g2goovkj").instantiate()
		add_child(transition_controller)
		
		transition_controller.transition(transition_out, seconds)
		await transition_controller.animation_player.animation_finished
		
	if current_2d_scene != null:
		if delete:
			current_2d_scene.queue_free() # removes node entirely
		elif keep_running:
			current_2d_scene.visible = false # keeps in memory; running/updating
		else:
			world_2d.remove_child(current_2d_scene) # keeps in memory; not running/updating
	var new = load(new_scene).instantiate()
	world_2d.add_child(new)
	current_2d_scene = new
	
	transition_controller.transition(transition_in, seconds)
	await transition_controller.animation_player.animation_finished
	
	transition_controller.call_deferred("queue_free")


func change_gui_scene(new_scene: String, delete: bool =  true, keep_running: bool = false,
transition: bool = true, transition_in: String = "fade_in", transition_out: String = "fade_out", 
seconds: float = .2) -> void:
	if transition:
		transition_controller = preload("uid://comj5g2goovkj").instantiate()
		add_child(transition_controller)
		
		transition_controller.transition(transition_out, seconds)
		await transition_controller.animation_player.animation_finished
		
	if current_gui_scene != null:
		if delete:
			current_gui_scene.queue_free() # removes node entirely
		elif keep_running:
			current_gui_scene.visible = false # keeps in memory; running/updating
		else:
			gui.remove_child(current_gui_scene) # keeps in memory; not running/updating
	var new = load(new_scene).instantiate()
	gui.add_child(new)
	current_gui_scene = new
	
	transition_controller.transition(transition_in, seconds)
	await transition_controller.animation_player.animation_finished
	
	transition_controller.call_deferred("queue_free")
