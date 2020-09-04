Config = {
    --// Fetch Data
    --[[
        
    U can specify the hash of the cashier like this:
        ["cashier"] = {
            ["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0, ["h"] = 0.0,     (h = heading)
            ["hash"] = "mp_m_freemode_01"
        },
        or ["hash"] = 1885233650
    ]]--
    
    Locales = {
        ["checkout"] = "Sandogh",
        ["drinks"] = "Noshidani",
        ["snacks"] = "Tanagholat",
        ["readymeal"] = "Ghaza",
        ["diverse"] = "Vasayel Motefareghe",
    },

    buy = {
        pos = {x = 46.16, y = -1749.16, z = 28.64}
    },

    Items = {
        ["drinks"] = {
            -- {label = "Coca Cola", item = "cocacola", price = 50},
            {label = "Fanta", item = "fanta", price = 1000},
            {label = "Sprite", item = "sprite", price = 200},
            {label = "Ab", item = "water", price = 100},
        },
        ["snacks"] = {
            {label = "Snack", item = "cheesebows", price = 200},
            {label = "Chips", item = "chips", price = 160},
            {label = "Shokolat", item = "marabou", price = 120},
        },
        ["readymeal"] = {
            {label = "Pitza", item = "pizza", price = 400},
            {label = "Burger", item = "burger", price = 300},
            {label = "Noon", item = "bread", price = 120},
            -- {label = "Sandwitch", item = "macka", price = 42},
        },
        ["diverse"] = {
            {label = "Radio", item = "radio", price = 2000},
            {label = "Phone", item = "phone", price = 2200},
            {label = "GPS", item = "gps", price = 1000},
            {label = "PickLock", item = "picklock", price = 1000},
            --{label = "Cigar", item = "cigarett", price = 10},
            {label = "Fandak", item = "lighter", price = 80},
            {label = "Blit Bakht Azmayi", item = "lotteryticket", price = 400},
            {label = "Choob Mahigiri", item = "fishingrod", price = 4000},
        },
    },
}