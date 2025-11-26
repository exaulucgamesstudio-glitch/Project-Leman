local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Config = require(ReplicatedStorage:WaitForChild("Config"))
local PlayerData = require(script.Parent:WaitForChild("PlayerData"))

local SAMPLE_INTERVAL = 0.2

local distanceStuds = {}
local lastPositions = {}
local sampleAccumulator = 0

local function getPlayerCar(player)
    local getter = _G.GetPlayerCar
    if typeof(getter) == "function" then
        local success, car = pcall(getter, player)
        if success then
            return car
        end
    end

    return nil
end

local function resetTracking(player)
    distanceStuds[player] = nil
    lastPositions[player] = nil
end

RunService.Heartbeat:Connect(function(dt)
    sampleAccumulator += dt

    if sampleAccumulator < SAMPLE_INTERVAL then
        return
    end

    sampleAccumulator -= SAMPLE_INTERVAL

    for _, player in ipairs(Players:GetPlayers()) do
        local car = getPlayerCar(player)
        if car and car.PrimaryPart then
            local position = car.PrimaryPart.Position
            local lastPosition = lastPositions[player]

            if lastPosition then
                local studsMoved = (position - lastPosition).Magnitude
                local totalStuds = (distanceStuds[player] or 0) + studsMoved
                distanceStuds[player] = totalStuds

                local kms = math.floor(totalStuds / Config.STUDS_PER_KM)
                if kms > 0 then
                    distanceStuds[player] = totalStuds - (kms * Config.STUDS_PER_KM)
                    PlayerData.AddMoney(player, kms * Config.MONEY_PER_KM)
                    PlayerData.AddKilometers(player, kms)
                end
            end

            lastPositions[player] = position
        else
            resetTracking(player)
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    resetTracking(player)
end)
