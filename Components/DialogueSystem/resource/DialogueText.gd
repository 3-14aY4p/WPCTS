class_name DialogueText extends DE

@export var speaker_name: String
@export var speaker_anim: String

@export_multiline var text: String
@export_range(0.0, 1000, 0.1) var text_speed: float = 75.0
#@export_range(0.0, 5, 0.1) var text_speed: float = 0.4

# can add audio for the text here (add AudioStreamPlayer first)
# can also add variables for the camera
