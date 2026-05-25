--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"))
local AntiExploit = require(script.Parent:WaitForChild("AntiExploit"))

type InvokeHandler = (Player, ...any) -> any
type RateLimit = { key: string, cooldownSeconds: number }

local invokeHandlers: { [string]: InvokeHandler } = {}
local rateLimits: { [string]: RateLimit } = {}

local RemoteRouter = {}

function RemoteRouter.registerInvoke(
	remoteName: string,
	rate: RateLimit?,
	handler: InvokeHandler
): ()
	if invokeHandlers[remoteName] then
		warn(`[RemoteRouter] duplicate handler for "{remoteName}"`)
	end
	invokeHandlers[remoteName] = handler
	if rate then
		rateLimits[remoteName] = rate
	end
end

local function dispatch(remoteName: string, player: Player, ...: any): any
	local rate = rateLimits[remoteName]
	if rate and not AntiExploit.checkRate(player, rate.key, rate.cooldownSeconds) then
		return { ok = false, err = "RateLimited" }
	end
	local handler = invokeHandlers[remoteName]
	if not handler then
		warn(`[RemoteRouter] no handler for "{remoteName}"`)
		return { ok = false, err = "NoHandler" }
	end
	local ok, result = pcall(handler, player, ...)
	if not ok then
		warn(`[RemoteRouter] "{remoteName}" errored: {result}`)
		return { ok = false, err = "Internal" }
	end
	return result
end

function RemoteRouter.init(): ()
	(Remotes.Ping :: RemoteFunction).OnServerInvoke = function(player, ...)
		return dispatch("Ping", player, ...)
	end
end

return RemoteRouter
