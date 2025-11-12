@tool
extends EditorPlugin
const ARKIT_MENU = preload("uid://bmmmwgdvt6ymb")
const ArkitAutoload:String = "arkit_autoload.gd"

var control: Control

func _enter_tree() -> void:
	add_autoload_singleton("ARKitSingleton", ArkitAutoload)

	control = ARKIT_MENU.instantiate()
	add_control_to_bottom_panel(control, "GodotARKit")

func _exit_tree() -> void:
	if control:
		# Call remove control before queue freeing it!
		remove_control_from_bottom_panel(control)
		control.queue_free()
