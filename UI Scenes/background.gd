extends Node2D

signal map_clicked

@export var location:PackedScene

#TODO: Remove this script and put it into a game manager node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	for loc in LocationRepo.LocationNames:
		var new_location = location.instantiate()
		var info = LocationRepo.LocationDB.get(loc)
		#var info = LocationRepo.LocationDB.get(LocationRepo.LocationNames.pick_random())
		new_location.position = Vector2(info.location_x, info.location_y)
		#new_location.mouse_hovered.connect(deselect_all_location)
		#add_child(new_location)

func _on_image_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		print(event)
		print("Map Clicked")
		map_clicked.emit()
