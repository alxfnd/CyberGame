extends Marker2D

signal mouse_hovered
signal pull_to_front
signal item_bought_signal
signal threat_feed_update

@export var cyber_controls_scene:PackedScene
@onready var cyber_controls = cyber_controls_scene.instantiate()

@onready var hovered:bool = false
@onready var selected:bool = false
@onready var control_persist:bool = false

@onready var colour_chart: Dictionary = GeneralRepo.ColourRepo.duplicate()

#TODO: REMOVE THIS AND PUT IT SOMEWHERE APPROPRIATE
@onready var health_state: String = "Healthy"
@onready var confidentiality: int = 1
@onready var integrity: int = 1
@onready var availability: int = 1
@onready var reputation: int = 1
@onready var under_attack: bool = false
@onready var attack_list:Dictionary = {"CONFIDENTIALITY" : 0, "INTEGRITY" : 0, "AVAILABILITY": 0}
var attacker_names:Array

var control_strengths:Dictionary = {"PHYSICAL" : 0, "WEB" : 0, "NETWORK": 0, "ASSET": 0, "IDENTITY": 0, "REPUTATION": 0}
var breach_count = 0

func _ready():
	$VisibleSquare.set_color(Color.html(colour_chart.get(health_state).deselected))
	cyber_controls.hide()
	cyber_controls.item_bought_signal.connect(item_bought)
	add_child(cyber_controls)
	first_appeared()

func set_context_info(this_info:Dictionary, this_image:Texture2D):
	name = this_info.name
	cyber_controls.set_context_info(this_info, this_image)

func set_org_context(this_org):
	control_strengths["Reputation"] = this_org.reputation - 5
	update_reputation()

func _on_visible_square_mouse_entered():
	mouse_hovered.emit()
	if control_persist:
		return
	hovered = true
	$VisibleSquare.set_color(Color.html(colour_chart.get(health_state).hover))
	cyber_controls.show()
	cyber_controls.determine_controls_position()

func update_location_colour()-> void:
	$VisibleSquare.set_color(Color.html(colour_chart.get(health_state).deselected))

func _on_visible_square_mouse_exited()-> void:
	if control_persist:
		return
	#print("Cyber Control Box position: " + str(cyber_controls.position))
	hovered = false
	update_location_colour()
	cyber_controls.hide()

# On Click
func _on_visible_square_gui_input(event)-> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		control_persist = true
		$VisibleSquare.set_color(Color.html(colour_chart.get(health_state).selected))

func deselect()-> void:
	control_persist = false
	_on_visible_square_mouse_exited()

func item_bought(item_id)-> void:
	var category_and_item = retrieve_item_from_db(item_id)
	item_bought_signal.emit(category_and_item.values()[0])
	var category = category_and_item.keys()[0]
	var strength = category_and_item.values()[0].strength
	control_strengths[category] = control_strengths[category] + strength
	cyber_controls.update_control_strengths(category,control_strengths[category])

@onready var flash_count = 1
func first_appeared()-> void:
	flash_count += 1
	if flash_count % 2:
		$VisibleSquare.set_color(Color.WHITE)
	else:
		$VisibleSquare.set_color(Color.html(colour_chart.get(health_state).deselected))
	if flash_count == 8:
		return
	get_tree().create_timer(0.3).timeout.connect(first_appeared)

func retrieve_item_from_db(item_id: int)-> Dictionary:
	for cat in CyberRepo.Item_Categories:
		for item in CyberRepo.ItemDB.get(cat):
			if int(item) == item_id:
				return {cat : CyberRepo.ItemDB[cat][item]}
	print("could not find item")
	return {"Failed" : "retrieve_item_from_db"}

func update_reputation()-> void:
	var current_rep = control_strengths["Reputation"]
	if health_state == "Healthy" and control_strengths["Reputation"] < 101:
		control_strengths["Reputation"] = current_rep + 1
	elif control_strengths["Reputation"] > 0:
		control_strengths["Reputation"] = current_rep - 1
	cyber_controls.update_reputation(control_strengths["Reputation"])

func calculate_attack(attack_details)-> bool:
	var total_strength = attack_details["strength"] - (control_strengths[attack_details["attack_type"]])
	if total_strength < 1:
		return false
	var motivation_score = total_strength * control_strengths["Reputation"]
	var random_element = randf_range(100,800)
	if motivation_score > random_element:
		successful_attack(attack_details["name"], attack_details["target_type"], attack_details["attack_length"])
		return true
	return false

func successful_attack(attacker_name:String, targets:Dictionary, attack_timeout:int)-> void:
	breach_count += 1
	for target in targets.keys():
		if attack_list[target] < targets[target]:
			attack_list[target] = targets[target]
	under_attack = true
	health_state = "Compromised"
	add_attacker_timeout(attacker_name, attack_timeout)
	update_location_colour()
	threat_feed_update.emit(attacker_name + " is currently attacking " + name)

func check_health()-> void:
	confidentiality = 1
	integrity = 1
	availability = 1
	reputation = 1
	for target_type in attack_list.keys():
		if attack_list[target_type] == 0:
			continue
		match target_type:
			"CONFIDENTIALITY":
				confidentiality = 0
				reputation = 0
			"INTEGRITY":
				integrity = 0
				reputation = 0
			"AVAILABILITY":
				availability = 0
				reputation = 0

func attack_cooldown()-> void:
	for target_type in ThreatRepo.Org_Services:
		if target_type != "REPUTATION" and attack_list[target_type] != 0:
			attack_list[target_type] = attack_list[target_type] - 1

func is_attack_end()-> void:
	if attacker_names.size() > 0:
		return
	for value in attack_list.values():
		if value != 0:
			attack_cooldown()
			return
	under_attack = false
	health_state = "Healthy"

func time_checks(time)-> void:
	match time:
		"day":
			if under_attack:
				check_health()
				update_reputation()
				is_attack_end()
			update_service_states()
		"week":
			update_reputation()
		"month":
			#update_reputation()
			pass
	pass

func add_attacker_timeout(attacker_name:String, value:int)-> void:
	attacker_names.append(attacker_name)
	print("before")
	await get_tree().create_timer(value).timeout
	print("after")
	remove_attacker(attacker_name)

func remove_attacker(attacker_name)-> void:
	attacker_names.remove_at(attacker_names.find(attacker_name))

func update_service_states()-> void:
	cyber_controls.update_service_states({"CONFIDENTIALITY":confidentiality,"INTEGRITY":integrity,"AVAILABILITY":availability,"REPUTATION":reputation})
