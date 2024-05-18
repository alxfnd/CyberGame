class_name CyberRepo
extends Node

const Item_Categories = ["PHYSICAL","WEB","NETWORK","ASSET","IDENTITY"]

const ItemDB = {
	"PHYSICAL" = {
		"0" = {
			id = 0,
			name = "Perimeter Fences",
			cost = 1000,
			strength = 5
		},
		"18" = {
			id = 0,
			name = "Signage",
			cost = 1000,
			strength = 5
		},
		"11" = {
			id = 0,
			name = "Security Lightin",
			cost = 1000,
			strength = 5
		},
		"1" = {
			id = 1,
			name = "Reinforced Doors",
			cost = 2500,
			strength = 5
		},
		"2" = {
			id = 2,
			name = "Reception",
			cost = 100000,
			strength = 5
		},
		"17" = {
			id = 0,
			name = "CCTV Monitoring",
			cost = 1000,
			strength = 5
		},
		"3" = {
			id = 3,
			name = "Security Officers",
			cost = 50000,
			strength = 5
		},
		"16" = {
			id = 0,
			name = "Visitor Management",
			cost = 1000,
			strength = 5
		},
		"14" = {
			id = 0,
			name = "Security Alarms",
			cost = 1000,
			strength = 5
		},
		"4" = {
			id = 4,
			name = "Identity Access Cards",
			cost = 80000,
			strength = 5
		},
		"5" = {
			id = 5,
			name = "Employee Awareness",
			cost = 50000,
			strength = 5
		},
		"6" = {
			id = 6,
			name = "Secure Bolted Doors",
			cost = 60000,
			strength = 5
		},
		"7" = {
			id = 7,
			name = "Biometric Entry",
			cost = 125000,
			strength = 5
		},
		"15" = {
			id = 0,
			name = "Tamper-Evident Seals",
			cost = 1000,
			strength = 5
		},
		"12" = {
			id = 0,
			name = "Mantraps",
			cost = 1000,
			strength = 5
		},
		"13" = {
			id = 0,
			name = "Vehicle Barriers",
			cost = 1000,
			strength = 5
		},
		"8" = {
			id = 8,
			name = "Disaster Recovery Plan",
			cost = 250000,
			strength = 5
		},
		"9" = {
			id = 9,
			name = "Cold Site",
			cost = 250000,
			strength = 5
		},
		"19" = {
			id = 0,
			name = "Safe Room",
			cost = 1000,
			strength = 5
		},
		"10" = {
			id = 10,
			name = "Hot Site",
			cost = 600000,
			strength = 5
		}
	},
	"WEB" = {
		"100" = {
			id = 100,
			name = "Code Review",
			cost = 5000,
			strength = 5
		},
		"101" = {
			id = 101,
			name = "Static/Dynamic Testing",
			cost = 15000,
			strength = 5
		},
		"102" = {
			id = 102,
			name = "Web Vulnerability Scanning",
			cost = 25000,
			strength = 5
		},
		"103" = {
			id = 103,
			name = "Penetration Testing",
			cost = 10000,
			strength = 5
		},
		"104" = {
			id = 104,
			name = "DevSecOps",
			cost = 50000,
			strength = 5
		},
		"105" = {
			id = 105,
			name = "Bug Bounty Scheme",
			cost = 10000,
			strength = 5
		},
		"106" = {
			id = 106,
			name = "Honeypot Site",
			cost = 5000,
			strength = 5
		}
	},
	"NETWORK" = {
		"201" = {
			id = 201,
			name = "Firewalls",
			cost = 12000,
			strength = 5
		},
		"202" = {
			id = 202,
			name = "IDS",
			cost = 60000,
			strength = 5
		},
		"203" = {
			id = 203,
			name = "IPS",
			cost = 225000,
			strength = 5
		},
		"204" = {
			id = 204,
			name = "Web Proxy",
			cost = 150000,
			strength = 5
		},
		"205" = {
			id = 205,
			name = "MFA Sign-in",
			cost = 175000,
			strength = 5
		},
		"206" = {
			id = 206,
			name = "Phish Campaign",
			cost = 85000,
			strength = 5
		},
		"207" = {
			id = 207,
			name = "Employee Training",
			cost = 200000,
			strength = 5
		},
		"208" = {
			id = 208,
			name = "SOC",
			cost = 1000000,
			strength = 5
		}
	},
	"ASSET" = {
		"301" = {
			id = 301,
			name = "Antimalware",
			cost = 5000,
			strength = 5
		},
		"302" = {
			id = 302,
			name = "Device Management",
			cost = 75000,
			strength = 5
		},
		"303" = {
			id = 303,
			name = "Media Control",
			cost = 15000,
			strength = 5
		},
		"304" = {
			id = 304,
			name = "Asset Tracking",
			cost = 75000,
			strength = 5
		},
		"305" = {
			id = 305,
			name = "Vendor Assurance",
			cost = 160000,
			strength = 5
		},
		"306" = {
			id = 306,
			name = "PKI",
			cost = 275000,
			strength = 5
		}
	},
	"IDENTITY" = {
		"401" = {
			id = 401,
			name = "MFA Sign-in",
			cost = 4000,
			strength = 5
		},
		"402" = {
			id = 402,
			name = "Secure Onboarding",
			cost = 30000,
			strength = 5
		},
		"403" = {
			id = 403,
			name = "Password Manager",
			cost = 50000,
			strength = 5
		},
		"404" = {
			id = 404,
			name = "Permissions Auditing",
			cost = 22500,
			strength = 5
		},
		"405" = {
			id = 405,
			name = "Identity Automation",
			cost = 250000,
			strength = 5
		},
		"406" = {
			id = 406,
			name = "Conditional Access",
			cost = 35000,
			strength = 5
		}
	}
}

const LocationStatTemplate = {
	"Location" = "",
	"Confidentiality" = 0,
	"Integrity" = 0,
	"Availability" = 0,
	"Reputation" = 0,
	"Physical" = 0,
	"Web" = 0,
	"Network" = 0,
	"Asset" = 0,
	"Identity" = 0
}
