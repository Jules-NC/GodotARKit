@tool
extends Node

var subjects: Dictionary[String, ARKitSubject] = {}

signal start_server
signal stop_server
signal change_port(p: int)
signal show_error(e: String)
signal clear_error
signal add_subject(s: ARKitSubject)
signal remove_subject(s: ARKitSubject)
signal select_subject(subject_device_ID: String)

var server:ARKitServer = ARKitServer.new(11111)

func has_subject(device_id: String) -> bool:
	return server.subjects.has(device_id)


func get_subject(device_id: String):
	if has_subject(device_id):
		return server.subjects.get(device_id)


func _ready() -> void:
	change_port.connect(_on_change_port)
	start_server.connect(server.start)
	stop_server.connect(server.stop)


func _process(delta: float) -> void:
	server.poll()


func _exit_tree() -> void:
	server.stop()

func _on_change_port(i:int):
	server.change_port(i)
