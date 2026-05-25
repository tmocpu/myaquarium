--!strict

local Services = script:WaitForChild("Services")

local RemoteRouter = require(Services:WaitForChild("RemoteRouter"))
local PingService = require(Services:WaitForChild("PingService"))

PingService.init()
RemoteRouter.init()

print("[Boot] server ready")
