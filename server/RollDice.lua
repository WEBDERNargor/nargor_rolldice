Citizen.CreateThread(function() 
                                
    if(RollDice.UseCommand)then
        RegisterCommand(RollDice.ChatCommand, function(source, args, rawCommand) 
            if(args[1] ~= nil and args[2] ~= nil)then 
                local dices = tonumber(args[1]) 
                local sides = tonumber(args[2]) -
                if (sides > 0 and sides <= RollDice.MaxSides) and (dices > 0 and dices <= RollDice.MaxDices) then --Checks if sides and dices are bigger than 0 and smaller than the config values.
                    TriggerEvent("nargor:Server:Event", source, dices, sides)
                else
                    TriggerClientEvent('chatMessage', source, RollDice.ChatPrefix, RollDice.ChatTemplate, "Invalid amount. Max Dices: " .. RollDice.MaxDices .. ", Max Sides: " .. RollDice.MaxSides)
                end

            else
                TriggerClientEvent('chatMessage', source, RollDice.ChatPrefix, RollDice.ChatTemplate, "Please fill out both arguments, example: /" .. RollDice.ChatCommand .. " <dices> <sides>")
            end

        end, false)
    end

end)

RegisterServerEvent('nargor:Server:Event')
AddEventHandler('nargor:Server:Event', function(source, dices, sides)
                                                                       
                                                                        
    local tabler = {}
    for i=1, dices do 
        table.insert(tabler, math.random(1, sides)) 
    end

    TriggerClientEvent("nargor:Client:Roll", -1, source, RollDice.MaxDistance, tabler, sides, GetEntityCoords(GetPlayerPed(source))) 
end)
