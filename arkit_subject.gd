class_name  ARKitSubject extends RefCounted

signal timed_out

var device_id: String
var subject_name: String
var last_seen_unix: float
var packet: ARKitPacket

func _init(arkit_packet: ARKitPacket) -> void:
	last_seen_unix = Time.get_unix_time_from_system()
	device_id = arkit_packet.device_id
	subject_name = arkit_packet.subject_name
	packet = arkit_packet

func update_packet(arkit_packet: ARKitPacket) -> void:
	packet = arkit_packet
	var current_time_unix: float = Time.get_unix_time_from_system()
	if current_time_unix - last_seen_unix > 30.:
		timed_out.emit()
	else:
		last_seen_unix = current_time_unix
