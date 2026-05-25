--!strict

local RarityMath = {}

function RarityMath.effectiveChance(baseChance: number, luck: number): number
	local applied = if luck > 0 then luck else 1
	return baseChance / applied
end

function RarityMath.weightFor(baseChance: number, luck: number): number
	return 1 / RarityMath.effectiveChance(baseChance, luck)
end

return RarityMath
