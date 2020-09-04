--====================================================================================
--  Function APP BANK
--====================================================================================

--[[
      Appeller SendNUIMessage({event = 'updateBankbalance', banking = xxxx})
      à la connection & à chaque changement du compte
--]]


--- Piste

-- local bank = 0

-- RegisterNetEvent("es:addedBank")
-- AddEventHandler("es:addedBank", function(m, native)
--   bank = bank + m
--   SendNUIMessage({event = 'updateBankbalance', banking = a})
-- end)

-- RegisterNetEvent("es:removedBank")
-- AddEventHandler("es:removedBank", function(m, native, current)
--   bank = bank - m
--   SendNUIMessage({event = 'updateBankbalance', banking = a})
-- end)

RegisterNetEvent('gcphone:setUiPhone')
AddEventHandler('gcphone:setUiPhone', function(amount)
    print("Triggered set to: " .. tostring(amount))
    SendNUIMessage({event = 'updateBankbalance', banking = amount})
end)