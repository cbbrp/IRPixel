--[[ Gets the ESX library ]]--
ESX = nil 

Keys = {["E"] = 38, ["L"] = 182, ["G"] = 47}

payAmount = 0
Basket = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}

Locations = {
    [1] = {
        ["shelfs"] = {
            {["x"] = 25.73, ["y"] = -1347.27, ["z"] = 29.5, ["value"] = "checkout"},
            {["x"] = 27.50, ["y"] = -1345.25, ["z"] = 29.5, ["value"] = "drinks"},
            {["x"] = 28.99, ["y"] = -1342.62, ["z"] = 29.5, ["value"] = "snacks"},
            {["x"] = 32.45, ["y"] = -1342.96, ["z"] = 29.5, ["value"] = "readymeal"},
            {["x"] = 25.67, ["y"] = -1344.99, ["z"] = 29.5, ["value"] = "diverse"},
        },
        ["blip"] = {
            ["x"] = 29.41, ["y"] = -1345.01, ["z"] = 29.5
        },
        ["cashier"] = {
            ["x"] = 24.44, ["y"] = -1347.34, ["z"] = 28.5, ["h"] = 270.82
        },
        ["boss"] = {
            coords = {x = 30.71, y = -1340.05, z = 29.5 },
            owner = false
        }
    },

    [2] = {
        ["shelfs"] = {
            {["x"] = -48.37, ["y"] = -1757.93, ["z"] = 29.42, ["value"] = "checkout"},
            {["x"] = -54.67, ["y"] = -1748.58, ["z"] = 29.42, ["value"] = "drinks"},
            {["x"] = -52.80, ["y"] = -1753.28, ["z"] = 29.42, ["value"] = "snacks"},
            {["x"] = -50.08, ["y"] = -1749.24, ["z"] = 29.42, ["value"] = "readymeal"},
            {["x"] = -47.25, ["y"] = -1756.58, ["z"] = 29.42, ["value"] = "diverse"},
        },
        ["blip"] = {
            ["x"] = -48.34, ["y"] = -1752.72, ["z"] = 29.42
        },
        ["cashier"] = {
            ["x"] = -47.38, ["y"] = -1758.7, ["z"] = 28.44, ["h"] = 48.84
        },
        ["boss"] = {
            coords = {x = -45.02, y = -1750.53, z = 29.42 },
            owner = false
        },
    },

    [3] = {
        ["shelfs"] = {
            {["x"] = -1222.26, ["y"] = -906.86, ["z"] = 12.33, ["value"] = "checkout"},
            {["x"] = -1224.09, ["y"] = -908.13, ["z"] = 12.33, ["value"] = "diverse"},
        },
        ["blip"] = {
            ["x"] = -1220.78, ["y"] = -909.19, ["z"] = 12.33
        },
        ["cashier"] = {
            ["x"] = -1221.47, ["y"] = -907.99, ["z"] = 11.36, ["h"] = 28.09,
            ["hash"] = "s_m_m_linecook"
        },
        ["boss"] = {
            coords = {x = -1218.09, y = -915.62, z = 11.33 },
            owner = false
        },
    },

    [4] = {
        ["shelfs"] = {
            {["x"] = -1487.62, ["y"] = -378.60, ["z"] = 40.16, ["value"] = "checkout"},
            {["x"] = -1486.07, ["y"] = -380.21, ["z"] = 40.16, ["value"] = "diverse"},
        },
        ["blip"] = {
            ["x"] = -1485.59, ["y"] = -376.7, ["z"] = 40.16
        },
        ["cashier"] = {
            ["x"] = -1486.75, ["y"] = -377.51, ["z"] = 39.18, ["h"] = 130.0,
            ["hash"] = "s_m_m_linecook"
        },
        ["boss"] = {
            coords = {x = -1479.83, y = -372.92, z = 39.16 },
            owner = false
        },
    },

    [5] = {
        ["shelfs"] = {
            {["x"] = -707.31, ["y"] = -914.66, ["z"] = 19.22, ["value"] = "checkout"},
            {["x"] = -718.20, ["y"] = -911.52, ["z"] = 19.22, ["value"] = "drinks"},
            {["x"] = -713.68, ["y"] = -913.90, ["z"] = 19.22, ["value"] = "snacks"},
            {["x"] = -714.20, ["y"] = -909.15, ["z"] = 19.22, ["value"] = "readymeal"},
            {["x"] = -707.36, ["y"] = -912.83, ["z"] = 19.22, ["value"] = "diverse"},
        },
        ["blip"] = {
            ["x"] = -711.01, ["y"] = -911.25, ["z"] = 19.22
        },
        ["cashier"] = {
            ["x"] = -706.13, ["y"] = -914.52, ["z"] = 18.24, ["h"] = 90.0
        },
        ["boss"] = {
            coords = {x = -709.16, y = -906.78, z = 19.22 },
            owner = false
        },
    },

    [6] = {
        ["shelfs"] = {
            {["x"] = 1135.7, ["y"] = -982.79, ["z"] = 46.42, ["value"] = "checkout"},
            {["x"] = 1135.3, ["y"] = -980.55, ["z"] = 46.42, ["value"] = "diverse"},
        },
        ["blip"] = {
            ["x"] = 1132.94, ["y"] = -983.19, ["z"] = 46.42
        },
        ["cashier"] = {
            ["x"] = 1134.27, ["y"] = -983.16, ["z"] = 45.44, ["h"] = 280.08,
            ["hash"] = "s_m_m_linecook"
        },
        ["boss"] = {
            coords = {x = 1125.63, y = -982.67, z = 45.42 },
            owner = false
        },
    },

    [7] = {
        ["shelfs"] = {
            {["x"] = 373.55, ["y"] = 325.52, ["z"] = 103.57, ["value"] = "checkout"},
            {["x"] = 376.03, ["y"] = 327.65, ["z"] = 103.57, ["value"] = "drinks"},
            {["x"] = 378.15, ["y"] = 329.83, ["z"] = 103.57, ["value"] = "snacks"},
            {["x"] = 381.29, ["y"] = 328.64, ["z"] = 103.57, ["value"] = "readymeal"},
            {["x"] = 374.17, ["y"] = 327.92, ["z"] = 103.57, ["value"] = "diverse"},
        }, 
        ["blip"] = {
            ["x"] = 378.8, ["y"] = 329.64, ["z"] = 103.57
        },
        ["cashier"] = {
            ["x"] = 372.54, ["y"] = 326.38, ["z"] = 102.59, ["h"] = 257.27
        },
        ["boss"] = {
            coords = {x = 375.09, y = 333.86, z = 103.57 },
            owner = false
        },
    },

    [8] = {
        ["shelfs"] = {
            {["x"] = 1163.67, ["y"] = -323.92, ["z"] = 69.21, ["value"] = "checkout"},
            {["x"] = 1152.45, ["y"] = -322.75, ["z"] = 69.21, ["value"] = "drinks"},
            {["x"] = 1157.31, ["y"] = -324.37, ["z"] = 69.21, ["value"] = "snacks"},
            {["x"] = 1156.00, ["y"] = -319.68, ["z"] = 69.21, ["value"] = "readymeal"},
            {["x"] = 1163.33, ["y"] = -322.25, ["z"] = 69.21, ["value"] = "diverse"},
        },
        ["blip"] = {
            ["x"] = 1157.88, ["y"] = -319.42, ["z"] = 69.21
        },
        ["cashier"] = {
            ["x"] = 1164.85, ["y"] = -323.67, ["z"] = 68.23, ["h"] = 98.12
        },
        ["boss"] = {
            coords = {x = 1160.29, y = -316.5, z = 69.21 },
            owner = false
        },
    },

    [9] = {
        ["shelfs"] = {
            {["x"] = 2557.44, ["y"] = 382.03, ["z"] = 108.62, ["value"] = "checkout"},
            {["x"] = 2555.28, ["y"] = 383.96, ["z"] = 108.62, ["value"] = "drinks"},
            {["x"] = 2552.65, ["y"] = 385.58, ["z"] = 108.62, ["value"] = "snacks"},
            {["x"] = 2553.23, ["y"] = 389.04, ["z"] = 108.62, ["value"] = "readymeal"},
            {["x"] = 2555.08, ["y"] = 382.18, ["z"] = 108.64, ["value"] = "diverse"},
        },
        ["blip"] = {
            ["x"] = 2552.75, ["y"] = 386.28, ["z"] = 108.62
        },
        ["cashier"] = {
            ["x"] = 2557.27, ["y"] = 380.81, ["z"] = 107.64, ["h"] = 0.0
        },
        ["boss"] = {
            coords = {x = 2550.02, y = 387.13, z = 108.62 },
            owner = false
        },
    },

    [10] = {
        ["shelfs"] = {
            {["x"] = -3039.16, ["y"] = 585.71, ["z"] = 7.91, ["value"] = "checkout"},
            {["x"] = -3041.83, ["y"] = 586.86, ["z"] = 7.91, ["value"] = "drinks"},
            {["x"] = -3044.86, ["y"] = 587.45, ["z"] = 7.91, ["value"] = "snacks"},
            {["x"] = -3045.56, ["y"] = 590.78, ["z"] = 7.91, ["value"] = "readymeal"},
            {["x"] = -3041.03, ["y"] = 585.11, ["z"] = 7.91, ["value"] = "diverse"},
        },
        ["blip"] = {
            ["x"] = -3045.01, ["y"] = 588.14, ["z"] = 7.91
        },
        ["cashier"] = {
            ["x"] = -3038.96, ["y"] = 584.53, ["z"] = 6.93, ["h"] = 0.0
        },
        ["boss"] = {
            coords = {x = -3047.82, y = 588.04, z = 7.91 },
            owner = false
        },
    },

    [11] = {
        ["shelfs"] = {
            {["x"] = -3242.11, ["y"] = 1001.20, ["z"] = 12.83, ["value"] = "checkout"},
            {["x"] = -3244.07, ["y"] = 1003.14, ["z"] = 12.83, ["value"] = "drinks"},
            {["x"] = -3246.58, ["y"] = 1004.95, ["z"] = 12.83, ["value"] = "snacks"},
            {["x"] = -3245.88, ["y"] = 1008.5, ["z"] = 12.83, ["value"] = "readymeal"},
            {["x"] = -3243.89, ["y"] = 1001.32, ["z"] = 12.84, ["value"] = "diverse"},
        },
        ["blip"] = {
            ["x"] = -3246.45, ["y"] = 1005.64, ["z"] = 12.83
        },
        ["cashier"] = {
            ["x"] = -3242.24, ["y"] = 1000.0, ["z"] = 11.85, ["h"] = 353.5
        },
        ["boss"] = {
            coords = {x = -3249.05, y = 1007.05, z = 12.83 },
            owner = false
        },
    },

    [12] = {
        ["shelfs"] = {
            {["x"] = -2967.78, ["y"] = 391.49, ["z"] = 15.04, ["value"] = "checkout"},
            {["x"] = -2967.87, ["y"] = 389.3, ["z"] = 15.04, ["value"] = "diverse"},
        },
        ["blip"] = {
            ["x"] = -2964.96, ["y"] = 391.33, ["z"] = 15.04
        },
        ["cashier"] = {
            ["x"] = -2966.38, ["y"] = 391.44, ["z"] = 14.06, ["h"] = 91.62,
            ["hash"] = "s_m_m_linecook"
        },
        ["boss"] = {
            coords = {x = -2958.39, y = 389.49, z = 14.04 },
            owner = false
        },
    },

    [13] = {
        ["shelfs"] = {
            {["x"] = -1820.38, ["y"] = 792.69, ["z"] = 138.11, ["value"] = "checkout"},
            {["x"] = -1830.41, ["y"] = 787.62, ["z"] = 138.33, ["value"] = "drinks"},
            {["x"] = -1825.52, ["y"] = 789.33, ["z"] = 138.23, ["value"] = "snacks"},
            {["x"] = -1829.13, ["y"] = 792.0, ["z"] = 138.26, ["value"] = "readymeal"},
            {["x"] = -1821.55, ["y"] = 793.97, ["z"] = 138.12, ["value"] = "diverse"},
        },
        ["blip"] = {
            ["x"] = -1827.64, ["y"] = 793.31, ["z"] = 138.22
        },
        ["cashier"] = {
            ["x"] = -1819.53, ["y"] = 793.55, ["z"] = 137.11, ["h"] = 129.05,
        },
        ["boss"] = {
            coords = {x = -1827.27, y = 797.1, z = 138.18 },
            owner = false
        },
    },

    [14] = {
        ["shelfs"] = {
            {["x"] = 547.75, ["y"] = 2671.53, ["z"] = 42.16, ["value"] = "checkout"},
            {["x"] = 546.33, ["y"] = 2668.85, ["z"] = 42.16, ["value"] = "drinks"},
            {["x"] = 545.17, ["y"] = 2666.05, ["z"] = 42.16, ["value"] = "snacks"},
            {["x"] = 541.8, ["y"] = 2666.06, ["z"] = 42.16, ["value"] = "readymeal"},
            {["x"] = 548.08, ["y"] = 2669.36, ["z"] = 42.16, ["value"] = "diverse"},
        },
        ["blip"] = {
            ["x"] = 544.43, ["y"] = 2666.07, ["z"] = 42.16
        },
        ["cashier"] = {
            ["x"] = 549.04, ["y"] = 2671.36, ["z"] = 41.18, ["h"] = 98.25
        },
        ["boss"] = {
            coords = {x = 543.92, y = 2663.24, z = 42.16 },
            owner = false
        },
    },

    [15] = {
        ["shelfs"] = {
            {["x"] = 1165.36, ["y"] = 2709.45, ["z"] = 38.16, ["value"] = "checkout"},
            {["x"] = 1167.64, ["y"] = 2709.41, ["z"] = 38.16, ["value"] = "diverse"},
            {["x"] = 1169.07, ["y"] = 2707.72, ["z"] = 38.16, ["value"] = "drinks"},
            {["x"] = 1164.08, ["y"] = 2705.73, ["z"] = 38.16, ["value"] = "snacks"},
            {["x"] = 1165.89, ["y"] = 2707.22, ["z"] = 38.16, ["value"] = "readymeal"}
        },
        ["blip"] = {
            ["x"] = 1167.02, ["y"] = 2711.82, ["z"] = 38.16
        },
        ["cashier"] = {
            ["x"] = 1165.29, ["y"] = 2710.79, ["z"] = 37.18, ["h"] = 176.18,
            ["hash"] = "s_m_m_linecook"
        },
        ["boss"] = {
            coords = {x = 1167.04, y = 2718.88, z = 37.16 },
            owner = false
        },
    },

    [16] = {
        ["shelfs"] = {
            {["x"] = 2678.82, ["y"] = 3280.36, ["z"] = 55.24, ["value"] = "checkout"},
            {["x"] = 2677.8, ["y"] = 3283.08, ["z"] = 55.24, ["value"] = "drinks"},
            {["x"] = 2676.17, ["y"] = 3285.7, ["z"] = 55.24, ["value"] = "snacks"},
            {["x"] = 2678.1, ["y"] = 3288.43, ["z"] = 55.24, ["value"] = "readymeal"},
            {["x"] = 2676.91, ["y"] = 3281.38, ["z"] = 55.24, ["value"] = "diverse"},
        },
        ["blip"] = {
            ["x"] = 2676.55, ["y"] = 3286.27, ["z"] = 55.24
        },
        ["cashier"] = {
            ["x"] = 2678.1, ["y"] = 3279.4, ["z"] = 54.26, ["h"] = 331.07
        },
        ["boss"] = {
            coords = {x = 2674.68, y = 3288.43, z = 55.24 },
            owner = false
        },
    },

    [17] = {
        ["shelfs"] = {
            {["x"] = 1961.17, ["y"] = 3740.5, ["z"] = 32.34, ["value"] = "checkout"},
            {["x"] = 1961.74, ["y"] = 3743.33, ["z"] = 32.34, ["value"] = "drinks"},
            {["x"] = 1961.68, ["y"] = 3746.29, ["z"] = 32.34, ["value"] = "snacks"},
            {["x"] = 1964.74, ["y"] = 3747.71, ["z"] = 32.34, ["value"] = "readymeal"},
            {["x"] = 1960.18, ["y"] = 3742.21, ["z"] = 32.36, ["value"] = "diverse"},
        },
        ["blip"] = {
            ["x"] = 1962.33, ["y"] = 3746.67, ["z"] = 32.34
        },
        ["cashier"] = {
            ["x"] = 1960.13, ["y"] = 3739.94, ["z"] = 31.36, ["h"] = 297.89
        },
        ["boss"] = {
            coords = {x = 1956.91, y = 3746.83, z = 32.34 },
            owner = false
        },
    },

    [18] = {
        ["shelfs"] = {
            {["x"] = 1393.13, ["y"] = 3605.2, ["z"] = 34.98, ["value"] = "checkout"},
            {["x"] = 1390.93, ["y"] = 3604.4, ["z"] = 35.0, ["value"] = "diverse"},
            {["x"] = 1398.9, ["y"] = 3605.8, ["z"] = 34.98, ["value"] = "drinks"},
            {["x"] = 1397.29, ["y"] = 3607.39, ["z"] = 34.98, ["value"] = "snacks"},
            {["x"] = 1398.43, ["y"] = 3602.69, ["z"] = 34.98, ["value"] = "readymeal"}
        },
        ["blip"] = {
            ["x"] = 1391.23, ["y"] = 3609.29, ["z"] = 34.98
        },
        ["cashier"] = {
            ["x"] = 1392.74, ["y"] = 3606.35, ["z"] = 34.0, ["h"] = 202.73,
            ["hash"] = "s_m_m_linecook"
        },
        ["boss"] = {
            coords = {x = 1397.18, y = 3610.68, z = 34.98 },
            owner = false
        },
    },

    [19] = {
        ["shelfs"] = {
            {["x"] = 1697.92, ["y"] = 4924.46, ["z"] = 42.06, ["value"] = "checkout"},
            {["x"] = 1706.63, ["y"] = 4931.63, ["z"] = 42.06, ["value"] = "drinks"},
            {["x"] = 1702.28, ["y"] = 4928.93, ["z"] = 42.06, ["value"] = "snacks"},
            {["x"] = 1706.43, ["y"] = 4927.02, ["z"] = 42.06, ["value"] = "readymeal"},
            {["x"] = 1699.44, ["y"] = 4923.41, ["z"] = 42.06, ["value"] = "diverse"},
        },
        ["blip"] = {
            ["x"] = 1705.22, ["y"] = 4925.39, ["z"] = 42.06
        },
        ["cashier"] = {
            ["x"] = 1697.3, ["y"] = 4923.47, ["z"] = 41.08, ["h"] = 323.98
        },
        ["boss"] = {
            coords = {x = 1705.51, y = 4921.49, z = 42.06 },
            owner = false
        },
    },

    [20] = {
        ["shelfs"] = {
            {["x"] = 1728.78, ["y"] = 6414.41, ["z"] = 35.04, ["value"] = "checkout"},
            {["x"] = 1731.44, ["y"] = 6415.73, ["z"] = 35.04, ["value"] = "drinks"},
            {["x"] = 1733.92, ["y"] = 6417.4, ["z"] = 35.04, ["value"] = "snacks"},
            {["x"] = 1736.88, ["y"] = 6415.61, ["z"] = 35.04, ["value"] = "readymeal"},
            {["x"] = 1729.82, ["y"] = 6416.42, ["z"] = 35.04, ["value"] = "diverse"},
        },
        ["blip"] = {
            ["x"] = 1734.64, ["y"] = 6417.04, ["z"] = 35.04
        },
        ["cashier"] = {
            ["x"] = 1727.87, ["y"] = 6415.25, ["z"] = 34.06, ["h"] = 242.93
        },
        ["boss"] = {
            coords = {x = 1731.69, y = 6422.12, z = 35.04 },
            owner = false
        },
    },
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    
    ESX.TriggerServerCallback('esx_shop:getShops', function(shops)
        for i=1, #shops do
           Locations[shops[i].number]["owner"] = json.decode(shops[i].owner)
           Locations[shops[i].number]["shop"] = json.decode(shops[i].value)
           Locations[shops[i].number]["blip"]["name"] = shops[i].name
        end

        CreateBlips()
        DrawAll()
    end)
end)

DrawText3D = function(x, y, z, text)
    local onScreen,x,y = World3dToScreen2d(x, y, z)
    local factor = #text / 370

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(x,y)
        DrawRect(x,y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 120)
    end
end

--[[ Requests specified model ]]--
_RequestModel = function(hash)
    if type(hash) == "string" then hash = GetHashKey(hash) end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
end

--[[ Deletes the cashiers ]]--
DeleteCashier = function()
    for i=1, #Locations do
        local cashier = Locations[i]["cashier"]
        if DoesEntityExist(cashier["entity"]) then
            DeletePed(cashier["entity"])
            SetPedAsNoLongerNeeded(cashier["entity"])
        end
    end
end

-- [[ Fetch owned shops on client side ]]
RegisterNetEvent('esx_shop:passTheShops')
AddEventHandler('esx_shop:passTheShops', function (ownedShops)
    for i=1, #ownedShops, 1 do
        Locations[ownedShops[i]].boss.owner = true
    end
end)

-- [[ Fetch owned shops on client side ]]
RegisterNetEvent('esx_shop:clChangeName')
AddEventHandler('esx_shop:clChangeName', function (shopNumber, shopName)
    Locations[shopNumber].blip.name = shopName
    CreateBlips()
end)

-- [[ Change owned shop values on client side ]]
RegisterNetEvent('esx_shop:clChangedata')
AddEventHandler('esx_shop:clChangedata', function (shopNumber, data)
    Locations[shopNumber].shop.forsale = data.forsale
    Locations[shopNumber].owner.identifier = data.identifier
    Locations[shopNumber].owner.name = data.name
    if data.id == GetPlayerServerId(PlayerId()) then
        Locations[shopNumber].boss.owner = true
    else
        Locations[shopNumber].boss.owner = false
    end
end)

-- [[ Change some data ]]
RegisterNetEvent('esx_shop:clChangedataCustom')
AddEventHandler('esx_shop:clChangedataCustom', function (shopNumber, data)
    if data.type == "price" then
        Locations[shopNumber].shop.value = data.value
    elseif data.type == "status" then
        Locations[shopNumber].shop.forsale = data.forsale
    end
end)

Citizen.CreateThread(function()
    local defaultHash = 416176080
    for i=1, #Locations do
        local cashier = Locations[i]["cashier"]
        if cashier then
            cashier["hash"] = cashier["hash"] or defaultHash
            _RequestModel(cashier["hash"])
            if not DoesEntityExist(cashier["entity"]) then
                cashier["entity"] = CreatePed(4, cashier["hash"], cashier["x"], cashier["y"], cashier["z"], cashier["h"])
                SetEntityAsMissionEntity(cashier["entity"])
                SetBlockingOfNonTemporaryEvents(cashier["entity"], true)
                FreezeEntityPosition(cashier["entity"], true)
                SetEntityInvincible(cashier["entity"], true)
            end
            SetModelAsNoLongerNeeded(cashier["hash"])
        end
    end
end)

function DrawAll()
    Citizen.CreateThread(function()
        while true do
            local wait = 750
            local coords = GetEntityCoords(PlayerPedId())
            for i=1, #Locations do
                local cashier = Locations[i]["cashier"]
    
                if cashier then
                    local dist = GetDistanceBetweenCoords(coords, cashier["x"], cashier["y"], cashier["z"], true)
                    if dist <= 5.0 then
                        DrawText3D(cashier["x"], cashier["y"], cashier["z"] + 2.05, "Owner: " .. Locations[i].owner.name)
                        if Locations[i].shop.forsale then
                            if dist < 1.5 then
                                DrawText3D(cashier["x"], cashier["y"], cashier["z"] + 1.92, "[Y] Price: $" .. Locations[i].shop.value)

                                if IsControlJustPressed(0, 246) then -- [Y]
                                    BuyShopMenu(i)
                                end

                            else
                                DrawText3D(cashier["x"], cashier["y"], cashier["z"] + 1.92, "Price: $" .. Locations[i].shop.value)
                            end    
                        end
                        wait = 5
                    end
                end
                
            end
            Citizen.Wait(wait)
        end
    end)    
end

--[[ Creates cashiers and blips ]]--
function CreateBlips()
    Citizen.CreateThread(function()
        for i=1, #Locations do
            local blip = Locations[i]["blip"]

            if blip then
                if DoesBlipExist(blip["id"]) then
                    RemoveBlip(blip["id"])
                end

                blip["id"] = AddBlipForCoord(blip["x"], blip["y"], blip["z"])
                SetBlipSprite(blip["id"], 52)
                SetBlipDisplay(blip["id"], 4)
                SetBlipScale(blip["id"], 1.0)
                SetBlipColour(blip["id"], 66)
                SetBlipAsShortRange(blip["id"], true)
    
                BeginTextCommandSetBlipName("shopblip")
                AddTextEntry("shopblip", blip["name"] or "Shop")
                EndTextCommandSetBlipName(blip["id"])
            end
        end
    end)
end

--[[ Function to trigger pNotify event for easier use :) ]]--
pNotify = function(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
        text = message,
		type = messageType,
		queue = "shopcl",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end

Marker = function(pos)
    DrawMarker(25, pos["x"], pos["y"], pos["z"] - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.75, 0.75, 0.75, 200, 200, 200, 60, false, false, 2, false, nil, nil, false)
    DrawMarker(25, pos["x"], pos["y"], pos["z"] - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 200, 200, 200, 60, false, false, 2, false, nil, nil, false)
end

--[[ Deletes the peds when the resource stops ]]--
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        TriggerServerEvent('esx:clientLog', "[99kr-shops]: Deleting peds...")
        DeleteCashier()
    end
end)

-- [[ Draw Markers ]]
Citizen.CreateThread(function()
	while true do
	 	Citizen.Wait(0)

            local coords = GetEntityCoords(PlayerPedId())
            local canSleep = true

            for i,v in ipairs(Locations) do
                if v.boss.owner then
                    if GetDistanceBetweenCoords(coords, v.boss.coords.x, v.boss.coords.y, v.boss.coords.z, true) < 2 then
                        canSleep = false
                        DrawMarker(20, v.boss.coords.x, v.boss.coords.y, v.boss.coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 17, 254, 80, 100, false, true, 2, false, false, false, false)
                    end

                    if GetDistanceBetweenCoords(coords, Config.buy.pos.x, Config.buy.pos.y, Config.buy.pos.z, true) < 3 then
                        canSleep = false
                        DrawMarker(1, Config.buy.pos.x, Config.buy.pos.y, Config.buy.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 17, 254, 80, 100, false, true, 2, false, false, false, false)
                    end
                end
            end
            
            if canSleep then
                Citizen.Wait(500)
            end

    end
end)

AddEventHandler('esx_shop:hasEnteredMarker', function(zone)
	CurrentAction     = zone
	CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ ro feshar bedid!'
	CurrentActionData = {}
end)

AddEventHandler('esx_shop:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- [[ Make Markers activate on enter]]
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
        local currentZone = nil

        for i,v in ipairs(Locations) do
            if v.boss.owner then
                if GetDistanceBetweenCoords(coords, v.boss.coords.x, v.boss.coords.y, v.boss.coords.z, true) < 1 then
                    isInMarker  = true
                    currentZone = i
                end

                if GetDistanceBetweenCoords(coords, Config.buy.pos.x, Config.buy.pos.y, Config.buy.pos.z, true) < 1.5 then
                    isInMarker  = true
                    currentZone = "buy"
                end
            end
        end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_shop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_shop:hasExitedMarker', LastZone)
		end
		
		if not isInMarker then
			Citizen.Wait(500)
        end
        
	end
end)

-- [[ Key Handler ]]
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

            if IsControlJustReleased(0, 38) then -- [E]
                if tonumber(CurrentAction) then
                    OpenBossAction(CurrentAction)
                else
                    BuyShopItemsMenu()
                end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function OpenBossAction(shopNumber)
    ESX.TriggerServerCallback('esx_shop:getstatus', function(data)
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_boss_action', {
            title    = "Maghaze " .. Locations[shopNumber].blip.name,
            align    = 'top-left',
            elements = {
                {label = "Modiriat maghaze",  value = 'manager'},
                {label = "Moshahede mahsolat", value = "view"},
                {label = "Pool gavsandogh: <span style='color:green'>$" .. data.money .. "</span>", value = "deposit"}
            }
            
        }, function(data, menu)
            
            if data.current.value == 'manager' then
                openManagerMenu(shopNumber)
                menu.close()
            elseif data.current.value == 'view' then
                openInventoryShop(shopNumber)
            elseif data.current.value == 'deposit' then
                ESX.TriggerServerCallback('esx_shop:depositmoney', function(deposit)
                    if deposit then
                        ESX.ShowNotification("~h~Shoma ba movafaghiat mablagh ~g~$" .. tostring(deposit) .. "~w~ az shop bardashtid!")
                        menu.close()
                        OpenBossAction(shopNumber)
                    end
                end, shopNumber)
            end
            
        end, function (data, menu)
            menu.close()
            HasAlreadyEnteredMarker = false
        end)
    end, shopNumber)
end

function openInventoryShop(shopNumber)
    ESX.TriggerServerCallback('esx_shop:getinventory', function(inventory)

        if inventory then
            local elements = {}
            for k,v in pairs(inventory) do
                table.insert(elements, {label = v.count .. "x " .. v.label, value = k})
            end
            
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_inventory', {
                title    = "Inventory " .. Locations[shopNumber].blip.name,
                align    = 'top-left',
                elements = elements

            }, function(data2, menu2)

                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'shop_putstock', {
                    title    = "Meghdar ra vared konid",
    
                }, function(data3, menu3)

                   local count = tonumber(data3.value)
                   if data3.value then

                    if count then
                        if count > 0 then
                            ESX.TriggerServerCallback('esx_shop:putStock', function(success)
                                if success then
                                    ESX.ShowNotification("~h~Shoma ba movafaghiat ~o~x" .. success.count .. " ~g~" .. success.item .. "~w~ be shop add kardid!")
                                    menu3.close()
                                    menu2.close()
                                    openInventoryShop(shopNumber)
                                end
                            end, shopNumber, {item = data2.current.value, count = count})
                        else
                            ESX.ShowNotification("~h~Adad bayad az 0 bozorg tar bashad")
                        end
                    else
                        ESX.ShowNotification("~h~Shoma dar ghesmat ~r~meghdar ~w~faghat mitavanid ~g~adad~w~ vared konid!")
                    end
                    
                       
                   else
                    ESX.ShowNotification("~h~Shoma dar tedad faghat mitavanid adad vared konid!")
                   end

                end, function (data3, menu3)
                    menu3.close()
                end)

            end, function (data2, menu2)
                menu2.close()
            end)
        else
            ESX.ShowNotification("~h~Khatayi dar gereftan inventory shop pish amad!")
        end

    end, shopNumber)
end

function openManagerMenu(shopNumber)
    ESX.TriggerServerCallback('esx_shop:getstatus', function(data)
        ESX.UI.Menu.CloseAll()
        local elements = {
            {label = "Avaz kardan esm maghaze", value = "changename"},
            {label = "Gheymat maghaze: <span style='color:green'>$" .. data.value .. "</span>", value = "changeprice"},
        }
        if data.forsale then
            table.insert(elements, {label = "Vaziat forosh: ✔️", value = "changestatus"})
        else
            table.insert(elements, {label = "Vaziat forosh: ❌", value = "changestatus"})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_manager', {
            title    = "Modiriat " .. Locations[shopNumber].blip.name,
            align    = 'top-left',
            elements = elements
    
        }, function(data2, menu2)
    
            if data2.current.value == "changename" then
                openChangeNameMenu(shopNumber)
            elseif data2.current.value == "changeprice" then
                changePrice(shopNumber)
            elseif data2.current.value == "changestatus" then
                ESX.TriggerServerCallback('esx_shop:setstatus', function(success)
                    if success then
                        menu2.close()
                        openManagerMenu(shopNumber)
                    end
                end, shopNumber, data2.current.value, "status")
            end
    
        end, function (data2, menu2)
            menu2.close()
            HasAlreadyEnteredMarker = false
        end)

    end, shopNumber)
end

function changePrice(shopNumber)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'shop_changeprice', {
        title    = "Meghdar ra vared konid",

    }, function(data3, menu3)

       local count = tonumber(data3.value)
       if data3.value then

        if count then
            if count > 0 then
                ESX.TriggerServerCallback('esx_shop:setstatus', function(success)
                    if success then
                        ESX.ShowNotification("~h~Shoma ba movafaghiat gheymat shop ra be ~g~$" .. success .. "~w~ taghir dadid!")
                        menu3.close()
                        openManagerMenu(shopNumber)
                    end
                end, shopNumber, data3.value, "price")
            else
                ESX.ShowNotification("~h~Adad bayad az 0 bozorg tar bashad")
            end
        else
            ESX.ShowNotification("~h~Shoma dar ghesmat ~r~gheymat ~w~faghat mitavanid ~g~adad~w~ vared konid!")
        end
        
           
       else
        ESX.ShowNotification("~h~Shoma dar ghesmat gheymat chizi vared nakardid!")
       end

    end, function (data3, menu3)
        menu3.close()
    end)
end

function openChangeNameMenu(shopNumber)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'shop_changename', {
        title    = "Entekhab esm shop",

    }, function(data3, menu3)
        if not data3.value then
            ESX.ShowNotification("Hade aghal character shop bayad ~g~3~w~ ragham bashad!")
            return
        end

        if string.len(trim1(data3.value)) >= 3 then
            ESX.TriggerServerCallback('esx_shop:changename', function(changed)

                if changed then
                    ESX.ShowNotification("~h~Esm maghaze ba movafaghiat be ~g~" .. changed .. "~w~ taghir kard!")
                    openManagerMenu(shopNumber)
                else
                    ESX.ShowNotification("~h~Khatayi dar avaz karan esm shop vojod amad!")
                end

            end, shopNumber, data3.value)
        else
            ESX.ShowNotification("~h~Hade aghal character shop bayad ~g~3~w~ ragham bashad!")
        end
    end, function (data3, menu3)
        menu3.close()
        HasAlreadyEnteredMarker = false
    end)
end

function BuyShopMenu(shopNumber)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'confirm_buyshop',
    {
        title 	 = 'Tayid kharid maghaze',
        align    = 'center',
        question = "Aya az kharid maghaze ".. Locations[shopNumber].blip.name .. "(" .. shopNumber .. ")" .. " be gheymat $".. Locations[shopNumber].shop.value .. " motmaen hastid?",
        elements = {
            {label = 'Bale', value = 'yes'},
            {label = 'Kheir', value = 'no'},
        }
    }, function(data, menu)
       
        if data.current.value == "yes" then
            Citizen.Wait(math.random(100, 500))
            ESX.TriggerServerCallback('esx_shop:buyShop', function(success)

                if success then
                    ESX.ShowNotification("~h~Shoma ba movafaghiat maghaze ~g~" .. Locations[success].blip.name .. "(" .. success .. ")" .. "~w~ ra kharidid!")
                end
                menu.close()

            end, shopNumber)
        end
        menu.close()

    end, function (data, menu)
        menu.close()
    end)
end

function BuyShopItemsMenu()
    ESX.TriggerServerCallback('esx_shop:getbuyprices', function(items)
        ESX.UI.Menu.CloseAll()
        local elements = {}
        for k,v in pairs(items) do
            table.insert(elements, {label = v.label .. " <span style='color:green'>$" .. tostring(v.price) .. " </span>", price = v.price, name = v.label, value = k})
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_buyitems', {
            title    = "Omde Foroshi",
            align    = 'top-left',
            elements = elements
    
        }, function(data, menu)
    
            menu.close()
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'shop_buystock', {
                title    = "Meghdar ra vared konid",

            }, function(data2, menu2)

               local count = tonumber(data2.value)
               if data2.value then

                if count then
                    if count > 0 then

                        menu2.close()
                        ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'confirm_buyitem',
                        {
                            title 	 = 'Tayid kharid jens',
                            align    = 'center',
                            question = "Aya az kharid " .. tostring(count) .. " adad " .. data.current.name .. " be gheymat $" .. data.current.price * count .. " etminan darid?" ,
                            elements = {
                                {label = 'Bale', value = 'yes'},
                                {label = 'Kheir', value = 'no'},
                            }
                        }, function(data3, menu3)
                            
                            if data3.current.value == "yes" then
                                
                                ESX.TriggerServerCallback('esx_shop:buyStock', function(success)
                                    if success then
                                        ESX.ShowNotification("~h~Shoma ba movafaghiat ~o~x" .. success.count .. " " .. success.item .. "~w~ be gheymat ~g~$" .. success.price .. "~w~ kharidid!")
                                    end
                                end, {item = data.current.value, count = count})

                            end
                            menu3.close()

                        end, function (data3, menu3)
                            menu3.close()
                        end)

                    else
                        ESX.ShowNotification("~h~Adad bayad az 0 bozorg tar bashad")
                    end
                else
                    ESX.ShowNotification("~h~Shoma dar ghesmat ~r~meghdar ~w~faghat mitavanid ~g~adad~w~ vared konid!")
                end     
                   
               else
                ESX.ShowNotification("~h~Shoma dar ghesmat tedad chizi vared nakardid!")
               end

            end, function (data2, menu2)
                menu2.close()
            end)
          
        end, function (data, menu)
            menu.close()
            HasAlreadyEnteredMarker = false
        end)
    end)
end

function trim1(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
 end