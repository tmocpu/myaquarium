--!strict

local Controllers = script:WaitForChild("Controllers")

local PingController = require(Controllers:WaitForChild("PingController"))

PingController.init()

print("[Boot] client ready")
