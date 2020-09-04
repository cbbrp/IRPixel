ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('es:playerLoaded', function(source)
	TriggerClientEvent('tab:CheckPlayer', source)
end)

ESX.RegisterServerCallback('tab:CheckPlayer',function(source,cb)
  local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

end)
