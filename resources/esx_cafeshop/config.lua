Config                            = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 21
Config.MarkerTypeboss             = 22
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }


Config.CoffeeShops = {
	Parking = {

		Blips = {
			{
				Pos     = { x = 1224.61, y = 2727.98, z = 38.0 },
				Sprite  = 93,
				Display = 4,
				Scale   = 1.0,
				Name    = "CoffeShop",
				Colour  = 67,
			},

			{
				Pos     = { x = -556.64, y = 285.69, z = 82.18 },
				Sprite  = 590,
				Display = 4,
				Scale   = 1.1,
				Name    = "TEOUI - LA - LA",
				Colour  = 47,
			}
			
		},

		Cloakrooms = {
			{ x = 1246.29, y = 2722.93, z = 38.0 },
		},

		Refrigerators = {
			{ x = 1251.64, y = 2713.01, z = 38.0 },
		},

		Bars = {
			{ x = 128.17, y = -1280.27, z = 29.27 },
		},

		BossActions = {
			{ x = 1245.31, y = 2719.61, z = 38.0 }
		},

	}
}

Config.AuthorizedFoods = {
	{ name = 'coffee', label = "Ghave", price = 250 },
	{ name = 'tea', label = "Chaee", price = 150 },
	{ name = 'donut', label = "Donut", price = 250 },
	{ name = 'whiskey', label = "Whiskey", price = 500 },
	{ name = 'soda', label = "Noshabe", price = 200 },
	{ name = 'wine', label = "Sharab", price = 500 },
	{ name = 'beer', label = "Abjoo", price = 400 },
	{ name = 'sandwich', label = "Sandwich", price = 300 },
	{ name = 'cigar', label = "Cigar", price = 100 }
}

Config.AuthorizedDrinks= {
	{ name = 'whiskey', label = "Whiskey", price = 500 },
	{ name = 'wine', label = "Sharab", price = 500 },
	{ name = 'beer', label = "Abjoo", price = 400 },
	{ name = 'cigar', label = "Cigar", price = 100 }
}

Config.Uniforms = {
	nezafat_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 282,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 25,      ["arms_2"] = 1,
			['pants_1'] = 42,   ['pants_2'] = 2,
			['shoes_1'] = 12,   ['shoes_2'] = 0,
			['helmet_1'] = 37,  ['helmet_2'] = 5,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0
		}
	},
	garson_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 281,   ['torso_2'] = 22,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 30,
			['pants_1'] = 27,   ['pants_2'] = 4,
			['shoes_1'] = 8,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 145,   ['mask_2'] = 0
		}
	},
	ashpaz_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 3,
			['torso_1'] = 282,   ['torso_2'] = 9,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 91,     ['arms_2'] = 1,
 			['pants_1'] = 42,   ['pants_2'] = 4,
			['shoes_1'] = 8,   ['shoes_2'] = 11,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 143,   ['mask_2'] = 0
		}
	},
	sandoghdar_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 281,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 38,
			['pants_1'] = 27,   ['pants_2'] = 3,
			['shoes_1'] = 32,   ['shoes_2'] = 5,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 144,   ['mask_2'] = 0
		}
	},
	boss_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 282,   ['torso_2'] = 14,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 81,
			['pants_1'] = 15,   ['pants_2'] = 2,
			['shoes_1'] = 77,   ['shoes_2'] = 5,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 145,   ['mask_2'] = 0
		}
	},
}