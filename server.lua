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
                    grade = xPlayer.job.grade_label or tostring(xPlayer.job.grade),
                    coords = { x = coords.x, y = coords.y, z = coords.z }
                })
            end
        end
    end

    cb(cops)
end)

ESX.RegisterServerCallback('policeblips:getJob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer and xPlayer.job.name or nil)
end)
