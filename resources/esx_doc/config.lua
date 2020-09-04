Config                            = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 21
Config.MarkerTypeveh              = 36
Config.MarkerTypevehdel           = 24
Config.MarkerTypeboss             = 22
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = true -- enable if you're using esx_license
Config.EnableJobLogs              = true -- only turn this on if you are using esx_joblogs

Config.EnableHandcuffTimer        = false -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.EnableJobBlip              = true -- enable blips for colleagues, requires esx_society

Config.MaxInService               = -1
Config.Locale                     = 'en'

Config.DocStations = {

	Boling = {

		Blip = {
			Pos     = { x = 1861.98, y = 2607.38, z = 45.67 },
			Sprite  = 188,
			Display = 4,
			Scale   = 1.2,
			Colour  = 81,
		},

		-- https://wiki.rage.mp/index.php?title=Weapons
		AuthorizedWeapons = {
			{ name = 'WEAPON_NIGHTSTICK', price = 100 },
			{ name = 'WEAPON_STUNGUN', price = 500 },
			{ name = 'WEAPON_FLASHLIGHT', price = 100 },
			{ name = 'WEAPON_HEAVYPISTOL', price = 8000 },
			{ name = 'WEAPON_CARBINERIFLE', price = 12000 },
			{ name = 'WEAPON_HEAVYSNIPER', price = 20000 },
		},

		Cloakrooms = {
			{ x = 1698.75, y = 2594.98, z = -49.71 },
		},

		Armories = {
			{ x = 1693.62, y = 2595.05, z = -49.71 },
		},

		Vehicles = {
			{
				Spawner    = { x = 1840.79, y = 2545.46, z = 45.67 },
				SpawnPoint = { x = 1854.91, y = 2553.03, z = 45.67 },
				Heading    = 271.75
			},
		},

		VehicleDeleters = {
			{ x = 1832.57, y = 2542.06, z = 45.88 },
		},

		BossActions = {
			{ x = 1786.41, y = 2621.36, z = -45.72 }
		},

	}

}

Config.AuthorizedWeapons = {
	Shared = {
		{ name = 'WEAPON_NIGHTSTICK' },
		{ name = 'WEAPON_STUNGUN' },
		{ name = 'WEAPON_FLASHLIGHT' },
		{ name = 'WEAPON_HEAVYPISTOL'}
	},
	
	trainee = {

	},

	cofficer = {
		{ name = 'WEAPON_CARBINERIFLE'}
	},

	cofficer2 = {
		{ name = 'WEAPON_CARBINERIFLE'}
	},

	cofficer3 = {
		{ name = 'WEAPON_CARBINERIFLE'}
	},

	guardian = {
		{ name = 'WEAPON_CARBINERIFLE'},
		{ name = 'WEAPON_HEAVYSNIPER'}
	},

	mguardian = {
		{ name = 'WEAPON_CARBINERIFLE'},
		{ name = 'WEAPON_HEAVYSNIPER'}
	},

	lieutenant = {
		{ name = 'WEAPON_CARBINERIFLE'},
		{ name = 'WEAPON_HEAVYSNIPER'}
	},

	boss = {
		{ name = 'WEAPON_CARBINERIFLE'},
		{ name = 'WEAPON_HEAVYSNIPER'}
	},
	
}

-- https://wiki.rage.mp/index.php?title=Vehicles
Config.AuthorizedVehicles = {
	Shared = {			
	  { model = 'dilettante2', label = 'Patrol Vehicle'},
	  { model = 'policet', label = 'Transport Van'},
	},

	trainee = {
		
	},

	cofficer = {
	  { model = 'sheriff', label = 'DOC Cruiser'},
	},

	cofficer2 = {
	  { model = 'sheriff', label = 'DOC Cruiser'},
	},

	cofficer3 = {
		{ model = 'sheriff2', label = 'DOC Suv'},
	},

	guardian = {
	  { model = 'sheriff', label = 'DOC Cruiser'},
	  { model = 'sheriff2', label = 'DOC Suv'},
	  { model = 'riot', label = 'DOC Riot'},
	},

	mguardian = {
	  { model = 'sheriff', label = 'DOC Cruiser'},
	  { model = 'sheriff2', label = 'DOC Suv'},
	  { model = 'riot', label = 'DOC Riot'},
	},

	lieutenant = {
	  { model = 'sheriff', label = 'DOC Cruiser'},
	  { model = 'sheriff2', label = 'DOC Suv'},
	  { model = 'riot', label = 'DOC Riot'},
	},

	boss = {
	  { model = 'sheriff', label = 'DOC Cruiser'},
	  { model = 'sheriff2', label = 'DOC Suv'},
	  { model = 'riot', label = 'DOC Riot'},
	},
	
}


-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
	trainee_wear = {
		male = {
			['tshirt_1'] = 53,  ['tshirt_2'] = 1,
			['torso_1'] = 190,   ['torso_2'] = 9,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 10,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 6,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 192,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0
		}
	},

	cofficer_wear = {
		male = {
			['tshirt_1'] = 53,  ['tshirt_2'] = 1,
			['torso_1'] = 190,   ['torso_2'] = 9,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 10,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 6,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 192,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0
		}
	},

	cofficer2_wear = {
		male = {
			['tshirt_1'] = 53,  ['tshirt_2'] = 1,
			['torso_1'] = 190,   ['torso_2'] = 9,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 10,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 6,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 192,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0
		}
	},

	cofficer3_wear = {
		male = {
			['tshirt_1'] = 53,  ['tshirt_2'] = 1,
			['torso_1'] = 190,   ['torso_2'] = 9,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 10,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 6,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 192,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0
		}
	},

	guardian_wear = {
		male = {
			['tshirt_1'] = 53,  ['tshirt_2'] = 1,
			['torso_1'] = 190,   ['torso_2'] = 9,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 10,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 6,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 192,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0
		}
	},

	mguardian_wear = { -- currently the same as intendent_wear
		male = {
			['tshirt_1'] = 53,  ['tshirt_2'] = 1,
			['torso_1'] = 190,   ['torso_2'] = 9,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 10,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 6,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 192,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0
		}
	},

	lieutenant_wear = {
		male = {
			['tshirt_1'] = 53,  ['tshirt_2'] = 1,
			['torso_1'] = 190,   ['torso_2'] = 9,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 10,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 6,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 192,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0
		}
	},

	boss_wear = { -- currently the same as chef_wear
		male = {
			['tshirt_1'] = 53,  ['tshirt_2'] = 1,
			['torso_1'] = 190,   ['torso_2'] = 9,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 10,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 6,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 192,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0
		}
	},

	vest = {
		male = {
			['bproof_1'] = 11,  ['bproof_2'] = 0
		},
		female = {
			['bproof_1'] = 10,  ['bproof_2'] = 0
		}
	},

}