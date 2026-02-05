class_name CameraManager extends Node

# under static body, add Area2D for the zones
# you can then add Collision shapes under it
# as well as the corresponding PhantomCamera

@export var cameras : Array[PhantomCamera2D]
var current_camera_zone : int = 0

@onready var player : Player = get_tree().get_first_node_in_group("player")


# CAMERA LIMITS
func _ready() -> void:
	cameras[0].limit_target = get_tree().get_first_node_in_group("bounds").get_path()
	cameras[0].follow_target = player

# CAMERA ZONING
func update_current_zone(body, zone_a, zone_b):
	if body == player:
		match current_camera_zone:
			zone_a:
				current_camera_zone = zone_b
			zone_b:
				current_camera_zone = zone_a
				
		update_camera(current_camera_zone)

func update_camera(cam):
	for camera in cameras:
		camera.priority = 0
	
	match current_camera_zone:
		cam:
			cameras[cam].priority = 1

func _on_zone_0__1_body_entered(body: Node2D) -> void:
	update_current_zone(body, 0, 1)

func _on_zone_1__2_body_entered(body: Node2D) -> void:
	update_current_zone(body, 1, 2)

func _on_zone_2__3_body_entered(body: Node2D) -> void:
	update_current_zone(body, 2, 3)

func _on_zone_3__4_body_entered(body: Node2D) -> void:
	update_current_zone(body, 3, 4)

func _on_zone_4__5_body_entered(body: Node2D) -> void:
	update_current_zone(body, 4, 5)
