@tool
class_name ARKitServer
extends RefCounted

enum BlendShape {
	EYE_BLINK_LEFT = 0,
	EYE_LOOK_DOWN_LEFT = 1,
	EYE_LOOK_IN_LEFT = 2,
	EYE_LOOK_OUT_LEFT = 3,
	EYE_LOOK_UP_LEFT = 4,
	EYE_SQUINT_LEFT = 5,
	EYE_WIDE_LEFT = 6,
	EYE_BLINK_RIGHT = 7,
	EYE_LOOK_DOWN_RIGHT = 8,
	EYE_LOOK_IN_RIGHT = 9,
	EYE_LOOK_OUT_RIGHT = 10,
	EYE_LOOK_UP_RIGHT = 11,
	EYE_SQUINT_RIGHT = 12,
	EYE_WIDE_RIGHT = 13,
	JAW_FORWARD = 14,
	JAW_RIGHT = 15,
	JAW_LEFT = 16,
	JAW_OPEN = 17,
	MOUTH_CLOSE = 18,
	MOUTH_FUNNEL = 19,
	MOUTH_PUCKER = 20,
	MOUTH_RIGHT = 21,
	MOUTH_LEFT = 22,
	MOUTH_SMILE_LEFT = 23,
	MOUTH_SMILE_RIGHT = 24,
	MOUTH_FROWN_LEFT = 25,
	MOUTH_FROWN_RIGHT = 26,
	MOUTH_DIMPLE_LEFT = 27,
	MOUTH_DIMPLE_RIGHT = 28,
	MOUTH_STRETCH_LEFT = 29,
	MOUTH_STRETCH_RIGHT = 30,
	MOUTH_ROLL_LOWER = 31,
	MOUTH_ROLL_UPPER = 32,
	MOUTH_SHRUG_LOWER = 33,
	MOUTH_SHRUG_UPPER = 34,
	MOUTH_PRESS_LEFT = 35,
	MOUTH_PRESS_RIGHT = 36,
	MOUTH_LOWER_DOWN_LEFT = 37,
	MOUTH_LOWER_DOWN_RIGHT = 38,
	MOUTH_UPPER_UP_LEFT = 39,
	MOUTH_UPPER_UP_RIGHT = 40,
	BROW_DOWN_LEFT = 41,
	BROW_DOWN_RIGHT = 42,
	BROW_INNER_UP = 43,
	BROW_OUTER_UP_LEFT = 44,
	BROW_OUTER_UP_RIGHT = 45,
	CHEEK_PUFF = 46,
	CHEEK_SQUINT_LEFT = 47,
	CHEEK_SQUINT_RIGHT = 48,
	NOSE_SNEER_LEFT = 49,
	NOSE_SNEER_RIGHT = 50,
	TONGUE_OUT = 51,
	HEAD_YAW = 52,
	HEAD_PITCH = 53,
	HEAD_ROLL = 54,
	LEFT_EYE_YAW = 55,
	LEFT_EYE_PITCH = 56,
	LEFT_EYE_ROLL = 57,
	RIGHT_EYE_YAW = 58,
	RIGHT_EYE_PITCH = 59,
	RIGHT_EYE_ROLL = 60,
}

static var blendshape_string_mapping: Dictionary[int, String] = {
	BlendShape.EYE_BLINK_LEFT: "EyeBlinkLeft",
	BlendShape.EYE_LOOK_DOWN_LEFT: "EyeLookDownLeft",
	BlendShape.EYE_LOOK_IN_LEFT: "EyeLookInLeft",
	BlendShape.EYE_LOOK_OUT_LEFT: "EyeLookOutLeft",
	BlendShape.EYE_LOOK_UP_LEFT: "EyeLookUpLeft",
	BlendShape.EYE_SQUINT_LEFT: "EyeSquintLeft",
	BlendShape.EYE_WIDE_LEFT: "EyeWideLeft",
	BlendShape.EYE_BLINK_RIGHT: "EyeBlinkRight",
	BlendShape.EYE_LOOK_DOWN_RIGHT: "EyeLookDownRight",
	BlendShape.EYE_LOOK_IN_RIGHT: "EyeLookInRight",
	BlendShape.EYE_LOOK_OUT_RIGHT: "EyeLookOutRight",
	BlendShape.EYE_LOOK_UP_RIGHT: "EyeLookUpRight",
	BlendShape.EYE_SQUINT_RIGHT: "EyeSquintRight",
	BlendShape.EYE_WIDE_RIGHT: "EyeWideRight",
	BlendShape.JAW_FORWARD: "JawForward",
	BlendShape.JAW_RIGHT: "JawRight",
	BlendShape.JAW_LEFT: "JawLeft",
	BlendShape.JAW_OPEN: "JawOpen",
	BlendShape.MOUTH_CLOSE: "MouthClose",
	BlendShape.MOUTH_FUNNEL: "MouthFunnel",
	BlendShape.MOUTH_PUCKER: "MouthPucker",
	BlendShape.MOUTH_RIGHT: "MouthRight",
	BlendShape.MOUTH_LEFT: "MouthLeft",
	BlendShape.MOUTH_SMILE_LEFT: "MouthSmileLeft",
	BlendShape.MOUTH_SMILE_RIGHT: "MouthSmileRight",
	BlendShape.MOUTH_FROWN_LEFT: "MouthFrownLeft",
	BlendShape.MOUTH_FROWN_RIGHT: "MouthFrownRight",
	BlendShape.MOUTH_DIMPLE_LEFT: "MouthDimpleLeft",
	BlendShape.MOUTH_DIMPLE_RIGHT: "MouthDimpleRight",
	BlendShape.MOUTH_STRETCH_LEFT: "MouthStretchLeft",
	BlendShape.MOUTH_STRETCH_RIGHT: "MouthStretchRight",
	BlendShape.MOUTH_ROLL_LOWER: "MouthRollLower",
	BlendShape.MOUTH_ROLL_UPPER: "MouthRollUpper",
	BlendShape.MOUTH_SHRUG_LOWER: "MouthShrugLower",
	BlendShape.MOUTH_SHRUG_UPPER: "MouthShrugUpper",
	BlendShape.MOUTH_PRESS_LEFT: "MouthPressLeft",
	BlendShape.MOUTH_PRESS_RIGHT: "MouthPressRight",
	BlendShape.MOUTH_LOWER_DOWN_LEFT: "MouthLowerDownLeft",
	BlendShape.MOUTH_LOWER_DOWN_RIGHT: "MouthLowerDownRight",
	BlendShape.MOUTH_UPPER_UP_LEFT: "MouthUpperUpLeft",
	BlendShape.MOUTH_UPPER_UP_RIGHT: "MouthUpperUpRight",
	BlendShape.BROW_DOWN_LEFT: "BrowDownLeft",
	BlendShape.BROW_DOWN_RIGHT: "BrowDownRight",
	BlendShape.BROW_INNER_UP: "BrowInnerUp",
	BlendShape.BROW_OUTER_UP_LEFT: "BrowOuterUpLeft",
	BlendShape.BROW_OUTER_UP_RIGHT: "BrowOuterUpRight",
	BlendShape.CHEEK_PUFF: "CheekPuff",
	BlendShape.CHEEK_SQUINT_LEFT: "CheekSquintLeft",
	BlendShape.CHEEK_SQUINT_RIGHT: "CheekSquintRight",
	BlendShape.NOSE_SNEER_LEFT: "NoseSneerLeft",
	BlendShape.NOSE_SNEER_RIGHT: "NoseSneerRight",
	BlendShape.TONGUE_OUT: "TongueOut",
	BlendShape.HEAD_YAW: "HeadYaw",
	BlendShape.HEAD_PITCH: "HeadPitch",
	BlendShape.HEAD_ROLL: "HeadRoll",
	BlendShape.LEFT_EYE_YAW: "LeftEyeYaw",
	BlendShape.LEFT_EYE_PITCH: "LeftEyePitch",
	BlendShape.LEFT_EYE_ROLL: "LeftEyeRoll",
	BlendShape.RIGHT_EYE_YAW: "RightEyeYaw",
	BlendShape.RIGHT_EYE_PITCH: "RightEyePitch",
	BlendShape.RIGHT_EYE_ROLL: "RightEyeRoll",
}

signal send_blendshapes(bl_floats: PackedFloat32Array)
signal add_subject(s: ARKitSubject)
signal remove_subject(s: ARKitSubject)


var _server: UDPServer = UDPServer.new()
var _port: int = 11111
var subjects: Dictionary[String, ARKitSubject] = {}


func _init(port: int) -> void:
	_port = port


func start() -> void:
	#push_warning("Server Started!!")
	var err: Error = _server.listen(_port)
	if err != OK:
		push_error("Failed to listen on port, check that the editor panel of GodotARKit has no server already enabled, thus already listening to the port %d" % _port)


func change_port(new_port: int) -> void:
	_port = new_port
	_server.stop()


func set_port(new_port: int) -> void:
	if new_port < 65535:
		_port = new_port


func stop() -> void:
	_server.stop()
	for subject in subjects.values():
		self.remove_subject.emit(subject)
	subjects.clear()


func poll() -> void:
	# If not listening, do nothing
	if not _server.is_listening():
		return
	
	# Test for any error
	var err: Error = _server.poll()
	if err != OK:
		push_error("Error: %s" % err)
		return

	# Test if new connection available
	if not _server.is_connection_available():
		return

	var peer: PacketPeerUDP = _server.take_connection()
	if peer == null:
		return  # Connection is null
	
	var array_bytes: PackedByteArray = peer.get_packet()
	var arkit_packet: ARKitPacket = ARKitPacket.new(array_bytes)
	if not subjects.has(arkit_packet.device_id):
		var temp_subject: ARKitSubject = ARKitSubject.new(arkit_packet)
		subjects[arkit_packet.device_id] = temp_subject
		self.add_subject.emit(temp_subject)
	else:
		subjects.get(arkit_packet.device_id).update_packet(arkit_packet)
	send_blendshapes.emit(arkit_packet.blendshapes_array)
