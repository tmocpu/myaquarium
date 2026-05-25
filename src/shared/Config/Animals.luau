--!strict

local Types = require(script.Parent.Parent:WaitForChild("Types"))

local function modelPaths(name: string): { [Types.GrowthStage]: string }
	return {
		Newborn = `Assets/Fish/{name}/Newborn`,
		Juvenile = `Assets/Fish/{name}/Juvenile`,
		Adult = `Assets/Fish/{name}/Adult`,
		FullyGrown = `Assets/Fish/{name}/FullyGrown`,
	}
end

local DEFAULT_XP = {
	Newborn = 100,
	Juvenile = 500,
	Adult = 2000,
}

local Animals: { [Types.CreatureId]: Types.CreatureDef } = {
	Guppy = {
		id = "Guppy",
		name = "Guppy",
		rarity = "Common",
		baseChance = 2,
		zonesAvailable = { "BackyardPond" },
		modelByStage = modelPaths("Guppy"),
		baseStats = { attack = 3, defense = 2, hp = 20, harvestRate = 1 },
		xpToNextStage = DEFAULT_XP,
	},
	Minnow = {
		id = "Minnow",
		name = "Minnow",
		rarity = "Common",
		baseChance = 3,
		zonesAvailable = { "BackyardPond" },
		modelByStage = modelPaths("Minnow"),
		baseStats = { attack = 4, defense = 2, hp = 22, harvestRate = 1 },
		xpToNextStage = DEFAULT_XP,
	},
	Clownfish = {
		id = "Clownfish",
		name = "Clownfish",
		rarity = "Uncommon",
		baseChance = 15,
		zonesAvailable = { "BackyardPond" },
		modelByStage = modelPaths("Clownfish"),
		baseStats = { attack = 6, defense = 4, hp = 35, harvestRate = 3 },
		xpToNextStage = DEFAULT_XP,
	},
	Tetra = {
		id = "Tetra",
		name = "Tetra",
		rarity = "Uncommon",
		baseChance = 30,
		zonesAvailable = { "BackyardPond" },
		modelByStage = modelPaths("Tetra"),
		baseStats = { attack = 5, defense = 5, hp = 40, harvestRate = 4 },
		xpToNextStage = DEFAULT_XP,
	},
	Angelfish = {
		id = "Angelfish",
		name = "Angelfish",
		rarity = "Rare",
		baseChance = 200,
		zonesAvailable = { "BackyardPond" },
		modelByStage = modelPaths("Angelfish"),
		baseStats = { attack = 12, defense = 8, hp = 80, harvestRate = 8 },
		xpToNextStage = DEFAULT_XP,
	},
	Pufferfish = {
		id = "Pufferfish",
		name = "Pufferfish",
		rarity = "Rare",
		baseChance = 300,
		zonesAvailable = { "BackyardPond" },
		modelByStage = modelPaths("Pufferfish"),
		baseStats = { attack = 10, defense = 14, hp = 100, harvestRate = 7 },
		xpToNextStage = DEFAULT_XP,
	},
	Lionfish = {
		id = "Lionfish",
		name = "Lionfish",
		rarity = "Epic",
		baseChance = 2000,
		zonesAvailable = { "BackyardPond" },
		modelByStage = modelPaths("Lionfish"),
		baseStats = { attack = 30, defense = 12, hp = 160, harvestRate = 18 },
		xpToNextStage = DEFAULT_XP,
	},
	Octopus = {
		id = "Octopus",
		name = "Octopus",
		rarity = "Epic",
		baseChance = 3000,
		zonesAvailable = { "BackyardPond" },
		modelByStage = modelPaths("Octopus"),
		baseStats = { attack = 26, defense = 18, hp = 200, harvestRate = 20 },
		xpToNextStage = DEFAULT_XP,
	},
	Swordfish = {
		id = "Swordfish",
		name = "Swordfish",
		rarity = "Legendary",
		baseChance = 20000,
		zonesAvailable = { "BackyardPond" },
		modelByStage = modelPaths("Swordfish"),
		baseStats = { attack = 70, defense = 25, hp = 350, harvestRate = 45 },
		xpToNextStage = DEFAULT_XP,
	},
	MantaRay = {
		id = "MantaRay",
		name = "Manta Ray",
		rarity = "Legendary",
		baseChance = 30000,
		zonesAvailable = { "BackyardPond" },
		modelByStage = modelPaths("MantaRay"),
		baseStats = { attack = 55, defense = 40, hp = 420, harvestRate = 50 },
		xpToNextStage = DEFAULT_XP,
	},
}

return Animals
