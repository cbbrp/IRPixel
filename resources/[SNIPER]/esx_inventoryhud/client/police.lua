RegisterNetEvent("esx_inventoryhud:openPoliceInventory")
AddEventHandler(
    "esx_inventoryhud:openPoliceInventory",
    function(data)
        setPoliceInventoryData(data)
        openPoliceInventory()
    end
)

function refreshPoliceInventory()
    ESX.TriggerServerCallback(
        "esx_policejob:getPoliceInventory",
        function(inventory)
            setPoliceInventoryData(inventory)
        end
    )
end

function setPoliceInventoryData(data)
    items = {}

    local PoliceItems = data.items
    local PoliceWeapons = data.weapons

    for i = 1, #PoliceItems, 1 do
        local item = PoliceItems[i]

        if item.count > 0 then
            item.type = "item_standard"
            item.usable = false
            item.rare = false
            item.limit = -1
            item.canRemove = false

            table.insert(items, item)
        end
    end

    for i = 1, #PoliceWeapons, 1 do
        local weapon = PoliceWeapons[i]

        if PoliceWeapons[i].name ~= "WEAPON_UNARMED" then
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

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = items
        }
    )
end

function openPoliceInventory()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "Police"
        }
    )

    SetNuiFocus(true, true)
end

RegisterNUICallback(
    "PutIntoPolice",
    function(data, cb)
        if type(data.number) == "number" and math.floor(data.number) == data.number then
            local count = tonumber(data.number) or nil

            TriggerServerEvent("esx_policejob:addToInventory", data.item.type, data.item.name, count)
        end

        Wait(150)
        refreshPoliceInventory()
        Wait(150)
        loadPlayerInventory()

        cb("ok")
    end
)

RegisterNUICallback(
    "TakeFromPolice",
    function(data, cb)
        if IsPedSittingInAnyVehicle(playerPed) then
            return
        end

        if type(data.number) == "number" and math.floor(data.number) == data.number then
            TriggerServerEvent("esx_policejob:getFromInventory", data.item.type, data.item.name, tonumber(data.number))
        end

        Wait(150)
        refreshPoliceInventory()
        Wait(150)
        loadPlayerInventory()

        cb("ok")
    end
)
