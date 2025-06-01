ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('policeblips:getCopsWithCoords', function(source, cb)
    local xSource = ESX.GetPlayerFromId(source)
    if not xSource or xSource.job.name ~= 'police' then
        cb({})
        return
    end

    local cops = {}

    for _, playerId in ipairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer and xPlayer.job.name == 'police' then
            local ped = GetPlayerPed(playerId)
            if DoesEntityExist(ped) then
                local coords = GetEntityCoords(ped)
                table.insert(cops, {
                    id = playerId,
                    name = GetPlayerName(playerId),
                    coords = {
                        x = math.floor(coords.x * 100) / 100,
                        y = math.floor(coords.y * 100) / 100,
                        z = math.floor(coords.z * 100) / 100
                    }
                })
            end
        end
    end

    cb(cops)
end)

ESX.RegisterServerCallback('policeblips:getJob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        cb(xPlayer.job.name)
    else
        cb(nil)
    end
end)
