class_name ThreatRepo
extends Node

enum Control_Types { PHYSICAL, WEB, NETWORK, ASSET, IDENTITY }
enum Org_Services { CONFIDENTIALITY, INTEGRITY, AVAILABILITY, REPUTATION }
enum Threat_Rating { LOW, MEDIUM, HIGH, CRITICAL }

const ThreatsDB = {
	"Vandals" = {
		name = "Vandals",
		attack_type = "PHYSICAL",
		strength = 30, # Total strength = this - controls %
		reputation_req = 10, # Min rep required to start attacked
		occurrence_per_month = 1, #Unused
		target_type = {"AVAILABILITY" : 5}, # Service targeted and the cooldown period in days
		active_range = [3.0,5.0], #Range of days spent trying to hack
		dormant_range = [5.0,10.0], #After attempts to succeed, goes dormant
		success_chance = 10, # Random modifier to determine final success # UNUSED
		attack_length = 1, # Days attack lasts
		rating = Threat_Rating.LOW,
		research_time = 10 # seconds
	},
	"Cozy Bear" = {
		name = "APT-29 (Cozy Bear)",
		attack_type = "WEB",
		strength = 110,
		reputation_req = 80,
		occurrence_per_month = 2,
		target_type = {"CONFIDENTIALITY" : 8, "INTEGRITY" : 8},
		active_range = [3.0, 6.0], 
		dormant_range = [20.0, 30.0], 
		success_chance = 70,
		attack_length = 10,
		rating = Threat_Rating.CRITICAL,
		research_time = 10
	},
	"Fancy Bear" = {
		name = "APT-28 (Fancy Bear)",
		attack_type = "NETWORK",
		strength = 100,
		reputation_req = 60,
		occurrence_per_month = 3,
		target_type = {"AVAILABILITY": 9, "INTEGRITY" : 8},
		active_range = [1.5, 3.5],
		dormant_range = [5.0, 9.0],
		success_chance = 80,
		attack_length = 6,
		rating = Threat_Rating.CRITICAL,
		research_time = 10
	},
	"Charming Kitten" = {
		name = "APT-35 (Charming Kitten)",
		attack_type = "WEB",
		strength = 90,
		reputation_req = 40,
		occurrence_per_month = 1,
		target_type = {"CONFIDENTIALITY": 7, "INTEGRITY" : 8},
		active_range = [2.3, 4.3],
		dormant_range = [5.5, 9.5],
		success_chance = 60,
		attack_length = 5,
		rating = Threat_Rating.CRITICAL,
		research_time = 10
	},
	"Lazarus Group" = {
		name = "Lazarus Group",
		attack_type = "ASSET",
		strength = 85,
		reputation_req = 55,
		occurrence_per_month = 2,
		target_type = {"AVAILABILITY": 8},
		active_range = [1.8, 3.8],
		dormant_range = [5.5, 10.5],
		success_chance = 75,
		attack_length = 3,
		rating = Threat_Rating.HIGH,
		research_time = 10
	},
	"Sandworm Team" = {
		name = "Sandworm Team",
		attack_type = "NETWORK",
		strength = 88,
		reputation_req = 58,
		occurrence_per_month = 2,
		target_type = {"AVAILABILITY": 9},
		active_range = [2.2, 4.2],
		dormant_range = [5.8, 11.0],
		success_chance = 70,
		attack_length = 4,
		rating = Threat_Rating.HIGH,
		research_time = 10
	},
	"DarkHotel" = {
		name = "DarkHotel",
		attack_type = "WEB",
		strength = 75,
		reputation_req = 45,
		occurrence_per_month = 1,
		target_type = {"CONFIDENTIALITY": 7},
		active_range = [2.3, 4.3],
		dormant_range = [5.5, 9.5],
		success_chance = 65,
		attack_length = 3,
		rating = Threat_Rating.MEDIUM,
		research_time = 50
	},
	"Cloud Hopper" = {
		name = "APT-10 (Cloud Hopper)",
		attack_type = "WEB",
		strength = 80,
		reputation_req = 50,
		occurrence_per_month = 2,
		target_type = {"CONFIDENTIALITY": 8},
		active_range = [2.0, 4.0],
		dormant_range = [6.0, 12.0],
		success_chance = 70,
		attack_length = 3,
		rating = Threat_Rating.HIGH,
		research_time = 50
	}

}
