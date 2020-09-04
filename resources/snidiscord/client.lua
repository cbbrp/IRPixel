Citizen.CreateThread(function()
	while true do
        --This is the Application ID (Replace this with you own)
		SetDiscordAppId(661206986578198548)

        --Here you will have to put the image name for the "large" icon.
		SetDiscordRichPresenceAsset('ir_pixel_logo')
        
        --(11-11-2018) New Natives:

        --Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('IRPixel')
       
        --Here you will have to put the image name for the "small" icon.
        SetDiscordRichPresenceAssetSmall('info')

        --Here you can add hover text for the "small" icon.
        SetDiscordRichPresenceAssetSmallText('Website: IRPixel.IR')
        -- Showname implementation with new Native
        -- Old script: https://github.com/Parow/showname
        
        -- Amount of online players (Don't touch)
        local playerCount = #GetActivePlayers()
        
        -- Your own playername (Don't touch)
        local playerName = GetPlayerName(PlayerId())

        -- Set here the amount of slots you have (Edit if needed)
        local maxPlayerSlots = "128"

        -- Sets the string with variables as RichPresence (Don't touch)
        SetRichPresence(string.format("%s - %s/%s", playerName, playerCount, maxPlayerSlots))
        
        -- It updates every one minute just in case.
		Citizen.Wait(3000)
	end
end)