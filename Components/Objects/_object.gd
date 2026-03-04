class_name Objects extends RigidBody2D


# Make an ObjectData class later
# Do we want to make some factors random? I think we can... 
@export var object_data: ObjectData

func _ready() -> void:
	if object_data:
		mass = object_data.object_mass
		
		if object_data.material:
			physics_material_override.set_physics_material_override(object_data.material)
		
		if object_data.damp_mode == "Combine":
			linear_damp_mode = RigidBody2D.DAMP_MODE_COMBINE
		elif object_data.damp_mode == "Replace":
			linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
			
	if mass <= 7:
		add_to_group("pickable")
