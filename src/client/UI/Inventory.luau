--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = require(Shared:WaitForChild("Remotes"))
local Animals = require(Shared:WaitForChild("Config"):WaitForChild("Animals"))
local Rarities = require(Shared:WaitForChild("Config"):WaitForChild("Rarities"))

local Inventory = {}

local state: {
	panel: Frame?,
	list: ScrollingFrame?,
	title: TextLabel?,
} = {
	panel = nil,
	list = nil,
	title = nil,
}

local function getGui(): ScreenGui
	local pg = Players.LocalPlayer:WaitForChild("PlayerGui")
	local existing = pg:FindFirstChild("Inventory")
	if existing and existing:IsA("ScreenGui") then
		return existing
	end
	local gui = Instance.new("ScreenGui")
	gui.Name = "Inventory"
	gui.ResetOnSpawn = false
	gui.Parent = pg
	return gui
end

local function buildUi(parent: ScreenGui)
	local panel = Instance.new("Frame")
	panel.Name = "Panel"
	panel.AnchorPoint = Vector2.new(0, 0.5)
	panel.Position = UDim2.new(0, 12, 0.5, 0)
	panel.Size = UDim2.fromOffset(300, 480)
	panel.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
	panel.BackgroundTransparency = 0.15
	panel.BorderSizePixel = 0
	panel.Visible = false
	panel.Parent = parent

	local panelCorner = Instance.new("UICorner")
	panelCorner.CornerRadius = UDim.new(0, 10)
	panelCorner.Parent = panel

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -16, 0, 32)
	title.Position = UDim2.fromOffset(8, 8)
	title.BackgroundTransparency = 1
	title.Text = "Inventory (0)"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 22
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = panel

	local list = Instance.new("ScrollingFrame")
	list.Name = "List"
	list.Position = UDim2.fromOffset(8, 48)
	list.Size = UDim2.new(1, -16, 1, -56)
	list.BackgroundTransparency = 1
	list.BorderSizePixel = 0
	list.ScrollBarThickness = 6
	list.CanvasSize = UDim2.fromOffset(0, 0)
	list.AutomaticCanvasSize = Enum.AutomaticSize.Y
	list.Parent = panel

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 4)
	layout.Parent = list

	local toggle = Instance.new("TextButton")
	toggle.Name = "InventoryToggle"
	toggle.AnchorPoint = Vector2.new(0, 1)
	toggle.Position = UDim2.new(0, 12, 1, -40)
	toggle.Size = UDim2.fromOffset(120, 36)
	toggle.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
	toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggle.Font = Enum.Font.GothamBold
	toggle.TextScaled = true
	toggle.Text = "Inventory"
	toggle.Parent = parent

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 8)
	toggleCorner.Parent = toggle

	toggle.MouseButton1Click:Connect(function()
		panel.Visible = not panel.Visible
	end)

	state.panel = panel
	state.list = list
	state.title = title
end

local function rarityTier(rarity: string?): number
	if not rarity then
		return 0
	end
	local def = (Rarities :: any)[rarity]
	return if def then def.tier else 0
end

local function render(data: any)
	local list = state.list
	local title = state.title
	if not list or not title then
		return
	end
	for _, child in list:GetChildren() do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local items = table.clone(data.inventory or {})
	table.sort(items, function(a, b)
		local defA = Animals[a.creatureId]
		local defB = Animals[b.creatureId]
		local ta = rarityTier(if defA then defA.rarity else nil)
		local tb = rarityTier(if defB then defB.rarity else nil)
		if ta ~= tb then
			return ta > tb
		end
		return (a.acquiredAt or 0) > (b.acquiredAt or 0)
	end)
	title.Text = string.format("Inventory (%d)", #items)

	for i, owned in items do
		local def = Animals[owned.creatureId]
		local rarity = if def then (Rarities :: any)[def.rarity] else nil
		local rarityColor = if rarity then rarity.color else Color3.fromRGB(60, 60, 60)
		local rarityName = if def then def.rarity else "?"
		local displayName = if def then def.name else owned.creatureId

		local row = Instance.new("Frame")
		row.LayoutOrder = i
		row.Size = UDim2.new(1, 0, 0, 36)
		row.BackgroundColor3 = rarityColor
		row.BackgroundTransparency = 0.35
		row.BorderSizePixel = 0
		row.Parent = list

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = row

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -12, 1, 0)
		label.Position = UDim2.fromOffset(8, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 14
		label.Text = string.format(
			"%s%s  [%s]  %s",
			if owned.shiny then "(Shiny) " else "",
			displayName,
			rarityName,
			owned.stage
		)
		label.Parent = row
	end
end

function Inventory.init(): ()
	buildUi(getGui())

	(Remotes.PlayerDataUpdated :: RemoteEvent).OnClientEvent:Connect(function(data)
		if typeof(data) == "table" then
			render(data)
		end
	end)

	task.spawn(function()
		local ok, data = pcall(function()
			return (Remotes.RequestPlayerData :: RemoteFunction):InvokeServer()
		end)
		if ok and typeof(data) == "table" then
			render(data)
		end
	end)
end

return Inventory
