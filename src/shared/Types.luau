--!strict

export type Rarity =
	"Common"
	| "Uncommon"
	| "Rare"
	| "Epic"
	| "Legendary"
	| "Mythic"
	| "Divine"
	| "Celestial"

export type GrowthStage = "Newborn" | "Juvenile" | "Adult" | "FullyGrown"

export type CreatureId = string
export type SkillId = string
export type ZoneId = string

export type CreatureStats = {
	attack: number,
	defense: number,
	hp: number,
	harvestRate: number,
}

export type CreatureDef = {
	id: CreatureId,
	name: string,
	rarity: Rarity,
	baseChance: number,
	zonesAvailable: { ZoneId },
	modelByStage: { [GrowthStage]: string },
	baseStats: CreatureStats,
	xpToNextStage: {
		Newborn: number,
		Juvenile: number,
		Adult: number,
	},
	retired: boolean?,
}

export type OwnedCreature = {
	uuid: string,
	creatureId: CreatureId,
	xp: number,
	stage: GrowthStage,
	shiny: boolean,
	acquiredAt: number,
	equipped: boolean,
}

export type Boost = {
	multiplier: number,
	expiresAt: number,
}

export type DecorationPlacement = {
	id: string,
	cf: CFrame,
}

export type AquariumState = {
	tier: number,
	decorations: { DecorationPlacement },
}

export type PlayerData = {
	schemaVersion: number,
	inventory: { OwnedCreature },
	coins: number,
	gems: number,
	food: number,
	totalRolls: number,
	pityCounter: number,
	rarestPull: CreatureId?,
	currentZone: ZoneId,
	zonesUnlocked: { ZoneId },
	rebirths: number,
	rebirthPoints: number,
	skills: { [SkillId]: number },
	aquarium: AquariumState,
	boosts: {
		luck: Boost?,
		rollSpeed: Boost?,
		harvest: Boost?,
	},
	index: { [CreatureId]: boolean },
	flexDisplay: { string },
	stats: {
		mobsKilled: number,
		totalCoinsEarned: number,
		lastSeen: number,
	},
}

export type PingResponse = {
	pong: number,
	serverTime: number,
	schemaVersion: number,
}

return {}
