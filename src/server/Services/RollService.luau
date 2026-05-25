--!strict

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Types = require(Shared:WaitForChild("Types"))
local Constants = require(Shared:WaitForChild("Constants"))
local Animals = require(Shared:WaitForChild("Config"):WaitForChild("Animals"))
local Rng = require(Shared:WaitForChild("Util"):WaitForChild("Rng"))
local RarityMath = require(Shared:WaitForChild("Util"):WaitForChild("RarityMath"))

local DataService = require(script.Parent:WaitForChild("DataService"))
local InventoryService = require(script.Parent:WaitForChild("InventoryService"))
local RemoteRouter = require(script.Parent:WaitForChild("RemoteRouter"))

type RollResult = {
	ok: boolean,
	creature: Types.OwnedCreature?,
	err: string?,
}

local RARITY_TIER: { [Types.Rarity]: number } = {
	Common = 1,
	Uncommon = 2,
	Rare = 3,
	Epic = 4,
	Legendary = 5,
	Mythic = 6,
	Divine = 7,
	Celestial = 8,
}

local rngByPlayer: { [Player]: Random } = {}

local function getRng(player: Player): Random
	local existing = rngByPlayer[player]
	if existing then
		return existing
	end
	local fresh = Rng.newSeeded(player.UserId)
	rngByPlayer[player] = fresh
	return fresh
end

local function poolForZone(zone: Types.ZoneId): { Types.CreatureDef }
	local result: { Types.CreatureDef } = {}
	for _, def in Animals do
		if def.retired then
			continue
		end
		for _, z in def.zonesAvailable do
			if z == zone then
				table.insert(result, def)
				break
			end
		end
	end
	return result
end

local function luckFor(_data: Types.PlayerData): number
	-- Phase 1: base luck only. Skill/boost contributions land in Phase 7.
	return 1
end

local function shouldForcePity(data: Types.PlayerData): boolean
	return data.pityCounter >= Constants.PITY_THRESHOLD
end

local function pickWithLuck(player: Player, pool: { Types.CreatureDef }, luck: number): Types.CreatureDef?
	return Rng.weightedPick(getRng(player), pool, function(def)
		return RarityMath.weightFor(def.baseChance, luck)
	end)
end

local function pickEpicOrBetter(player: Player, pool: { Types.CreatureDef }, luck: number): Types.CreatureDef?
	local epicPlus: { Types.CreatureDef } = {}
	for _, def in pool do
		if RARITY_TIER[def.rarity] >= RARITY_TIER.Epic then
			table.insert(epicPlus, def)
		end
	end
	if #epicPlus == 0 then
		return nil
	end
	return Rng.weightedPick(getRng(player), epicPlus, function(def)
		return RarityMath.weightFor(def.baseChance, luck)
	end)
end

local function handleRoll(player: Player): RollResult
	local data = DataService.get(player)
	if not data then
		return { ok = false, err = "NoData" }
	end
	local pool = poolForZone(data.currentZone)
	if #pool == 0 then
		return { ok = false, err = "EmptyPool" }
	end
	local luck = luckFor(data)

	local pick: Types.CreatureDef?
	if shouldForcePity(data) then
		pick = pickEpicOrBetter(player, pool, luck) or pickWithLuck(player, pool, luck)
	else
		pick = pickWithLuck(player, pool, luck)
	end
	if not pick then
		return { ok = false, err = "NoPick" }
	end

	data.totalRolls += 1
	data.pityCounter += 1
	if RARITY_TIER[pick.rarity] >= RARITY_TIER.Epic then
		data.pityCounter = 0
	end

	local shiny = getRng(player):NextInteger(1, Constants.SHINY_CHANCE_DENOM) == 1
	local owned: Types.OwnedCreature = {
		uuid = HttpService:GenerateGUID(false),
		creatureId = pick.id,
		xp = 0,
		stage = "Newborn",
		shiny = shiny,
		acquiredAt = os.time(),
		equipped = false,
	}
	if not InventoryService.addCreature(player, owned) then
		return { ok = false, err = "InventoryFull" }
	end

	local rarestId = data.rarestPull
	local rarestDef = if rarestId then Animals[rarestId] else nil
	if not rarestDef or RARITY_TIER[pick.rarity] > RARITY_TIER[rarestDef.rarity] then
		data.rarestPull = pick.id
	end
	data.index[pick.id] = true

	DataService.markDirty(player)
	return { ok = true, creature = owned }
end

local RollService = {}

function RollService.init(): ()
	RemoteRouter.registerInvoke(
		"Roll",
		{ key = "Roll", cooldownSeconds = Constants.ROLL_COOLDOWN_SECONDS },
		handleRoll
	)
	Players.PlayerRemoving:Connect(function(player)
		rngByPlayer[player] = nil
	end)
end

return RollService
