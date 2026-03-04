class_name ObjectData extends Resource


#on second thoughts... nope
#@export var object_name: String = ""
#@export var sprite: Texture

@export var material: PhysicsMaterial

@export_range(0.1, 20) var object_mass: float = 1.0
@export_enum("Combine", "Replace") var damp_mode: String = "Replace"
@export_range(0.1, 100) var damp: float = 3.0
