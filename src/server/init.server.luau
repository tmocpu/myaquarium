--!strict

local Services = script:WaitForChild("Services")

local RemoteRouter = require(Services:WaitForChild("RemoteRouter"))
local DataService = require(Services:WaitForChild("DataService"))
local InventoryService = require(Services:WaitForChild("InventoryService"))
local RollService = require(Services:WaitForChild("RollService"))
local PingService = require(Services:WaitForChild("PingService"))

-- Order matters: services register handlers, then RemoteRouter binds OnServerInvoke.
DataService.init()
InventoryService.init()
RollService.init()
PingService.init()
RemoteRouter.init()

print("[Boot] server ready")
