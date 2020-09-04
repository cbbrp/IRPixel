-- this script puts certain large weapons on a player's back when it is not currently selected but still in there weapon wheel

-- by: minipunch

-- originally made for USA Realism RP (https://usarrp.net)



-- Add weapons to the 'compatable_weapon_hashes' table below to make them show up on a player's back (can use GetHashKey(...) if you don't know the hash) --
ESX                           = nil
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

local SETTINGS = {

    back_bone = 24816,

    x = 0.175,

    y = -0.15,

    z = 0.05,

    x_rotation = 0.0,

    y_rotation = 165.0,

    z_rotation = 0.0,

    compatable_weapon_hashes = {

        ["w_sg_sawnoff"] = 2017895192,

        -- launchers:

        ["w_lr_firework"] = 2138347493,

        -- sniper rifles:

        ["w_sr_sniperrifle"] = 100416529,

        -- assault rifles:

        ["w_ar_carbinerifle"] = -2084633992,

        ["w_ar_assaultrifle"] = -1074790547,

        ["w_ar_specialcarbine"] = -1063057011,

        ["w_ar_bullpuprifle"] = 2132975508,

        ["w_ar_advancedrifle"] = -1357824103,

        -- shotguns:

        ["w_sg_assaultshotgun"] = -494615257,

        ["w_sg_bullpupshotgun"] = -1654528753,

        ["w_sg_pumpshotgun"] = 487013001,

        ["w_ar_musket"] = -1466123874,

        ["w_sr_heavysniper"] = 205991906,

         -- sub machine guns:

         ["w_sb_microsmg"] = 324215364,
         
         ["w_sb_pdw"] = 171789620,

         ["w_sb_assaultsmg"] = -270015777,

         ["w_sb_smg"] = 736523883,

         ["w_sb_gusenberg"] = 1627465347,

         ["w_sb_combatpdw"] = 2023061218

    }

}



local attached_weapons = {}



Citizen.CreateThread(function()

    local attachOneOnly = true

  while true do

      local me = GetPlayerPed(-1)

      ---------------------------------------

      -- attach if player has large weapon --

      ---------------------------------------

      for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do

          if HasPedGotWeapon(me, wep_hash, false) then

              if not attached_weapons[wep_name] then

                  if wep_name == "w_sb_microsmg" then
                    AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x-0.2, SETTINGS.y+0.15, SETTINGS.z-0.25, 100.0, 70.0, 140.0, isMeleeWeapon(wep_name))
                  elseif attachOneOnly then
                    attachOneOnly = false
                    AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation, isMeleeWeapon(wep_name))
                  end
                  

              end

          end

      end

      --------------------------------------------

      -- remove from back if equipped / dropped --

      --------------------------------------------

      for name, attached_object in pairs(attached_weapons) do

          -- equipped? delete it from back:

          if GetSelectedPedWeapon(me) ==  attached_object.hash or not HasPedGotWeapon(me, attached_object.hash, false) then -- equipped or not in weapon wheel

            local netid = NetworkGetNetworkIdFromEntity(attached_object.handle)
            TriggerServerEvent('weapBack:removeWeapon', netid)
            ESX.Game.DeleteObject(attached_object.handle)
            
            if attached_object.hash ~= 324215364 then
              attachOneOnly = true
            end

            attached_weapons[name] = nil

          end

      end

   Citizen.Wait(500)

  end

end)

RegisterNetEvent('weapBack:removeWeapon')
AddEventHandler('weapBack:removeWeapon', function(netID)
    local object = NetworkGetEntityFromNetworkId(netID)
    if DoesEntityExist(object) then
      ESX.Game.DeleteObject(object)
    end
end)

function AttachWeapon(attachModel,modelHash,boneNumber,x,y,z,xR,yR,zR, isMelee)

	local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)

	RequestModel(attachModel)

	while not HasModelLoaded(attachModel) do

		Wait(100)

	end



  attached_weapons[attachModel] = {

    hash = modelHash,
    handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)

  }

  local networkID = NetworkGetNetworkIdFromEntity(attached_weapons[attachModel].handle)
  TriggerServerEvent('weapBack:addWeapon', networkID)

  if isMelee then x = 0.11 y = -0.14 z = 0.0 xR = -75.0 yR = 185.0 zR = 92.0 end -- reposition for melee items

  if attachModel == "prop_ld_jerrycan_01" then x = x + 0.3 end

	AttachEntityToEntity(attached_weapons[attachModel].handle, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)

end

function isMeleeWeapon(wep_name)

    if wep_name == "prop_golf_iron_01" then

        return true

    elseif wep_name == "w_me_bat" then

        return true

    elseif wep_name == "prop_ld_jerrycan_01" then

      return true

    else

        return false

    end

end

