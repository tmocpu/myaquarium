--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Types = require(Shared:WaitForChild("Types"))
local Constants = require(Shared:WaitForChild("Constants"))
local Remotes = require(Shared:WaitForChild("Remotes"))

local Server = script.Parent.Parent
local ProfileService = require(Server:WaitForChild("Vendor"):WaitForChild("ProfileService")) :: any

local RemoteRouter = require(script.Parent:WaitForChild("RemoteRouter"))

local PROFILE_STORE_NAME = if RunService:IsStudio() then "PlayerData_dev_v1" else "PlayerData_v1"

local function defaultData(): Types.PlayerData
	return {
		schemaVersion = Constants.SCHEMA_VERSION,
		inventory = {},
		coins = 0,
		gems = 0,
		food = 0,
		totalRolls = 0,
		pityCounter = 0,
		rarestPull = nil,
		currentZone = Constants.DEFAULT_ZONE,
		zonesUnlocked = { Constants.DEFAULT_ZONE },
		rebirths = 0,
		rebirthPoints = 0,
		skills = {},
		aquarium = {
			tier = Constants.DEFAULT_AQUARIUM_TIER,
			decorations = {},
		},
		boosts = {},
		index = {},
		flexDisplay = {},
		stats = {
			mobsKilled = 0,
			totalCoinsEarned = 0,
			lastSeen = 0,
		},
	}
end

local ProfileStore = ProfileService.GetProfileStore(PROFILE_STORE_NAME, defaultData())

local profiles: { [Player]: any } = {}

local DataService = {}

function DataService.get(player: Player): Types.PlayerData?
	local profile = profiles[player]
	if not profile then
		return nil
	end
	return profile.Data
end

function DataService.waitFor(player: Player, timeoutSeconds: number?): Types.PlayerData?
	local deadline = os.clock() + (timeoutSeconds or 10)
	while os.clock() < deadline do
		local data = DataService.get(player)
		if data then
			return data
		end
		task.wait(0.1)
	end
	return nil
end

function DataService.markDirty(player: Player): ()
	local data = DataService.get(player)
	if not data then
		return
	end
	(Remotes.PlayerDataUpdated :: RemoteEvent):FireClient(player, data)
end

local function loadProfile(player: Player)
	local profile = ProfileStore:LoadProfileAsync(`Player_{player.UserId}`)
	if not profile then
		player:Kick("Data load failed, please rejoin.")
		return
	end
	profile:AddUserId(player.UserId)
	profile:Reconcile()
	profile:ListenToRelease(function()
		profiles[player] = nil
		if player.Parent == Players then
			player:Kick("Session ended. Please rejoin.")
		end
	end)
	if player.Parent ~= Players then
		profile:Release()
		return
	end
	profile.Data.stats.lastSeen = os.time()
	profiles[player] = profile
	DataService.markDirty(player)
end

local function releaseProfile(player: Player)
	local profile = profiles[player]
	if profile then
		profile.Data.stats.lastSeen = os.time()
		profile:Release()
	end
end

function DataService.init(): ()
	RemoteRouter.registerInvoke(
		"RequestPlayerData",
		{ key = "RequestPlayerData", cooldownSeconds = 0.5 },
		function(player)
			return DataService.waitFor(player, 10)
		end
	)

	for _, player in Players:GetPlayers() do
		task.spawn(loadProfile, player)
	end
	Players.PlayerAdded:Connect(function(player)
		task.spawn(loadProfile, player)
	end)
	Players.PlayerRemoving:Connect(releaseProfile)
	game:BindToClose(function()
		for _, player in Players:GetPlayers() do
			releaseProfile(player)
		end
	end)
end

return DataService
