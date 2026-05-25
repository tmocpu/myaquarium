--!strict

local Controllers = script:WaitForChild("Controllers")
local UI = script:WaitForChild("UI")

local PingController = require(Controllers:WaitForChild("PingController"))
local RollButton = require(UI:WaitForChild("RollButton"))
local Inventory = require(UI:WaitForChild("Inventory"))

PingController.init()
RollButton.init()
Inventory.init()

print("[Boot] client ready")
