--================================================================================================
--==                                VARIABLES - DO NOT EDIT                                     ==
--================================================================================================
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('bank:depirpixelosit')
AddEventHandler('bank:depirpixelosit', function(amount)
	local _source = source
	if not _source then
		return
	end
	local amount = tonumber(amount)
	
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then
		return
	end

	if not amount then
		TriggerClientEvent('bank:result', _source, "error", "Shoma dar ghesmat mablagh chizi vared nakardid.")
		return
	end

	if amount <= 0 or amount > xPlayer.money then
		TriggerClientEvent('bank:result', _source, "error", "Shoma pol kafi baraye deposit nadarid.")
	else
		exports.sniperlog:TransActionLog({source = xPlayer.source, type = "Variz", amount = amount})
		xPlayer.removeMoney(amount)
		xPlayer.addBank(amount)
		TriggerClientEvent('bank:result', _source, "success", "Deposit ba movafaghiat anjam shod.")
	end
end)


RegisterServerEvent('bank:withdirpixelraw')
AddEventHandler('bank:withdirpixelraw', function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local base = xPlayer.bank
	local amount = tonumber(amount)

	if not amount then
		TriggerClientEvent('bank:result', source, "error", "Shoma dar ghesmat mablagh chizi vared nakardid.")
		return
	end

	local difference = base - amount

	if amount <= 0 or amount > base then
		TriggerClientEvent('bank:result', source, "error", "Shoma meghdar kafi pol dar bank nadarid.")
	else
		if difference >= 1000 then
			exports.sniperlog:TransActionLog({source = xPlayer.source, type = "Bardasht", amount = amount})
			xPlayer.removeBank(amount)
			xPlayer.addMoney(amount)
			TriggerClientEvent('bank:result', source, "success", "Bardasht ba movafaghiiat anjam shod.")
		else
			TriggerClientEvent('bank:result', source, "error", "Shoma nemitavanid hesab khod ra kamel khali konid hadeaghal bayad 1000$ dar hesab baghi bemanad.")
		end
	end
end)

RegisterServerEvent('bank:balance')
AddEventHandler('bank:balance', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local balance = xPlayer.bank
	TriggerClientEvent('currentbalance1', _source, balance, string.gsub(xPlayer.name, "_", " "))
end)


RegisterServerEvent('bank:tranirpixelsfer')
AddEventHandler('bank:tranirpixelsfer', function(to, amount)
	local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	local zPlayer = ESX.GetPlayerFromId(to)
	local amount = tonumber(amount)
	if not amount then
		TriggerClientEvent('bank:result', _source, "error", "Shoma dar ghesmat mablagh chizi vared nakardid.")
		return
	end
	local balance = 0

	if(zPlayer == nil or zPlayer == -1) then
		TriggerClientEvent('bank:result', _source, "error", "Hesab mored nazar peyda nashod.")
	else
		balance = xPlayer.bank
		zbalance = zPlayer.bank
		local difference = balance - amount
		
		if tonumber(_source) == tonumber(to) then
			TriggerClientEvent('bank:result', _source, "error", "Shoma nemitvanid be hesab khodetan pol enteghal dahid!")
		else
			if balance <= 0 or balance < amount or amount <= 0 then

				TriggerClientEvent('bank:result', _source, "error", "Shoma pol kafi dar bank nadarid.")
			else	
				
				if difference >= 1000 then
					xPlayer.removeBank(amount)
					zPlayer.addBank(amount)
                	exports.sniperlog:TransferLog({source = xPlayer.source, target = zPlayer.source, type = "Transfer", amount = amount})
					TriggerClientEvent('esx:showAdvancedNotification', zPlayer.source, 'Bank', 'Transaction', "Mablagh ~g~" .. tostring(amount) .. "~w~ az taraf ~o~ " .. string.gsub(xPlayer.name, "_", " ") .. "~w~ be hesab shoma variz  shod!", 'CHAR_BANK_MAZE', 9)
					TriggerClientEvent('bank:result', _source, "success", "Enteghal ba movafaghiat anjam shod.")
				else
					TriggerClientEvent('bank:result', _source, "error", "Shoma nemitavanid hesab khod ra kamel khali konid hadeaghal bayad 1000$ dar hesab baghi bemanad.")
				end
						
			end
		end
	end
end)