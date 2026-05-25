--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"))

local PingController = {}

function PingController.init(): ()
	task.spawn(function()
		local clientTime = os.clock()
		local ok, response = pcall(function()
			return (Remotes.Ping :: RemoteFunction):InvokeServer(clientTime)
		end)
		if not ok then
			warn(`[PingController] InvokeServer failed: {response}`)
			return
		end
		if typeof(response) == "table" and response.serverTime then
			local rtt = os.clock() - clientTime
			print(
				`[PingController] pong rtt={string.format("%.3f", rtt)}s schema={response.schemaVersion}`
			)
		else
			warn(`[PingController] unexpected response`)
		end
	end)
end

return PingController
