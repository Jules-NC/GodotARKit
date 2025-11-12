![Godot](https://img.shields.io/badge/Godot-4.x%2B-blue) ![License](https://img.shields.io/badge/License-MIT-green.svg)
# GodotARKit: Real-time facial Mocap! 

GodotARKit is a Godot 4 plugin designed to stream real-time facial motion capture from an ARKit UDP stream. Download LiveLinkFace on your phone, and get access to all the blendshapes of your faces via a singleton. Also work in game.

The blendshapes can be connected to your 3D model to animate them in real-time.

# Features
- **Editor integration**: Built-in editor panel accessible from the bottom panel provides real-time monitoring of connected devices, live blendshape value visualization, packet frame information, and error status display.
- **Seamless access**: All the blendshapes, from an autoload.

---
# Setup

1. use your phone to create a UDP server (typically via LiveLinkFace), make your target your godot computer **LOCAL** IP. Use the port you want
2. Open the addon bottom panel, select your port, enable the server
3. Your device should appear in the subjects list automatically and show you the result


#### Animate your MeshInstance3D with one loop
```gdscript
class_name GodotARKitExample extends Node3D

var your_mesh_instance: MeshInstance3D # Your face

func _init() -> void:
	# Start the server on the port of your choice
	ARKitSingleton._server.change_port(11111)
	ARKitSingleton._server.start()

func _process(delta: float) -> void:
	var eye_blink_left: float
	var first_subject: ARKitSubject

	# Check if at least one subject (ARKit UDP service screaming at you) exists
	if len(ARKitSingleton._server.subjects.keys()) == 0:
		return

	# Select the first subject like a brute
	for subject: ARKitSubject in ARKitSingleton._server.subjects.values():
		first_subject = subject
		break

	# Change each blendshape of your model
	for i in range(first_subject.packet.number_of_blendshapes):
		var blendshape_name: String = ARKitServer.blendshape_string_mapping[i]
		var blendshape_value: float = first_subject.packet.blendshapes_array[i]

		# THIS IS JUST A RAPID EXAMPLE SHOWING YOU HOW TO USE IT.
		# There are 61 blendshapes, but 3 of them are for the head rotation,
		# and 6 are dedicated to the eyes rotation.
		# One of them is the tongue.
		# You will generally use:
		# - One head with many of those blendshapes,
		# - One tongue,
		# - One mouth interior,
		# - One pair of eyes,
		# - Use the head rotation directly in the skeleton.
		# So in the end, your code will be really different, but you have the basics covered.
		set_blend_shape(your_mesh_instance, blendshape_name, blendshape_value)


static func set_blend_shape(mesh_instance: MeshInstance3D, blendshape_name: String, blendshape_value: float) -> void:
	var blend_shape_idx: int = mesh_instance.find_blend_shape_by_name(blendshape_name)
	if blend_shape_idx == -1:
		return # Not found
	mesh_instance.set_blend_shape_value(blend_shape_idx, blendshape_value)
```
#### Blendshapes String enum: 
```gdscript
# For better convenience, name your 3D model shapekeys correctly (PascalCase)
# and just do a loop of the key/values of ARKitServer.blendshape_string_mapping
var blendshape_name: String = ARKitServer.blendshape_string_mapping[ARKitServer.BlendShape.EYE_LOOK_IN_LEFT]
# Use another system to rotate the head/eyes
```
#### Blendshapes int enum (indexes of ARKitPacket.blendshapes_array):
```gdscript
# You can use it as indexes of the ARKitPacket float32 array
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
```

---

# Troubleshooting
#### Device Not Connecting
- Verify same Wi-Fi network
- Check computer's local IP address
- Ping yourself both ways
- Ensure port matches (default: 11111)
- Check firewall UDP settings
- Verify "Start Server" is enabled
- Check if the addon creator is to blame

# Credits
Developed for the Godot community by: **Jules Neghnagh--Chenavas**

## Contributing
Yes, I'm sure I made errors, especially on the UI. Didn't even test with more than one device.


## License
This addon has been released under the **MIT License**
