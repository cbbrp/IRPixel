ESX = nil
local isMinimapEnabled = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
	end
end)

RegisterNetEvent('gpstools:setgps')
AddEventHandler('gpstools:setgps', function(pos)
	-- add required decimal or else it wont work
	pos.x = pos.x + 0.00
	pos.y = pos.y + 0.00

	SetNewWaypoint(pos.x, pos.y)
	ESX.ShowHelpNotification(_U('gpstools_setgps_ok'))
end)

RegisterNetEvent('gpstools:getpos')
AddEventHandler('gpstools:getpos', function()
	local playerPed = PlayerPedId()

	local pos      = GetEntityCoords(playerPed)
	local heading  = GetEntityHeading(playerPed)
	local finalPos = {}

	-- round to 2 decimals
	finalPos.x = string.format("%.2f", pos.x)
	finalPos.y = string.format("%.2f", pos.y)
	finalPos.z = string.format("%.2f", pos.z)
	finalPos.h = string.format("%.2f", heading)

	local formattedText = "x = " .. finalPos.x .. ", y = " .. finalPos.y .. ", z = " .. finalPos.z .. ', h = ' .. finalPos.h
	TriggerEvent('chatMessage', 'SYSTEM', { 0, 0, 0 }, formattedText)
	print(formattedText)
end)

RegisterNetEvent('gpstools:togglegps')
AddEventHandler('gpstools:togglegps', function()
	if not isMinimapEnabled then
		SetRadarBigmapEnabled(true, false)
		isMinimapEnabled = true
	else
		SetRadarBigmapEnabled(false, false)
		isMinimapEnabled = false
	end
end)

RegisterNetEvent('gpstools:tpwaypoint')
AddEventHandler('gpstools:tpwaypoint', function()
	local playerPed = GetPlayerPed(-1)

		if(IsPedInAnyVehicle(playerPed))then
			playerPed = GetVehiclePedIsUsing(playerPed)
		end

		local WaypointHandle = GetFirstBlipInfoId(8)
		if DoesBlipExist(WaypointHandle) then
			local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
			RequestCollisionAtCoord(coord.x, coord.y, -199.5)
			while not HasCollisionLoadedAroundEntity(playerPed) do
				RequestCollisionAtCoord(coords.x, coords.y, -199.5)
				Citizen.Wait(0)
			end
			SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, -199.5, false, false, false, true)
			ESX.ShowNotification("Shoma be marker roye map teleport shodid!")
		else
			ESX.ShowNotification("Markeri baraye teleport shodan vojoud nadarad!")
		end

end)