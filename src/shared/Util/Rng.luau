--!strict

local Rng = {}

function Rng.weightedPick<T>(rng: Random, items: { T }, weight: (T) -> number): T?
	if #items == 0 then
		return nil
	end
	local total = 0
	for _, item in items do
		total += weight(item)
	end
	if total <= 0 then
		return nil
	end
	local roll = rng:NextNumber() * total
	local cumulative = 0
	for _, item in items do
		cumulative += weight(item)
		if roll <= cumulative then
			return item
		end
	end
	return items[#items]
end

function Rng.newSeeded(userId: number): Random
	return Random.new(math.floor(os.clock() * 1e6) + userId)
end

return Rng
