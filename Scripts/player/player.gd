extends CharacterBody2D
class_name Player


@export var speed = 75.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

var last_dir: String = "down"
