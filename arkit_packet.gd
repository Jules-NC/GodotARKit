class_name ARKitPacket extends RefCounted

var packet_version: int # MAGIC NUMBER MUST BE 6 !!!!
var device_id_length:int
var device_id:String
var subject_name_length:int
var subject_name:String
var frame: int
var subframe:int
var fps:int
var denominator:int
var number_of_blendshapes: int
var blendshapes_array: PackedFloat32Array = PackedFloat32Array()

func _init(array_bytes:PackedByteArray):
	var stream_peer_buffer:StreamPeerBuffer = StreamPeerBuffer.new()
	stream_peer_buffer.data_array = array_bytes.duplicate()
	stream_peer_buffer.big_endian = true

	packet_version = stream_peer_buffer.get_u8()
	if packet_version != 6:
		push_error("Mot an ARKit UDP stream, Magic number is not 6")
		return
	
	device_id_length  = stream_peer_buffer.get_u32()
	device_id = stream_peer_buffer.get_string(device_id_length)
	subject_name_length = stream_peer_buffer.get_u32()
	subject_name = stream_peer_buffer.get_string(subject_name_length)
	frame = stream_peer_buffer.get_u32()
	subframe = stream_peer_buffer.get_u32()
	fps = stream_peer_buffer.get_u32()
	denominator = stream_peer_buffer.get_u32()
	number_of_blendshapes = stream_peer_buffer.get_u8()
	
	for i in range(number_of_blendshapes):
		blendshapes_array.append(stream_peer_buffer.get_float())
