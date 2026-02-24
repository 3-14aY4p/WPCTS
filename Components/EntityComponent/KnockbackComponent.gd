class_name KnockbackComponent extends Node


var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0


func _run_knockback_timer(entity: CharacterBody2D):
	if knockback_timer > 0.0:
		entity.velocity = knockback
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO

func _apply_knockback(dir: Vector2, force: float, kb_duration: float):
	knockback = dir * force
	knockback_timer = kb_duration
