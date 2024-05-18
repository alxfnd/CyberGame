extends Control

@onready var loc_image = %LocationImage
@onready var cstatus = %CStatus
@onready var istatus = %IStatus
@onready var astatus = %AStatus
@onready var rstatus = %RStatus
@onready var threatstatus = %ThreatStatus
@onready var threatlabel = %ThreatLabel
var compromised:bool = false

func set_context_info(this_info:Dictionary, this_image:Texture2D):
	loc_image.set_texture(this_image)
	%Descriptions/LocationName.set_text("Location: " + this_info.name)
	%Descriptions/CityName.set_text("City: " + this_info.city)
	pass

func update_control_strength(type, value:int):
	match type:
		"PHYSICAL":
			%ControlStrengths/Physical/PValue.text = (str(value) + "%")
		"WEB":
			%ControlStrengths/Web/WValue.text = (str(value) + "%")
		"NETWORK":
			%ControlStrengths/Network/NValue.text = (str(value) + "%")
		"ASSET":
			%ControlStrengths/Asset/AValue.text = (str(value) + "%")
		"IDENTITY":
			%ControlStrengths/Identity/IValue.text = (str(value) + "%")
	pass

func update_reputation(value:int):
	%ControlStrengths/Reputation/RValue.text = str(value)

func update_service_states(service_states):
	compromised = !service_states.values().all(func(val): return val == 1)
	is_compromised()
	#This could be improved by better naming the nodes, and then matching
	#the key to the node
	for state in service_states.keys():
		match state:
			"CONFIDENTIALITY":
				cstatus.set_color(get_colour(service_states["CONFIDENTIALITY"]))
			"INTEGRITY":
				istatus.set_color(get_colour(service_states["INTEGRITY"]))
			"AVAILABILITY":
				astatus.set_color(get_colour(service_states["AVAILABILITY"]))
			"REPUTATION":
				rstatus.set_color(get_colour(service_states["REPUTATION"]))

func is_compromised():
	if compromised:
		threatlabel.text = "Threat Status: Compromised"
		threatstatus.set_color(get_colour(0))
		return
	threatlabel.text = "Health Status: Healthy"
	threatstatus.set_color(get_colour(1))

func get_colour(value:int):
	if value == 0:
		return GeneralRepo.ColourRepo.Compromised.default
	return GeneralRepo.ColourRepo.Healthy.default
