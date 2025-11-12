@tool
extends Node

var _subjects: Dictionary[String, ARKitSubject] = {}

signal start_server
signal stop_server
signal change_port(p: int)
signal show_error(e: String)
signal clear_error
signal add_subject(s: ARKitSubject)
signal remove_subject(s: ARKitSubject)
signal select_subject(subject_device_id: String)

var _server: ARKitServer = ARKitServer.new(11111)


func has_subject_from_name(subject_name: String) -> bool:
	for subject in _server.subjects.values():
		if subject.subject_name == subject_name:
			return true
	return false


func get_subject_from_name(subject_name: String) -> ARKitSubject:
	for subject in _server.subjects.values():
		if subject.subject_name == subject_name:
			return subject
	return null


func get_subject_list() -> Array[ARKitSubject]:
	var result: Array[ARKitSubject] = []
	for subject in _server.subjects.values():
		result.append(subject)
	return result


func has_subject(device_id: String) -> bool:
	return _server.subjects.has(device_id)


func get_subject(device_id: String) -> ARKitSubject:
	if has_subject(device_id):
		return _server.subjects.get(device_id)
	return null


func _ready() -> void:
	change_port.connect(_on_change_port)
	start_server.connect(_server.start)
	stop_server.connect(_server.stop)


func _process(delta: float) -> void:
	_server.poll()


func _exit_tree() -> void:
	_server.stop()


func _on_change_port(port: int) -> void:
	_server.change_port(port)
