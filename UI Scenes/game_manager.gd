extends Node

# This is what the game does on new game launch

@export var background_scene:PackedScene
@onready var background = background_scene.instantiate()
@export var top_menu_scene:PackedScene
@onready var top_menu = top_menu_scene.instantiate()
@export var location:PackedScene
@export var overview_scene:PackedScene
@onready var overview = overview_scene.instantiate()
@export var user_prompt:PackedScene

@export var city_pics:Array[Texture2D]

@onready var unused_cities:Array = LocationRepo.LocationNames.duplicate()
var cities_in_play:Array = []
var location_nodes:Array = []
@onready var player = Player.new()

# Setup Game

# Called when the node enters the scene tree for the first time.
func _ready():
	#Setup Player
	player.create_player()
	player.funds_updated.connect(funds_changed)
	setup_top_display(player.organisation)
	funds_changed()
	
	#Set background and top menu
	background.map_clicked.connect(deselect_all_locations)
	top_menu.pause_game.connect(pause_game)
	add_child(background)
	add_child(top_menu)
	
	overview.position.y = 65
	add_child(overview)
	
	add_new_city(true) #True means add ALL cities
	
	collect_valid_threats()
	overview.update_overview(gather_information())
	overview.threat_researched.connect(threat_researched)
	$GameTimer.start()
	prompt_user("Welcome!",GeneralRepo.Prompts["Welcome!"])

func collect_valid_threats():
	for threat in ThreatRepo.ThreatsDB:
		if player.organisation.threat_actors.has(ThreatRepo.ThreatsDB[threat]["rating"]):
			all_threat_names.append(threat)

func deselect_all_locations():
	propagate_call("deselect")

func pull_location_to_front(node):
	print(node)
	node.z_index = RenderingServer.CANVAS_ITEM_Z_MAX

func add_new_city(all:bool = false):
	var new_city = unused_cities.pick_random()
	unused_cities.remove_at(unused_cities.find(new_city))
	cities_in_play.append(new_city)
	
	var new_location = location.instantiate()
	var info = LocationRepo.LocationDB.get(new_city)
	var this_icon = city_pics[info.picture_id]
	new_location.position = Vector2(info.location_x, info.location_y)
	new_location.mouse_hovered.connect(deselect_all_locations)
	new_location.pull_to_front.connect(pull_location_to_front)
	new_location.item_bought_signal.connect(item_bought)
	new_location.threat_feed_update.connect(update_threat_feed)
	new_location.add_to_group("location")
	add_child(new_location)
	new_location.set_context_info(info,this_icon)
	new_location.set_org_context(player.organisation)
	location_nodes.append(new_location)
	if all and unused_cities.size() > 0:
		add_new_city(all)

# User Prompts

func prompt_user(title:String, body:String):
	var new_prompt = user_prompt.instantiate()
	new_prompt.set_title(title)
	new_prompt.set_body(body)
	new_prompt.prompt_closed.connect(prompt_closed)
	pause_game()
	add_child(new_prompt)

func prompt_closed():
	pause_game()

func gather_information() -> Dictionary:
	var information:Dictionary = {}
	information["Reputation"] = \
	location_nodes.map(func(node): return node.control_strengths["Reputation"]) \
				.reduce(func(accum,val): return accum + val, 0)
	information["Locations"] = location_nodes.size()
	information["Breaches"] = \
	location_nodes.map(func(node): return node.breach_count) \
				.reduce(func(accum,val): return accum + val, 0)
	information["Defended"] = \
	all_threat_objects.map(func(node): return node.defended_attack) \
				.reduce(func(accum,val): return accum + val, 0)
	information["Severity"] = average_threat_severity()
	return information

# I reckon this could be better
func average_threat_severity():
	if all_threat_objects.all(func(node): return node.display_name == "Unknown"):
		return "Unknown"
	var threat_severity_array = all_threat_objects.map(func(node): return node.rating)
	var rating; var count = 0
	for unique_element in ThreatRepo.Threat_Rating:
		if threat_severity_array.count(unique_element) >= count:
			count = threat_severity_array.count(unique_element)
			rating = unique_element
	return rating

# Manage time
@export var next_threat_wait_time:Array[float]
@onready var total_days = 1
var next_threat = 1
var paused = false

@onready var year = 2024
@onready var month = 1
@onready var week = 7
@onready var day = 1
@onready var days_this_month = 31

func _on_game_timer_timeout():
	calculate_date()
	var time_as_string = str(day) + "/" + str(month) + "/" + str(year)
	top_menu.update_time(time_as_string)
	is_next_threat()
	total_days += 1

func calculate_date():
	day += 1
	time_checks("day")
	week -= 1
	if week == 0:
		time_checks("week")
		week = 7
	if day == days_this_month:
		day = 1
		month += 1
		if month == 2:
			if year % 4 == 0:
				days_this_month = 29
			else:
				days_this_month = 28
		elif month == 4 or month == 6 or month == 9 or month == 11:
			days_this_month = 30
		else:
			days_this_month = 31
		time_checks("month")
	if month == 13:
		year += 1
		month = 1
		time_checks("year")

func is_next_threat():
	if total_days == next_threat:
		next_threat = total_days + int(randf_range(next_threat_wait_time[0],next_threat_wait_time[1]))
		get_new_threat()

func time_checks(time):
	for node in location_nodes:
		node.time_checks(time)
	match time:
		"day":
			daily_checks()
		"week":
			pass
		"month":
			monthly_checks()
		"year":
			pass

func daily_checks():
	for threat in all_threat_objects:
		if threat.is_active:
			threat.active_actions()
	overview.update_overview(gather_information())

func weekly_checks():
	var reputation_total = 0
	for location in location_nodes:
		reputation_total += location.control_strengths["Reputation"]
	player.update_reputation(floor(reputation_total / location_nodes.size()))

func yearly_checks():
	pass

func monthly_checks():
	player.monthly_checks()

func pause_game():
	paused = not paused
	for timer_node in get_tree().get_nodes_in_group("timer"):
		timer_node.set_paused(paused)

# Manage Threats

@onready var all_threat_objects:Array[ThreatActor] = []
var all_threat_names:Array
var dormant_threats = 0
var active_threats = 0

func get_new_threat():
	if all_threat_names.size() == 0:
		return
	var new_threat = all_threat_names.pick_random()
	all_threat_names.remove_at(all_threat_names.find(new_threat))
	
	var new_threat_object: ThreatActor = ThreatActor.new()
	add_child(new_threat_object)
	#Threat updated signal runs whenever something about the threat has changed
	#Threat_checks method handles updating the UI for the user to see the change
	new_threat_object.threat_updated.connect(threat_checks)
	new_threat_object.successful_attack.connect(determine_attacked_locations)
	new_threat_object.set_info(ThreatRepo.ThreatsDB[new_threat])
	new_threat_object.initiate_threat()
	
	all_threat_objects.append(new_threat_object)
	
	overview.add_threat_intel_item(new_threat_object)
	
	threat_checks()
	update_threat_feed("Threat detected: " + new_threat_object.display_name)

func update_threat_counters():
	dormant_threats = 0; active_threats = 0;
	for threat in all_threat_objects:
		if threat.is_active:
			active_threats += 1
			#update_threat_feed(threat.name + " is ACTIVE.")
		else:
			dormant_threats += 1
	top_menu.update_dormant(dormant_threats)
	top_menu.update_active(active_threats)

func determine_attacked_locations(threat):
	for node in location_nodes:
		if node.control_strengths["Reputation"] >= threat.attack_details["reputation_req"]:
			if node.calculate_attack(threat.attack_details) == true:
				threat.dormant_on_success()
				overview.successful_attack_update(threat.name)

func update_threat_feed(message:String):
	overview.threat_feed_message(message)

func threat_checks():
	update_threat_counters()

func threat_researched(threat_item:String):
	all_threat_objects.filter(func(node): return node.name == threat_item)[0].reveal_name()

# Manage organisation

func setup_top_display(organisation: Dictionary):
	top_menu.set_org(organisation.name, organisation.funds)
	overview.update_overview({"Organisation" : organisation.name })

func item_bought(item):
	player.item_bought(item.cost)

func funds_changed():
	for node in get_children():
		if node.is_in_group("location"):
			node.propagate_call("have_cost",[player.current_funds])
	top_menu.update_funds(player.current_funds)
