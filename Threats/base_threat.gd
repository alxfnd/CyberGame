class_name ThreatActor
extends Node

signal threat_updated
signal successful_attack

var display_name = "Unknown"

var attack_type
var strength
var reputation_req
var occurrence_per_month
var target_type
var active_range
var dormant_range
var success_chance
var attack_details:Dictionary
var rating
var research_time

var threat_timer = Timer.new()
@onready var is_active = true
var defended_attack = 0

var target_locations:Array

func reveal_name():
	display_name = name
	attack_details["name"] = display_name

func set_info(threat_info:Dictionary):
	name = threat_info["name"]
	attack_details["name"] = display_name
	attack_details["attack_type"] = threat_info["attack_type"]
	attack_details["strength"] = threat_info["strength"]
	attack_details["reputation_req"] = threat_info["reputation_req"]
	occurrence_per_month = threat_info["occurrence_per_month"]
	attack_details["target_type"] = threat_info["target_type"]
	active_range = threat_info["active_range"]
	dormant_range = threat_info["dormant_range"]
	success_chance = threat_info["success_chance"]
	attack_details["attack_length"] = threat_info["attack_length"]
	rating = threat_info["rating"]
	research_time = threat_info["research_time"]
	

func initiate_threat():
	add_child(threat_timer)
	threat_timer.add_to_group("timer")
	threat_timer.timeout.connect(on_timer_timeout)
	on_timer_timeout()
	threat_timer.start()

func on_timer_timeout(natural_timeout:bool = true):
	if is_active:
		if natural_timeout:
			defended_attack += 1
		threat_timer.set_wait_time(randf_range(dormant_range[0], dormant_range[1]))
		is_active = false
		threat_updated.emit()
	else:
		threat_timer.set_wait_time(randf_range(active_range[0], active_range[1]))
		is_active = true
		threat_updated.emit()

func update_targets(location):
	target_locations.append(location)

func active_actions():
	attempt_attack()

func attempt_attack():
	#if location.control_strengths["Reputation"] >= reputation_req:
	if randf_range(0,100) <= success_chance:
		successful_attack.emit(self)
	pass

func dormant_on_success():
	on_timer_timeout(false)
