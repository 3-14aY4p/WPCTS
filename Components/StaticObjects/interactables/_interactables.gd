class_name Interactables extends Node


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player: Player = get_tree().get_first_node_in_group("player")

@export var dialogue: Array[DE]


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func trigger_dialogue():
	if not dialogue.is_empty():
		player.state_machine.change_state("playerdialogue")
		var dlg =  preload("uid://b2tmm2aequm2a").instantiate()
		dlg.dialogue = dialogue
		
		add_child(dlg)
