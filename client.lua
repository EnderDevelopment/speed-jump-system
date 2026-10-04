local ESX = nil
local isSpeedActive = false
local isJumpActive = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, Config.ToggleKey) then
            ToggleSpeedJump()
        end
    end
end)

function ToggleSpeedJump()
    ESX.TriggerServerCallback('speedjumpsystem:getStatus', function(speedEnabled, jumpEnabled)
        isSpeedActive = speedEnabled
        isJumpActive = jumpEnabled

        if isSpeedActive then
            SetRunSprintMultiplierForPlayer(PlayerId(), Config.SpeedMultiplier)
            Citizen.SetTimeout(Config.SpeedDuration, function()
                SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
                isSpeedActive = false
                ESX.TriggerServerCallback('speedjumpsystem:updateStatus', function() end, isSpeedActive, isJumpActive)
            end)
        else
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
        end

        if isJumpActive then
            SetSuperJumpThisFrame(PlayerId())
            Citizen.SetTimeout(Config.JumpDuration, function()
                isJumpActive = false
                ESX.TriggerServerCallback('speedjumpsystem:updateStatus', function() end, isSpeedActive, isJumpActive)
            end)
        end

        ESX.TriggerServerCallback('speedjumpsystem:updateStatus', function() end, isSpeedActive, isJumpActive)
    end)
end