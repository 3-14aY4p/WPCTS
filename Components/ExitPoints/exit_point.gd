extends Area2D


@export var point_id: String
@export var scene_uid: String

@export var is_locked: bool = false


# for non-door areas
func _on_body_entered(body: Node2D) -> void:
	if is_locked:
		pass
		
	else:
		Global.last_exit_id = point_id
		Global.game_controller.call_deferred("change_2d_scene", scene_uid)
