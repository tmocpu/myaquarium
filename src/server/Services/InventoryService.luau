--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Types = require(Shared:WaitForChild("Types"))
local Constants = require(Shared:WaitForChild("Constants"))

local DataService = require(script.Parent:WaitForChild("DataService"))

local InventoryService = {}

function InventoryService.addCreature(player: Player, creature: Types.OwnedCreature): boolean
	local data = DataService.get(player)
	if not data then
		return false
	end
	if #data.inventory >= Constants.BASE_INVENTORY_CAP then
		return false
	end
	table.insert(data.inventory, creature)
	return true
end

function InventoryService.findByUuid(player: Player, uuid: string): (number?, Types.OwnedCreature?)
	local data = DataService.get(player)
	if not data then
		return nil, nil
	end
	for index, owned in data.inventory do
		if owned.uuid == uuid then
			return index, owned
		end
	end
	return nil, nil
end

function InventoryService.removeByUuid(player: Player, uuid: string): boolean
	local data = DataService.get(player)
	if not data then
		return false
	end
	local index = InventoryService.findByUuid(player, uuid)
	if not index then
		return false
	end
	table.remove(data.inventory, index)
	return true
end

function InventoryService.init(): ()
	-- Equip/unequip remotes land in Phase 2; nothing to wire yet.
end

return InventoryService
