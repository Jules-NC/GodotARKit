@tool
extends EditorPlugin
const ARKIT_AUTOLOAD_NAME: String = "ARKitSingleton"
const ARKIT_MENU:String = "uid://bmmmwgdvt6ymb"
const ArkitAutoload:String = "arkit_autoload.gd"

var control: Control

func _enable_plugin() -> void:
	add_autoload_singleton(ARKIT_AUTOLOAD_NAME, ArkitAutoload)
	call_deferred("_setup_ui")


func _setup_ui() -> void:
	control = load(ARKIT_MENU).instantiate()
	add_control_to_bottom_panel(control, "GodotARKit")


func _disable_plugin() -> void:
	if control:
		# Call remove control before queue freeing it!
		remove_control_from_bottom_panel(control)
		control.queue_free()
	remove_autoload_singleton(ARKIT_AUTOLOAD_NAME)
