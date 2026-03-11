class_name DialogueText extends DialogueItem

@export var speaker_name: String
@export var speaker_anim: String

@export_multiline var text: String
@export_range(0.0, 1000, 0.1) var text_speed: float = 75.0
