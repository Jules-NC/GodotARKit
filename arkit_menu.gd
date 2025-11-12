@tool
extends HBoxContainer
static var BlendshapeNames: Array = ["EyeBlinkLeft","EyeLookDownLeft","EyeLookInLeft","EyeLookOutLeft","EyeLookUpLeft","EyeSquintLeft","EyeWideLeft","EyeBlinkRight","EyeLookDownRight","EyeLookInRight","EyeLookOutRight","EyeLookUpRight","EyeSquintRight","EyeWideRight","JawForward","JawRight","JawLeft","JawOpen","MouthClose","MouthFunnel","MouthPucker","MouthRight","MouthLeft","MouthSmileLeft","MouthSmileRight","MouthFrownLeft","MouthFrownRight","MouthDimpleLeft","MouthDimpleRight","MouthStretchLeft","MouthStretchRight","MouthRollLower","MouthRollUpper","MouthShrugLower","MouthShrugUpper","MouthPressLeft","MouthPressRight","MouthLowerDownLeft","MouthLowerDownRight","MouthUpperUpLeft","MouthUpperUpRight","BrowDownLeft","BrowDownRight","BrowInnerUp","BrowOuterUpLeft","BrowOuterUpRight","CheekPuff","CheekSquintLeft","CheekSquintRight","NoseSneerLeft","NoseSneerRight","TongueOut","HeadYaw","HeadPitch","HeadRoll","LeftEyeYaw","LeftEyePitch","LeftEyeRoll","RightEyeYaw","RightEyePitch","RightEyeRoll",]

@onready var subject_infos: VBoxContainer = %SubjectInfos
@onready var device_id_value: Label = %DeviceIDValue
@onready var subject_name_value: Label = %SubjectNameValue
@onready var frame_value: Label = %FrameValue
@onready var sub_frame_value: Label = %SubFrameValue
@onready var fps_value: Label = %FPSValue
@onready var denominator_value: Label = %DenominatorValue
@onready var blendshapes_menu: VBoxContainer = %BlendshapesMenu
@onready var blendshape_container: VFlowContainer = %BlendshapeContainer
@onready var blendshape_info: HBoxContainer = %BlendshapeInfo
@onready var error_display: Label = %ErrorDisplay
@onready var subjects_list: ItemList = %SubjectsList
@onready var start_server: CheckBox = $VBoxContainer/ServerMenu/StartServer


var shown_subjects: Dictionary[String, int] #DeviceID/int
var subject_name_to_id: Dictionary[String, String] # name/id
var selected_subject_id:String

func _ready() -> void:
	subjects_list.clear()
	hide_subject()

	ARKitSingleton.show_error.connect(_on_error_shown)
	ARKitSingleton.add_subject.connect(_on_add_subject)
	ARKitSingleton.remove_subject.connect(_on_remove_subject)
	
	# Set blendshape progressbars/names into his container
	for i in len(BlendshapeNames):
		var temp_blendshape_info = blendshape_info.duplicate()
		temp_blendshape_info.get_child(1).text = BlendshapeNames[i]
		blendshape_container.add_child(temp_blendshape_info)
		temp_blendshape_info.show()


func _process(delta: float) -> void:
	if selected_subject_id == "":
		return
		
	if not ARKitSingleton.has_subject(selected_subject_id):
		return
		
	var subject: ARKitSubject = ARKitSingleton.get_subject(selected_subject_id)
	# Get the selected subject, and display the ARKit packet info
	if subject:
		set_subject_infos(subject)
		var packet: ARKitPacket = subject.packet
		for i:int in range(packet.number_of_blendshapes):
			var blendshape_value = packet.blendshapes_array[i]
			blendshape_container.get_child(i).get_child(0).value = blendshape_value # This shitty value correspond to the progressbar ID, it's always the same since it's instanciated in _ready


func _on_start_server_toggled(toggled_on: bool) -> void:
	if toggled_on:
		ARKitSingleton.start_server.emit()
	else:
		ARKitSingleton.stop_server.emit()
		shown_subjects.clear()
		subject_name_to_id.clear()
		subjects_list.clear()
		selected_subject_id = ""
		hide_subject()


func _on_server_port_text_submitted(new_text: String) -> void:
	# Overkill?? Yes
	if new_text.is_valid_int():
		error_display.text = "server started"
		if new_text.to_int() >= 65535:
			error_display.text = "Max port is 65534"
			return
		if new_text.to_int() <= 1023:
			error_display.text = "Min port is 1024"
			return
		hide_subject()
		start_server.button_pressed = false
		ARKitSingleton.change_port.emit(new_text.to_int())
	else:
		error_display.text = "Enter a valid port number"


func _on_error_shown(error:String):
	error_display.text = error


func _on_add_subject(subject:ARKitSubject):
	var subject_name: String = subject.subject_name
	var i:int = subjects_list.add_item(subject.subject_name)
	shown_subjects[subject.device_id] = i
	subject_name_to_id[subject.subject_name] = subject.device_id

	# Switch to the new one
	subjects_list.select(i)
	show_subject()
	selected_subject_id = subject.device_id


func _on_remove_subject(subject: ARKitSubject):
	if shown_subjects.has(subject.device_id):
		var i: int = shown_subjects[subject.device_id]
		subjects_list.remove_item(i)
		shown_subjects.erase(subject.device_id)
		subject_name_to_id.erase(subject.subject_name)
		
		# Update indices for all subjects after the removed one
		for device_id in shown_subjects.keys():
			if shown_subjects[device_id] > i:
				shown_subjects[device_id] -= 1
		
		# Clear selection if no subjects left
		if subjects_list.item_count == 0:
			selected_subject_id = ""
			hide_subject()
		else:
			# Auto-select first item
			subjects_list.select(0)
			selected_subject_id = shown_subjects.keys()[0]


func show_packets():
	pass


func hide_subject():
	subject_infos.hide()
	blendshapes_menu.hide()


func show_subject():
	subject_infos.show()
	blendshapes_menu.show()


func set_subject_infos(s: ARKitSubject):
	device_id_value.text = str(	s.device_id)
	subject_name_value.text = str(s.subject_name)
	frame_value.text = str(s.packet.frame)
	sub_frame_value.text = str(s.packet.subframe)
	fps_value.text = str(s.packet.fps)
	denominator_value.text = str(s.packet.denominator)

func _on_subjects_list_item_selected(index: int) -> void:
	# Find which device_id corresponds to this index
	for device_id in shown_subjects.keys():
		if shown_subjects[device_id] == index:
			selected_subject_id = device_id
			show_subject()
			return
