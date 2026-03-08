class_name InteractionArea extends Area2D


@onready var player: Player = get_tree().get_first_node_in_group("player")
@export var action_hint: String = "[ E ] interact"


func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")


var interact: Callable = func():
	pass

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		InteractionManager.register_area(self)

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		InteractionManager.unregister_area(self)
