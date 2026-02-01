extends CharacterBody2D
class_name Player


@export var speed = 50.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

var last_sprt_dir: String = "down" #for sprite face direction
var last_move_dir: Vector2 #for determining push direction

@onready var shove_meter: ProgressBar = $MetersUI/ShoveMeter
