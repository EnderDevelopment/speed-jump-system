local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('speedjumpsystem:getStatus', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerId = xPlayer.identifier

    MySQL.Async.fetchScalar('SELECT speed_enabled FROM speedjumpsystem WHERE player_id = @player_id', {
        ['@player_id'] = playerId
    }, function(speedEnabled)
        MySQL.Async.fetchScalar('SELECT jump_enabled FROM speedjumpsystem WHERE player_id = @player_id', {
            ['@player_id'] = playerId
        }, function(jumpEnabled)
            cb(speedEnabled, jumpEnabled)
        end)
    end)
end)

ESX.RegisterServerCallback('speedjumpsystem:updateStatus', function(source, cb, speedEnabled, jumpEnabled)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerId = xPlayer.identifier

    MySQL.Async.execute('UPDATE speedjumpsystem SET speed_enabled = @speed_enabled, jump_enabled = @jump_enabled WHERE player_id = @player_id', {
        ['@speed_enabled'] = speedEnabled,
        ['@jump_enabled'] = jumpEnabled,
        ['@player_id'] = playerId
    }, function(rowsChanged)
        cb()
    end)
end)