local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Config"))

local dataStore = DataStoreService:GetDataStore("PlayerData")
local profiles = {}

local DEFAULT_CAR = "city_hatchback"
local MAX_SAVE_ATTEMPTS = 3
local SAVE_RETRY_DELAY = 2

local function getDefaultProfile()
    return {
        Money = Config.STARTING_MONEY,
        OwnedCars = { DEFAULT_CAR },
        EquippedCar = DEFAULT_CAR,
        TotalKm = 0,
    }
end

local function createLeaderstats(player, profile)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local moneyValue = Instance.new("IntValue")
    moneyValue.Name = "Money"
    moneyValue.Value = profile.Money or 0
    moneyValue.Parent = leaderstats

    local kmValue = Instance.new("IntValue")
    kmValue.Name = "TotalKm"
    kmValue.Value = profile.TotalKm or 0
    kmValue.Parent = leaderstats
end

local function saveProfile(player)
    local profile = profiles[player]
    if not profile then
        return
    end

    local userId = tostring(player.UserId)
    for attempt = 1, MAX_SAVE_ATTEMPTS do
        local success, err = pcall(function()
            dataStore:SetAsync(userId, profile)
        end)

        if success then
            return true
        end

        warn(string.format("Failed to save profile for %s (attempt %d): %s", player.Name, attempt, tostring(err)))
        task.wait(SAVE_RETRY_DELAY)
    end

    return false
end

local function loadProfile(player)
    local userId = tostring(player.UserId)
    local success, data = pcall(function()
        return dataStore:GetAsync(userId)
    end)

    if not success then
        warn(string.format("Failed to load profile for %s: %s", player.Name, tostring(data)))
        return nil
    end

    if data == nil then
        return getDefaultProfile()
    end

    return data
end

local function onPlayerAdded(player)
    local profile = loadProfile(player) or getDefaultProfile()
    profiles[player] = profile

    createLeaderstats(player, profile)
end

local function onPlayerRemoving(player)
    saveProfile(player)
    profiles[player] = nil
end

function GetProfile(player)
    return profiles[player]
end

function AddMoney(player, amount)
    local profile = profiles[player]
    if not profile then
        return
    end

    local delta = math.floor(amount or 0)
    if delta == 0 then
        return
    end

    profile.Money = (profile.Money or 0) + delta

    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local moneyValue = leaderstats:FindFirstChild("Money")
        if moneyValue then
            moneyValue.Value = profile.Money
        end
    end
end

function AddKilometers(player, km)
    local profile = profiles[player]
    if not profile then
        return
    end

    local delta = math.floor(km or 0)
    if delta == 0 then
        return
    end

    profile.TotalKm = (profile.TotalKm or 0) + delta

    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local kmValue = leaderstats:FindFirstChild("TotalKm")
        if kmValue then
            kmValue.Value = profile.TotalKm
        end
    end
end

function SetEquippedCar(player, carId)
    local profile = profiles[player]
    if not profile then
        return
    end

    profile.EquippedCar = carId
end

function AddOwnedCar(player, carId)
    local profile = profiles[player]
    if not profile then
        return
    end

    local ownedCars = profile.OwnedCars or {}

    for _, owned in ipairs(ownedCars) do
        if owned == carId then
            profile.OwnedCars = ownedCars
            return
        end
    end

    if #ownedCars >= (Config.MAX_CAR_PER_PLAYER or math.huge) then
        return
    end

    table.insert(ownedCars, carId)
    profile.OwnedCars = ownedCars
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

game:BindToClose(function()
    for _, player in ipairs(Players:GetPlayers()) do
        onPlayerRemoving(player)
    end

    for player in pairs(profiles) do
        saveProfile(player)
    end
end)
