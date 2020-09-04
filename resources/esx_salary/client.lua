local ESX = nil
local salary = 0
local vehicles = {};
HasAlreadyEnteredMarker = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx-salary:checkModelForVehicle')
AddEventHandler('esx-salary:checkModelForVehicle', function(model)
    local vehicleName = GetDisplayNameFromVehicleModel(model)
    if not contains(vehicles, vehicleName) then
        table.insert(vehicles, vehicleName)
    end
    TriggerServerEvent('esx-salary:passTheVehicleName', vehicles)
end)

RegisterNetEvent('esx-salary:modify')
AddEventHandler('esx-salary:modify', function(type, amount)

    if type == "add" then

        salary = salary + amount

    elseif type == "set" then
        
        salary = amount

    end

end)

RegisterCommand('takesalary', function(source)

    if checkDistance() then
        TriggerEvent("chatMessage", "[BANK]", {255, 0, 0}, "^0Karkonan dar hale mohasebe hastand lotfan shakiba bashid!")
        TriggerServerEvent('esx-salary:calculateSalary', GetPlayerServerId(PlayerId()))
    else
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma baraye bardasht salary bayad nazdik be baje bank bashid!")
    end
    
end, false)

-- RegisterCommand('addsalary', function(source, args)


--     local types = args[2]
--     local target = tonumber(args[1])
--     local amount = tonumber(args[3])
--     TriggerServerEvent('esx-salary:modify', target, types, amount)
    
-- end, false)

Citizen.CreateThread(function()
    Holograms()
end)

function checkDistance()
    local coords = GetEntityCoords(GetPlayerPed(-1))
    for k,v in pairs(Config.Zones) do
        for i=1, #v.Pos, 1 do
            if GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, false) < 2 then
                return true
            end
        end
    end
    return false
end

function contains(table, val)
    for i = 1, #table do
        if table[i] == val then
            return true
        end
    end
    return false
end

function Holograms()
	while true do
        Citizen.Wait(5)
        for k,v in pairs(Config.Zones) do
            for i=1, #v.Pos, 1 do
                if GetDistanceBetweenCoords(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, GetEntityCoords(GetPlayerPed(-1)), false) < 3.0 then
                    if v.Pos[i].type == "salary" then
                        Draw3DText( v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.Label, 4, 0.1, 0.1)
                        Draw3DText( v.Pos[i].x, v.Pos[i].y, v.Pos[i].z - 0.250, "Salary: " .. salary .. "$", 4, 0.1, 0.1)
                    else

                        if IsControlJustPressed(0, 38) then -- [E]
                            FrontDesk()
                        end

                        Draw3DText( v.Pos[i].x, v.Pos[i].y, v.Pos[i].z - 0.250, v.Pos[i].label, 4, 0.1, 0.1)
                    end
                end
                
                if not NearAny() then
                    if HasAlreadyEnteredMarker then
                        ESX.UI.Menu.CloseAll()
                        HasAlreadyEnteredMarker = false
                    end
                end

            end
        end
	end
end

function FrontDesk()
    ESX.UI.Menu.CloseAll()
    HasAlreadyEnteredMarker = true
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'frontdesk_menu', {
        title    = "FrontDesk Police",
        align    = 'top-left',
        elements = {
            {label = "Avaz kardan esm", value = "changename"},
        }

    }, function(data, menu)

        if data.current.value == "changename" then
            menu.close()

            ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'frontdesk_question',
            {
                title 	 = 'Aya az avaz kardan esm khod etminan darid?',
                align    = 'center',
                question = "Esm khod ra bayad hamrah ba _ vared konid be farz mersal ali_mohammadi, hazine avaz kardan esm $50000 ast va bad az avaz kardan 1 mah cooldown khahad dasht!",
                elements = {
                    {label = 'Bale', value = 'yes'},
                    {label = 'Kheir', value = 'no'},
                }
            }, function(data2, menu2)
            
                menu2.close()
                if data2.current.value == "yes" then

                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'frontdesk_input', {
                        title    = "Entekhab esm",
                
                    }, function(data3, menu3)
                        if not data3.value then
                            ESX.ShowNotification("~h~Hade aghal esm bayad ~g~7~w~ character bashad!")
                            return
                        end

                        if data3.value:match("[^%w%s]") or data3.value:match("%d") then
                            ESX.ShowNotification("~h~Shoma mojaz be vared kardan ~r~Special ~o~character ~w~ya ~r~adad ~w~nistid!")
                            return
                        end
                
                        if string.len(trim1(data3.value)) >= 7 then
                            menu3.close()
                            ESX.TriggerServerCallback('esx_salary:changename', function(code, name)
                
                                if code == 1 then
                                    ESX.ShowNotification("~h~Shoma baraye avaz kardan esm khod niaz be ~g~$50000 ~w~pool darid!")
                                elseif code == 2 then
                                    ESX.ShowNotification("~h~Shoma baraye joda kardan esm az famil bayad az ~g~_ ~w~estefade konid!")
                                elseif code == 3 then
                                    ESX.ShowNotification("~h~Shoma nemitavanid esm ya famil ra ~g~khali ~w~begozarid!")
                                elseif code == 4 then 
                                    ESX.ShowNotification("~h~Esm va famil hade aghal bayad ~g~3 ~w~character bashad!")
                                elseif code == 5 then
                                    ESX.ShowNotification("~h~Ghabeliat avaz kardan esm shoma roye ~g~cooldown ~w~ast lotfan badan moraje konid!")
                                elseif code == 6 then
                                    ESX.ShowNotification("~h~In esm ghablan tavasot shakhs digari ~g~sabt ~w~shode ast!")
                                elseif code == 7 then
                                    TriggerEvent("chatMessage", "[Sabte Ahval]", {255, 0, 0}, "Esm shoma ba movafaghiat be ^3" .. name .. "^0 taghir kard va mablagh ^2$50000 ^0az hesab shoma kam shod!")
                                end
                
                            end, trim1(data3.value))
                        else
                            ESX.ShowNotification("~h~Hade aghal esm bayad ~g~7~w~ character bashad!")
                        end
                    end, function (data3, menu3)
                        menu3.close()
                        HasAlreadyEnteredMarker = false
                    end)

                end

            end, function (data2, menu2)
                menu2.close()
            end)

        end

    end, function (data, menu)
        menu.close()
        HasAlreadyEnteredMarker = false
    end)
end
function NearAny()
    for k,v in pairs(Config.Zones) do
        for i=1, #v.Pos, 1 do
            if GetDistanceBetweenCoords(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, GetEntityCoords(GetPlayerPed(-1)), false) < 3.0 then
                return true
            end
        end
    end

    return false
end

function trim1(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
 end

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
         local px,py,pz=table.unpack(GetGameplayCamCoords())
         local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
         local scale = (1/dist)*20
         local fov = (1/GetGameplayCamFov())*100
         local scale = scale*fov   
         SetTextScale(scaleX*scale, scaleY*scale)
         SetTextFont(fontId)
         SetTextProportional(1)
         SetTextColour(250, 250, 250, 255)
         SetTextDropshadow(1, 1, 1, 1, 255)
         SetTextEdge(2, 0, 0, 0, 150)
         SetTextDropShadow()
         SetTextOutline()
         SetTextEntry("STRING")
         SetTextCentre(1)
         AddTextComponentString(textInput)
         SetDrawOrigin(x,y,z+2, 0)
         DrawText(0.0, 0.0)
         ClearDrawOrigin()
end