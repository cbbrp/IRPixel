local blips = {
  -- Example {title="", colour=, id=, x=, y=, z=},
  -- Postes de polices
  {title="Race", colour=2, id=523, x=479.18, y=-3111.54, z=6.08},
  {title="Bank", colour=2, id=106, x=236.43, y=217.4, z=106.29},
  {title="Casino & Resort", colour=27, id=590, x=918.84, y=51.46, z=80.9},
  -- {title="Duty Winery", colour=50, id=355, x=-1883.84, y=2059.94, z=140.98},
  -- {title="Church", colour=0, id=181, x=-787.03, y=-15.49, z=-16.77},
  -- {title="Event Start!", colour=0, id=501, x=209.79, y=7023.84, z=2.11},
  -- {title="Event Stage 2!", colour=0, id=502, x=209.79, y=7023.84, z=2.11},
  -- {title="Event Stage 3!", colour=0, id=503, x=1309.63, y=6486.31, z=20.07},
  -- {title="Event Stage 4!", colour=0, id=504, x=714.14, y=4114.63, z=35.78},
  -- {title="Event Stage 5!", colour=0, id=505, x=1419.70, y=3745.79, z=35.78},
  -- {title="Event Stage 6!", colour=0, id=506, x=1722.87, y=3259.3, z=41.15},
  -- {title="Event Finish Line!", colour=0, id=507, x=-945.51, y=-3368.75, z=13.94},
  }
Citizen.CreateThread(function()

    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 0.9)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)
