--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = require(Shared:WaitForChild("Remotes"))
local Constants = require(Shared:WaitForChild("Constants"))
local Animals = require(Shared:WaitForChild("Config"):WaitForChild("Animals"))
local Rarities = require(Shared:WaitForChild("Config"):WaitForChild("Rarities"))

local IDLE_COLOR = Color3.fromRGB(20, 90, 200)
local DISABLED_COLOR = Color3.fromRGB(60, 60, 60)

local RollButton = {}

local cooldownUntil = 0

local function getGui(): ScreenGui
	local pg = Players.LocalPlayer:WaitForChild("PlayerGui")
	local existing = pg:FindFirstChild("MainHud")
	if existing and existing:IsA("ScreenGui") then
		return existing
	end
	local gui = Instance.new("ScreenGui")
	gui.Name = "MainHud"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = pg
	return gui
end

local function createButton(parent: ScreenGui): TextButton
	local btn = Instance.new("TextButton")
	btn.Name = "RollButton"
	btn.AnchorPoint = Vector2.new(0.5, 1)
	btn.Position = UDim2.new(0.5, 0, 1, -40)
	btn.Size = UDim2.fromOffset(220, 80)
	btn.BackgroundColor3 = IDLE_COLOR
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextScaled = true
	btn.Text = "FISH!"
	btn.Font = Enum.Font.GothamBold
	btn.AutoButtonColor = true
	btn.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 2
	stroke.Parent = btn

	return btn
end

local function showResult(parent: ScreenGui, creature: any)
	local def = Animals[creature.creatureId]
	local rarity = if def then Rarities[def.rarity] else nil
	local color = if rarity then rarity.color else Color3.fromRGB(40, 40, 40)
	local name = if def then def.name else creature.creatureId
	local rarityName = if def then def.rarity else "?"

	local label = Instance.new("TextLabel")
	label.AnchorPoint = Vector2.new(0.5, 1)
	label.Position = UDim2.new(0.5, 0, 1, -140)
	label.Size = UDim2.fromOffset(360, 60)
	label.BackgroundColor3 = color
	label.BackgroundTransparency = 0.2
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Text = string.format(
		"%s%s  [%s]",
		if creature.shiny then "(Shiny) " else "",
		name,
		rarityName
	)
	label.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = label

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 2
	stroke.Parent = label

	task.delay(2.5, function()
		label:Destroy()
	end)
end

local function tryRoll(btn: TextButton, parent: ScreenGui)
	if os.clock() < cooldownUntil then
		return
	end
	cooldownUntil = os.clock() + Constants.ROLL_COOLDOWN_SECONDS
	btn.AutoButtonColor = false
	btn.BackgroundColor3 = DISABLED_COLOR

	local ok, result = pcall(function()
		return (Remotes.Roll :: RemoteFunction):InvokeServer()
	end)

	task.delay(Constants.ROLL_COOLDOWN_SECONDS, function()
		btn.AutoButtonColor = true
		btn.BackgroundColor3 = IDLE_COLOR
	end)

	if not ok then
		warn(`[RollButton] invoke failed: {result}`)
		return
	end
	if typeof(result) ~= "table" or not result.ok then
		local err = if typeof(result) == "table" then result.err else "unknown"
		warn(`[RollButton] roll rejected: {err}`)
		return
	end
	showResult(parent, result.creature)
end

function RollButton.init(): ()
	local gui = getGui()
	local btn = createButton(gui)
	btn.MouseButton1Click:Connect(function()
		tryRoll(btn, gui)
	end)
end

return RollButton
