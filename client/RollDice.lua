

local globalPlayerPedId = nil

Citizen.CreateThread(function() 
    if(RollDice.UseCommand)then
        TriggerEvent('chat:addSuggestion', '/' .. RollDice.ChatCommand, 'Roll Dices', { 
        { name="dices", help="Amount of Dices - Max: " .. RollDice.MaxDices  },
        { name="sides", help="Amount of Sides - Max: " .. RollDice.MaxSides  }
        })
    end
end)

RegisterNetEvent("nargor:Client:Roll")
AddEventHandler("nargor:Client:Roll", function(sourceId, maxDinstance, rollTable, sides, location)
	local rollString = CreateRollString(rollTable, sides)
    globalPlayerPedId = GetPlayerPed(-1)
	

    if(location.x == 0.0 and location.y == 0.0 and location.z == 0.0)then 
        location = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)))
    end

	if GetPlayerServerId(PlayerId()) == sourceId then 
        DiceRollAnimation()
	end
	
    ShowRoll(rollString, sourceId, maxDinstance, location) 
end)

function CreateRollString(rollTable, sides)
    local text = "Roll: "
    local total = 0

    for k, roll in pairs(rollTable, sides) do 
        total = total + roll
        if k == 1 then
            text = text .. roll .. "/" .. sides
        else
            text = text .. " | " .. roll .. "/" .. sides
        end
    end

    text = text .. " | (Total: "..total..")"
    return text
end

function DiceRollAnimation()
    RequestAnimDict("anim@mp_player_intcelebrationmale@wank") 

    while (not HasAnimDictLoaded("anim@mp_player_intcelebrationmale@wank")) do 
        Citizen.Wait(0)
    end
    
    TaskPlayAnim(globalPlayerPedId, "anim@mp_player_intcelebrationmale@wank" ,"wank" ,8.0, -8.0, -1, 49, 0, false, false, false ) 
    Citizen.Wait(2400)
    ClearPedTasks(globalPlayerPedId)
end

function ShowRoll(text, sourceId, maxDistance, location)
	local coords = GetEntityCoords(globalPlayerPedId, false) -
	local dist = #(location - coords) 

	if dist < RollDice.MaxDistance then 
		local display = true
		
		Citizen.CreateThread(function() 
			Wait(RollDice.ShowTime * 1000)
			display = false
		end)
		
		Citizen.CreateThread(function()
			serverPed = GetPlayerPed(GetPlayerFromServerId(sourceId))
			while display do
				Wait(7)
                local currentCoords = GetEntityCoords(serverPed) 

				DrawText3D(currentCoords.x, currentCoords.y, currentCoords.z + RollDice.Offset - 1.25, text) 
            end
		end)

	end
end

function DrawText3D(x,y,z, text) 
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
		DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 100)
      end
end


Citizen.CreateThread(function() 
        Citizen.Wait(60000)
        collectgarbage("collect")
    end 
end)
