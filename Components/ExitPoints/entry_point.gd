extends Marker2D


@export var point_id: String


func _ready() -> void:
	if point_id == Global.last_exit_id:
		var player = preload("uid://cnlfarynwyvu4")
		var player_instance = player.instantiate()
		
		get_owner().add_child.call_deferred(player_instance)
		player_instance.global_position = global_position
