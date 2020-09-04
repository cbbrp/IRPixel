Config                            = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 21
Config.MarkerTypeboss             = 22
Config.MarkerTypeveh              = 36
Config.MarkerTypevehdel           = 24
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true

Config.Government = {
	CityHall = {

		Blip = {
			Pos     = { x = 2484.87 , y = -386.44 , z = 110.12 },
			Sprite  = 419,
			Display = 4,
			Scale   = 1.6
		},

		Cloakrooms = {
			{ x = 2128.76, y = 2925.44, z = -61.9},
		},

		Armory = {
			{ x = 2142.2, y = 2923.64, z = -61.9 },
		},	

		BossActions = {
			{ x = 2017.12, y = 3021.11, z = -72.71 }
		},

		Vehicles = {
			{
				Spawner    = { x = 2567.53, y = -333.45, z = 93.12 },
				SpawnPoint = { x = 2573.38, y = -340.08, z = 92.99 },
				Heading    = 113.45
			}
		},

		VehicleDeleters = {
			{ x = 2575.74, y = -362.3 , z = 92.99 }
		},

	}
}

Config.AuthorizedVehicles = {
	Shared = {			
		{ model = 'schafter6', label = 'Schafter Armored' },
		{ model = 'fibx', label = 'XLS Armored' },
		{ model = 'fibj', label = 'Jaguar' },
		{ model = 'fibn3', label = 'N3' },
		{ model = 's65amg', label = 'S65AMG' },
		{ model = 'c63', label = 'C63' },

	},

	agent = {

	},

	sagent = {

	},

	supervisor = {

	},

	speaker = {

	},

	ddirector = {

	},

	director = {

	},
	
	boss = {

	},
	
}

Config.AuthorizedWeapons = {
	{ name = 'WEAPON_STUNGUN'},
	{ name = 'WEAPON_FLASHLIGHT'},
	{ name = 'WEAPON_PISTOL'},
	{ name = 'WEAPON_COMBATPISTOL'},
	{ name = 'WEAPON_HEAVYPISTOL'},
	{ name = 'WEAPON_MICROSMG'},
	{ name = 'WEAPON_SMG'},
	{ name = 'WEAPON_CARBINERIFLE'},
	{ name = 'WEAPON_ADVANCEDRIFLE'},
	
	director = {
	{ name = 'WEAPON_HEAVYSNIPER'},
	},
	
	boss = {
	{ name = 'WEAPON_HEAVYSNIPER'},
	},
}

Config.Uniforms = {
	agent_wear = {
		male = {
			['tshirt_1'] = 13,  ['tshirt_2'] = 0,
			['torso_1'] = 4,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 38,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 15,   ['shoes_2'] = 0,
			['helmet_1'] = -1,   ['helmet_2'] = 0,
			['chain_1'] = 38,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['glasses_1'] = 5,  ['glasses_2'] = 0,
			['mask_1'] = 121,   ['mask_2'] = 0
		}
	},
	sagent_wear = {
		male = {
			['tshirt_1'] = 13,  ['tshirt_2'] = 0,
			['torso_1'] = 4,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 38,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 15,   ['shoes_2'] = 0,
			['helmet_1'] = -1,   ['helmet_2'] = 0,
			['chain_1'] = 38,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['glasses_1'] = 5,  ['glasses_2'] = 0,
			['mask_1'] = 121,   ['mask_2'] = 0
		}
	},
	supervisor_wear = {
		male = {
			['tshirt_1'] = 13,  ['tshirt_2'] = 0,
			['torso_1'] = 4,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 38,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 15,   ['shoes_2'] = 0,
			['helmet_1'] = -1,   ['helmet_2'] = 0,
			['chain_1'] = 38,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['glasses_1'] = 5,  ['glasses_2'] = 0,
			['mask_1'] = 121,   ['mask_2'] = 0
		}
	},
	speaker_wear = {
		male = {
			['tshirt_1'] = 13,  ['tshirt_2'] = 0,
			['torso_1'] = 4,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 38,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 15,   ['shoes_2'] = 0,
			['helmet_1'] = -1,   ['helmet_2'] = 0,
			['chain_1'] = 38,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['glasses_1'] = 5,  ['glasses_2'] = 0,
			['mask_1'] = 121,   ['mask_2'] = 0
		}
	},
	ddirector_wear = {
		male = {
			['tshirt_1'] = 53,  ['tshirt_2'] = 1,
			['torso_1'] = 13,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 37,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 15,   ['shoes_2'] = 0,
			['helmet_1'] = 10,   ['helmet_2'] = 5,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['mask_1'] = 121,   ['mask_2'] = 0,
			['bproof_1'] = 16 , ['bproof_2'] = 2,
		}
	},
	director_wear = {
		male = {
			['tshirt_1'] = 53,  ['tshirt_2'] = 1,
			['torso_1'] = 13,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 37,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 15,   ['shoes_2'] = 0,
			['helmet_1'] = 10,   ['helmet_2'] = 5,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['mask_1'] = 121,   ['mask_2'] = 0,
			['bproof_1'] = 16 , ['bproof_2'] = 2,
		}
	},
	boss_wear = {
		male = {
			['tshirt_1'] = 53,  ['tshirt_2'] = 1,
			['torso_1'] = 13,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 37,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 15,   ['shoes_2'] = 0,
			['helmet_1'] = 10,   ['helmet_2'] = 5,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['mask_1'] = 121,   ['mask_2'] = 0,
			['bproof_1'] = 16 , ['bproof_2'] = 2,
		}
	},
}