@tool
class_name ARKitPacket
extends RefCounted

## Magic number for ARKit UDP packet format. Must be 6.
const PACKET_VERSION: int = 6

var packet_version: int
var device_id_length: int
var device_id: String
var subject_name_length: int
var subject_name: String
var frame: int
var subframe: int
var fps: int
var denominator: int
var number_of_blendshapes: int
var blendshapes_array: PackedFloat32Array = PackedFloat32Array()


func _init(array_bytes: PackedByteArray) -> void:
	var stream_peer_buffer: StreamPeerBuffer = StreamPeerBuffer.new()
	stream_peer_buffer.data_array = array_bytes.duplicate()
	stream_peer_buffer.big_endian = true

	packet_version = stream_peer_buffer.get_u8()
	if packet_version != PACKET_VERSION:
		push_error("Not an ARKit UDP stream. Magic number is not %d" % PACKET_VERSION)
		return
	
	device_id_length = stream_peer_buffer.get_u32()
	device_id = stream_peer_buffer.get_string(device_id_length)
	subject_name_length = stream_peer_buffer.get_u32()
	subject_name = stream_peer_buffer.get_string(subject_name_length)
	frame = stream_peer_buffer.get_u32()
	subframe = stream_peer_buffer.get_u32()
	fps = stream_peer_buffer.get_u32()
	denominator = stream_peer_buffer.get_u32()
	number_of_blendshapes = stream_peer_buffer.get_u8()
	
	for _i in range(number_of_blendshapes):
		blendshapes_array.append(stream_peer_buffer.get_float())
