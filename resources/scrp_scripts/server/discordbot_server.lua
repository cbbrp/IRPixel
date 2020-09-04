AddEventHandler('es:chatMessage', function(source, command_args, user)
	local data = json.encode({
		username = GetPlayerName(source),
		content  = command_args
	})

	PerformHttpRequest(GetConvar("chat_webhook", "https://discordapp.com/api/webhooks/606912747447255041/AJzzpEhRk7qhKAqNqhqKS6w8E_dZzfK1psowZ13B5CLaXijTxLUa9XTiSqIksewbXj5x"), function(err, text, headers) end, 'POST', data, { ['Content-Type'] = 'application/json' })
end)