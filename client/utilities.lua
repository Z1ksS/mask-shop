RegisterCommand("teleport", function() -- teleport to the shop
    SetEntityCoords(PlayerPedId(), -1339.563, -1278.385, 4.5, true, true, true, false)
end)

RegisterCommand("unfreeze", function() -- force unfreeze function
    FreezeEntityPosition(player_ped, false)
end)

function randomFloat(min, max) -- float random
    return tonumber(string.format("%.2f", min + math.random() * (max - min)))
end

function set_model() -- set customizable model for player
    local freemode_model = GetHashKey("mp_m_freemode_01")
 
    if IsModelInCdimage(freemode_model) and IsModelValid(freemode_model) then
        RequestModel(freemode_model)
        while not HasModelLoaded(freemode_model) do
          Wait(50)
        end
 
        SetPlayerModel(PlayerId(), freemode_model)
        local player_ped = PlayerPedId()
        SetPedComponentVariation(player_ped, 0, 0, 0, 2)
        SetPedComponentVariation(player_ped, 2, 14, 4, 2)
        SetPedComponentVariation(player_ped, 4, 1, 5, 2)
        SetPedComponentVariation(player_ped, 6, 1, 0, 2)
        SetPedComponentVariation(player_ped, 11, 1, 2, 2)
    end
end

RegisterCommand("model", function()
    set_model()
end, false)