--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Constants"))
local RemoteRouter = require(script.Parent:WaitForChild("RemoteRouter"))

local PingService = {}

function PingService.init(): ()
	RemoteRouter.registerInvoke(
		"Ping",
		{ key = "Ping", cooldownSeconds = 0.5 },
		function(_player, clientTime: number)
			return {
				pong = clientTime,
				serverTime = os.clock(),
				schemaVersion = Constants.SCHEMA_VERSION,
			}
		end
	)
end

return PingService
