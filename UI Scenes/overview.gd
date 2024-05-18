extends Control

signal threat_researched

@export var threat_intel_item_scene:PackedScene

var is_dragged:bool = false
var mouse_start_difference
var research_toggle:bool = false # false = Items can be researched

func _process(delta):
	if is_dragged:
		position = get_global_mouse_position() - mouse_start_difference
		ensure_min_max()

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			initiate_drag()
		else:
			is_dragged = false

func initiate_drag():
	mouse_start_difference = get_global_mouse_position() - position
	is_dragged = true

func ensure_min_max():
	position.x = clamp(position.x, 0, 1420)
	position.y = clamp(position.y, 65, 695)

func successful_attack_update(threat_name:String):
	for node in %ThreatIntelList.get_children():
		if node.is_in_group("intel_item") and node.display_name == threat_name:
			node.update_successful_attacks()
			return

func threat_feed_message(message:String):
	%'Threat Feed'.new_message(message)

func update_overview(information:Dictionary):
	for key in information.keys():
		var this_key = %Overview.find_child(key)
		if this_key:
			this_key.find_child("ItemProperty").text = str(information[key])

#Min (0,65) Max (-525,-365)

func add_threat_intel_item(threat_information:ThreatActor):
	var threat_intel_item = threat_intel_item_scene.instantiate()
	threat_intel_item.initiate_item(threat_information)
	threat_intel_item.add_to_group("intel_item")
	threat_intel_item.show_clicked.connect(close_threat_intel_description)
	threat_intel_item.threat_researched.connect(threat_item_researched)
	threat_intel_item.active_research.connect(toggle_research_mode)
	threat_intel_item.toggle_research_button(research_toggle)
	%ThreatIntelList.add_child(threat_intel_item)

func close_threat_intel_description(signal_node):
	for node in %ThreatIntelList.get_children():
		if node.is_in_group("intel_item") and node.viewing and node != signal_node:
			node._on_info_button_pressed()
			return

func threat_item_researched(display_name:String):
	threat_researched.emit(display_name)
	toggle_research_mode()

func toggle_research_mode():
	research_toggle = !research_toggle
	for node in %ThreatIntelList.get_children():
		if node.is_in_group("intel_item") and !node.researched:
			node.toggle_research_button(research_toggle)
	pass
