@tool
extends HBoxContainer

static var BLENDSHAPE_NAMES: Array = [
	"EyeBlinkLeft",
	"EyeLookDownLeft",
	"EyeLookInLeft",
	"EyeLookOutLeft",
	"EyeLookUpLeft",
	"EyeSquintLeft",
	"EyeWideLeft",
	"EyeBlinkRight",
	"EyeLookDownRight",
	"EyeLookInRight",
	"EyeLookOutRight",
	"EyeLookUpRight",
	"EyeSquintRight",
	"EyeWideRight",
	"JawForward",
	"JawRight",
	"JawLeft",
	"JawOpen",
	"MouthClose",
	"MouthFunnel",
	"MouthPucker",
	"MouthRight",
	"MouthLeft",
	"MouthSmileLeft",
	"MouthSmileRight",
	"MouthFrownLeft",
	"MouthFrownRight",
	"MouthDimpleLeft",
	"MouthDimpleRight",
	"MouthStretchLeft",
	"MouthStretchRight",
	"MouthRollLower",
	"MouthRollUpper",
	"MouthShrugLower",
	"MouthShrugUpper",
	"MouthPressLeft",
	"MouthPressRight",
	"MouthLowerDownLeft",
	"MouthLowerDownRight",
	"MouthUpperUpLeft",
	"MouthUpperUpRight",
	"BrowDownLeft",
	"BrowDownRight",
	"BrowInnerUp",
	"BrowOuterUpLeft",
	"BrowOuterUpRight",
	"CheekPuff",
	"CheekSquintLeft",
	"CheekSquintRight",
	"NoseSneerLeft",
	"NoseSneerRight",
	"TongueOut",
	"HeadYaw",
	"HeadPitch",
	"HeadRoll",
	"LeftEyeYaw",
	"LeftEyePitch",
	"LeftEyeRoll",
	"RightEyeYaw",
	"RightEyePitch",
	"RightEyeRoll",
]

@onready var _subject_infos: VBoxContainer = %SubjectInfos
@onready var _device_id_value: Label = %DeviceIDValue
@onready var _subject_name_value: Label = %SubjectNameValue
@onready var _frame_value: Label = %FrameValue
@onready var _sub_frame_value: Label = %SubFrameValue
@onready var _fps_value: Label = %FPSValue
@onready var _denominator_value: Label = %DenominatorValue
@onready var _blendshapes_menu: VBoxContainer = %BlendshapesMenu
@onready var _blendshape_container: VFlowContainer = %BlendshapeContainer
@onready var _blendshape_info: HBoxContainer = %BlendshapeInfo
@onready var _error_display: Label = %ErrorDisplay
@onready var _subjects_list: ItemList = %SubjectsList
@onready var _start_server: CheckBox = $VBoxContainer/ServerMenu/StartServer

var _shown_subjects: Dictionary[String, int]
var _subject_name_to_id: Dictionary[String, String]
var _selected_subject_id: String


func _ready() -> void:
	_subjects_list.clear()
	_hide_subject()

	ARKitSingleton.show_error.connect(_on_error_shown)
	ARKitSingleton.add_subject.connect(_on_add_subject)
	ARKitSingleton.remove_subject.connect(_on_remove_subject)
	
	# Set blendshape progress bars and names into container
	for i in len(BLENDSHAPE_NAMES):
		var temp_blendshape_info = _blendshape_info.duplicate()
		temp_blendshape_info.get_child(1).text = BLENDSHAPE_NAMES[i]
		_blendshape_container.add_child(temp_blendshape_info)
		temp_blendshape_info.show()


func _process(delta: float) -> void:
	if _selected_subject_id == "":
		return
		
	if not ARKitSingleton.has_subject(_selected_subject_id):
		return
		
	var subject: ARKitSubject = ARKitSingleton.get_subject(_selected_subject_id)
	# Get the selected subject and display the ARKit packet info
	if subject:
		_set_subject_infos(subject)
		var packet: ARKitPacket = subject.packet
		for i: int in range(packet.number_of_blendshapes):
			var blendshape_value = packet.blendshapes_array[i]
			# Progress bar is always the first child since it's instantiated in _ready
			_blendshape_container.get_child(i).get_child(0).value = blendshape_value


func _on_start_server_toggled(toggled_on: bool) -> void:
	if toggled_on:
		ARKitSingleton.start_server.emit()
	else:
		ARKitSingleton.stop_server.emit()
		_shown_subjects.clear()
		_subject_name_to_id.clear()
		_subjects_list.clear()
		_selected_subject_id = ""
		_hide_subject()
		_error_display.text = ""


func _on_server_port_text_submitted(new_text: String) -> void:
	if new_text.is_valid_int():
		if new_text.to_int() >= 65535:
			_error_display.text = "Max port is 65534"
			return
		if new_text.to_int() <= 1023:
			_error_display.text = "Min port is 1024"
			return
		_hide_subject()
		_start_server.button_pressed = false
		ARKitSingleton.change_port.emit(new_text.to_int())
	else:
		_error_display.text = "Enter a valid port number"


func _on_error_shown(error: String) -> void:
	_error_display.text = error


func _on_add_subject(subject: ARKitSubject) -> void:
	var subject_name: String = subject.subject_name
	var i: int = _subjects_list.add_item(subject.subject_name)
	_shown_subjects[subject.device_id] = i
	_subject_name_to_id[subject.subject_name] = subject.device_id

	# Switch to the new one
	_subjects_list.select(i)
	_show_subject()
	_selected_subject_id = subject.device_id


func _on_remove_subject(subject: ARKitSubject) -> void:
	if _shown_subjects.has(subject.device_id):
		var i: int = _shown_subjects[subject.device_id]
		_subjects_list.remove_item(i)
		_shown_subjects.erase(subject.device_id)
		_subject_name_to_id.erase(subject.subject_name)
		
		# Update indices for all subjects after the removed one
		for device_id in _shown_subjects.keys():
			if _shown_subjects[device_id] > i:
				_shown_subjects[device_id] -= 1
		
		# Clear selection if no subjects left
		if _subjects_list.item_count == 0:
			_selected_subject_id = ""
			_hide_subject()
		else:
			# Auto-select first item
			_subjects_list.select(0)
			_selected_subject_id = _shown_subjects.keys()[0]


func _hide_subject() -> void:
	_subject_infos.hide()
	_blendshapes_menu.hide()


func _show_subject() -> void:
	_subject_infos.show()
	_blendshapes_menu.show()


func _set_subject_infos(subject: ARKitSubject) -> void:
	_device_id_value.text = str(subject.device_id)
	_subject_name_value.text = str(subject.subject_name)
	_frame_value.text = str(subject.packet.frame)
	_sub_frame_value.text = str(subject.packet.subframe)
	_fps_value.text = str(subject.packet.fps)
	_denominator_value.text = str(subject.packet.denominator)


func _on_subjects_list_item_selected(index: int) -> void:
	# Find which device_id corresponds to this index
	for device_id in _shown_subjects.keys():
		if _shown_subjects[device_id] == index:
			_selected_subject_id = device_id
			_show_subject()
			return
