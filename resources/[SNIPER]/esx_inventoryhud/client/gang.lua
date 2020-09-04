local BlacklistedWeapons = {
	[GetHashKey("WEAPON_DAGGER")] = true,
	[GetHashKey("WEAPON_PROXMINE")] = true,
	[GetHashKey("WEAPON_PROXMINE")] = true,
	[GetHashKey("WEAPON_RAYMINIGUN")] = true,
	[GetHashKey("WEAPON_COMPACTLAUNCHER")] = true,
	[GetHashKey("WEAPON_HOMINGLAUNCHER")] = true,
	[GetHashKey("WEAPON_RAILGUN")] = true,
	[GetHashKey("WEAPON_FIREWORK")] = true,
	[GetHashKey("WEAPON_MINIGUN")] = true,
	[GetHashKey("WEAPON_GRENADELAUNCHER_SMOKE")] = true,
	[GetHashKey("WEAPON_GRENADELAUNCHER")] = true,
	[GetHashKey("WEAPON_RPG")] = true,
	[GetHashKey("WEAPON_MARKSMANRIFLE_MK2")] = true,
	[GetHashKey("WEAPON_MARKSMANRIFLE")] = true,
	[GetHashKey("WEAPON_HEAVYSNIPER_MK2")] = true,
	[GetHashKey("WEAPON_HEAVYSNIPER")] = true,
	[GetHashKey("WEAPON_SNIPERRIFLE")] = true,
	[GetHashKey("WEAPON_COMBATMG_MK2")] = true,
	[GetHashKey("WEAPON_COMBATMG")] = true,
	[GetHashKey("WEAPON_MG")] = true,
	[GetHashKey("WEAPON_COMPACTRIFLE")] = true,
	[GetHashKey("WEAPON_BULLPUPRIFLE_MK2")] = true,
	[GetHashKey("WEAPON_BULLPUPRIFLE")] = true, 
	[GetHashKey("WEAPON_SPECIALCARBINE_MK2")] = true, 
	[GetHashKey("WEAPON_SPECIALCARBINE")] = true,
	[GetHashKey("WEAPON_ADVANCEDRIFLE")] = true,
	[GetHashKey("WEAPON_CARBINERIFLE_MK2")] = true,
	[GetHashKey("WEAPON_ASSAULTRIFLE_MK2")] = true,
	[GetHashKey("WEAPON_AUTOSHOTGUN")] = true,
	[GetHashKey("WEAPON_DBSHOTGUN")] = true,
	[GetHashKey("WEAPON_HEAVYSHOTGUN")] = true,
	[GetHashKey("WEAPON_MUSKET")] = true,
	[GetHashKey("WEAPON_BULLPUPSHOTGUN")] = true,
	[GetHashKey("WEAPON_ASSAULTSHOTGUN")] = true,
	[GetHashKey("WEAPON_SAWNOFFSHOTGUN")] = true, 
	[GetHashKey("WEAPON_PUMPSHOTGUN_MK2")] = true,
	[GetHashKey("WEAPON_PUMPSHOTGUN")] = true,
	[GetHashKey("WEAPON_RAYCARBINE")] = true,
	[GetHashKey("WEAPON_MINISMG")] = true,
	[GetHashKey("WEAPON_MACHINEPISTOL")] = true,
	-- [GetHashKey("WEAPON_COMBATPDW")] = true,
	[GetHashKey("WEAPON_SMG_MK2")] = true,
	-- [GetHashKey("WEAPON_MICROSMG")] = true,
	[GetHashKey("WEAPON_NAVYREVOLVER")] = true,
    [GetHashKey("WEAPON_CERAMICPISTOL")] = true,
    [GetHashKey("WEAPON_PISTOL_MK2")] = true,
    [GetHashKey("WEAPON_SNSPISTOL_MK2")] = true,
	[GetHashKey("WEAPON_RAYPISTOL")] = true,
	[GetHashKey("WEAPON_DOUBLEACTION")] = true,
	[GetHashKey("WEAPON_REVOLVER_MK2")] = true,
	[GetHashKey("WEAPON_REVOLVER")] = true,
	[GetHashKey("WEAPON_MARKSMANPISTOL")] = true,
	[GetHashKey("WEAPON_FLAREGUN")] = true,
	[GetHashKey("WEAPON_VINTAGEPISTOL")] = true,
	[GetHashKey("WEAPON_APPISTOL")] = true,
	[GetHashKey("WEAPON_BOTTLE")] = true,
	[GetHashKey("WEAPON_GOLFCLUB")] = true,
	[GetHashKey("WEAPON_POOLCUE")] = true,
    [GetHashKey("WEAPON_SMOKEGRENADE")] = true,
    [GetHashKey("WEAPON_SNOWBALL")] = true,
    [GetHashKey("WEAPON_FLARE")] = true
}

RegisterNetEvent("esx_inventoryhud:openGangInventory")
AddEventHandler("esx_inventoryhud:openGangInventory",
    function(data)
        setGangInventoryData(data)
        openGangInventory()
    end
)

function refreshGangInventory()
    ESX.TriggerServerCallback(
        "gangs:getGangInventory",
        function(inventory)
            setGangInventoryData(inventory)
        end
    )
end

function setGangInventoryData(data)
    items = {}

    local gangItems = data.items
    local gangWeapons = data.weapons

    for i = 1, #gangItems, 1 do
        local item = gangItems[i]

        if item.count > 0 then
            item.type = "item_standard"
            item.usable = false
            item.rare = false
            item.limit = -1
            item.canRemove = false

            table.insert(items, item)
        end
    end

    for i = 1, #gangWeapons, 1 do
        local weapon = gangWeapons[i]

        if gangWeapons[i].name ~= "WEAPON_UNARMED" then
            if not BlacklistedWeapons[GetHashKey(gangWeapons[i].name)] then
                table.insert(
                items,
                {
                    label = ESX.GetWeaponLabel(weapon.name),
                    count = weapon.ammo,
                    limit = -1,
                    type = "item_weapon",
                    name = weapon.name,
                    usable = false,
                    rare = false,
                    canRemove = false
                }
                )
            end
            
        end
    end

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = items
        }
    )
end

function openGangInventory()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "gang"
        }
    )

    SetNuiFocus(true, true)
end

RegisterNUICallback("PutIntoGang", function(data, cb)
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number) or nil

        TriggerServerEvent("gangs:addToInventory", data.item.type, data.item.name, count)
    end

    Wait(150)
    refreshGangInventory()
    Wait(150)
    loadPlayerInventory()

    cb("ok")
end)

RegisterNUICallback("TakeFromGang", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        TriggerServerEvent("gangs:getFromInventory", data.item.type, data.item.name, tonumber(data.number))
    end

    Wait(150)
    refreshGangInventory()
    Wait(150)
    loadPlayerInventory()

    cb("ok")
end)
