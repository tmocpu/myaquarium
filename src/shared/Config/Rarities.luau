--!strict

local Types = require(script.Parent.Parent:WaitForChild("Types"))

export type RarityDef = {
	id: Types.Rarity,
	displayName: string,
	color: Color3,
	tier: number,
	announceGlobally: boolean,
}

local Rarities: { [Types.Rarity]: RarityDef } = {
	Common = {
		id = "Common",
		displayName = "Common",
		color = Color3.fromRGB(180, 180, 180),
		tier = 1,
		announceGlobally = false,
	},
	Uncommon = {
		id = "Uncommon",
		displayName = "Uncommon",
		color = Color3.fromRGB(100, 220, 100),
		tier = 2,
		announceGlobally = false,
	},
	Rare = {
		id = "Rare",
		displayName = "Rare",
		color = Color3.fromRGB(80, 140, 255),
		tier = 3,
		announceGlobally = false,
	},
	Epic = {
		id = "Epic",
		displayName = "Epic",
		color = Color3.fromRGB(180, 90, 230),
		tier = 4,
		announceGlobally = false,
	},
	Legendary = {
		id = "Legendary",
		displayName = "Legendary",
		color = Color3.fromRGB(255, 200, 60),
		tier = 5,
		announceGlobally = true,
	},
	Mythic = {
		id = "Mythic",
		displayName = "Mythic",
		color = Color3.fromRGB(255, 70, 70),
		tier = 6,
		announceGlobally = true,
	},
	Divine = {
		id = "Divine",
		displayName = "Divine",
		color = Color3.fromRGB(255, 130, 220),
		tier = 7,
		announceGlobally = true,
	},
	Celestial = {
		id = "Celestial",
		displayName = "Celestial",
		color = Color3.fromRGB(140, 220, 255),
		tier = 8,
		announceGlobally = true,
	},
}

return Rarities
