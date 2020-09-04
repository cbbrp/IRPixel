ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()

	while true do
        Citizen.Wait(1000)
        local timestamp = os.time()
        TriggerClientEvent('streetlabel:timestamp', -1, timestamp)
    end

end)

RegisterCommand('gloadall', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level == 3 then
        if not args[1] then
            return
        end

        if args[1] == "true" then
          TriggerClientEvent('streetlabel:changeLoadStatus', -1, true)
        elseif args[1] == "false" then
          TriggerClientEvent('streetlabel:changeLoadStatus', -1, false)
        end
        
    end
end, false)

RegisterCommand('vloadall', function(source, args)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.permission_level == 10 then
      if not args[1] then
          return
      end

      if args[1] == "true" then
        TriggerClientEvent('esx_voice:changeLoadStatus', -1, true)
      elseif args[1] == "false" then
        TriggerClientEvent('esx_voice:changeLoadStatus', -1, false)
      end
      
  end
end, false)

RegisterCommand('ggps', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level == 10 then
        if not args[1] then
            return
        end
        
        if args[1] == "true" then
          TriggerClientEvent('streetlabel:changeGpsStatus', -1, true)
        elseif args[1] == "false" then
          TriggerClientEvent('streetlabel:changeGpsStatus', -1, false)
        end
        
    end
end, false)