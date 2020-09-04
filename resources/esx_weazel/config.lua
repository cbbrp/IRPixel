Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerColor                = { r = 102, g = 0, b = 102 }
Config.EnablePlayerManagement     = true
Config.MaxInService               = -1
Config.Locale                     = 'en'

Config.AuthorizedVehicles = {
	{ name = 'rumpo',  label = 'Weazel Van Black', colors = {a = 0, b = 0} },
	{ name = 'rumpo',  label = 'Weazel Van White', colors = {a = 111, b = 111} },
}

Config.Blips = {

	Blip = {	
		Pos     = { x = -1087.048, y = -249.330, z = 36.947},
		Sprite  = 184,
		Display = 4,
		Scale   = 1.2,
		Colour  = 49,
	}
}

Config.Zones = {

    BossActions = {
        Pos   = { x = -1053.683, y = -230.554, z = 44.020 },
        Size  = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 0, g = 100, b = 0 },
        Type  = 22,
    },
	
	Cloakrooms = {
		Pos = { x = -1068.600, y = -241.440, z = 39.73},
		Size = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 0, g = 255, b = 128 },
		Type = 21,
	},

    Vehicles = {
        Pos          = { x = -1100.58, y = -250.86, z = 38.13 },
        SpawnPoint   = { x = -1099.061, y = -265.882, z = 37.692},
        Size         = { x = 1.5, y = 1.5, z = 1.0 },
        Color        = { r = 0, g = 255, b = 128 },
        Type         = 36,
        Heading      = 207.43,
	},	
	
	Helicopters = {
        Pos          = { x = -1054.3, y = -242.15, z = 53.51 },
        SpawnPoint   = { x = -1050.3, y = -235.2, z = 53.51},
        Size         = { x = 1.5, y = 1.5, z = 1.0 },
        Color        = { r = 0, g = 255, b = 128 },
        Type         = 7,
        Heading      = 20.71,
    },	

	VehicleDeleters = {
		Pos  = { x = -1098.44, y = -256.25, z = 37.69},
		Size = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 0, g = 255, b = 128 },		
		Type = 24
	},

	VehicleDeleters2 = {
		Pos  = { x = -1050.7, y = -235.22, z = 53.51},
		Size = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 0, g = 255, b = 128 },		
		Type = 24
	},

}

Config.Uniforms = {
	secutiry_outfit = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 111,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 4,
			['pants_1'] = 13,   ['pants_2'] = 0,
			['shoes_1'] = 57,   ['shoes_2'] = 10,
			['chain_1'] = 0,  ['chain_2'] = 0
		},
		female = {
			['tshirt_1'] = 14,   ['tshirt_2'] = 0,
			['torso_1'] = 27,    ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 0,   ['pants_2'] = 8,
			['shoes_1'] = 3,    ['shoes_2'] = 2,
			['chain_1'] = 2,    ['chain_2'] = 1
		}
	},
	
  	reporter_outfit = {
		male = {
			['tshirt_1'] = 6,  ['tshirt_2'] = 1,
			['torso_1'] = 25,   ['torso_2'] = 3,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 11,
			['pants_1'] = 13,   ['pants_2'] = 0,
			['shoes_1'] = 51,   ['shoes_2'] = 1,
			['chain_1'] = 24,  ['chain_2'] = 5
		},
		female = {
			['glasses_1'] = 5,	['glasses_2'] = 0,
			['tshirt_1'] = 24,   ['tshirt_2'] = 0,
			['torso_1'] = 28,   ['torso_2'] = 4,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['chain_1'] = 0,   ['chain_2'] = 0
		}	
	},

	investigator_outfit = {
		male = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 31,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 4,
			['pants_1'] = 10,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['chain_1'] = 27,  ['chain_2'] = 5
		},
		female = {
			['glasses_1'] = 5,	['glasses_2'] = 0,
			['tshirt_1'] = 20,   ['tshirt_2'] = 2,
			['torso_1'] = 24,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 5,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['chain_1'] = 0,   ['chain_2'] = 0
		}	
	},

	administrator_outfit = {
		male = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 77,   ['torso_2'] = 1,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 11,
			['pants_1'] = 13,   ['pants_2'] = 0,
			['shoes_1'] = 51,   ['shoes_2'] = 1,
			['chain_1'] = 27,  ['chain_2'] = 5
		},
		female = {
			['glasses_1'] = 5,	['glasses_2'] = 0,
			['tshirt_1'] = 40,   ['tshirt_2'] = 7,
			['torso_1'] = 64,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['chain_1'] = 0,   ['chain_2'] = 0
		}	
	},

	boss_outfit = {
		male = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 77,   ['torso_2'] = 1,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 11,
			['pants_1'] = 13,   ['pants_2'] = 0,
			['shoes_1'] = 51,   ['shoes_2'] = 1,
			['chain_1'] = 27,  ['chain_2'] = 5
		},
		female = {
			['glasses_1'] = 5,	['glasses_2'] = 0,
			['tshirt_1'] = 40,   ['tshirt_2'] = 7,
			['torso_1'] = 64,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['chain_1'] = 0,   ['chain_2'] = 0
		}	
	}
  
}