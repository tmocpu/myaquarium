--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local IS_SERVER = RunService:IsServer()
local FOLDER_NAME = "Remotes"

local folder: Folder
if IS_SERVER then
	local existing = ReplicatedStorage:FindFirstChild(FOLDER_NAME)
	if existing and existing:IsA("Folder") then
		folder = existing
	else
		folder = Instance.new("Folder")
		folder.Name = FOLDER_NAME
		folder.Parent = ReplicatedStorage
	end
else
	folder = ReplicatedStorage:WaitForChild(FOLDER_NAME) :: Folder
end

local function ensureRemote(name: string, className: "RemoteEvent" | "RemoteFunction"): Instance
	if IS_SERVER then
		local existing = folder:FindFirstChild(name)
		if existing then
			return existing
		end
		local r = Instance.new(className)
		r.Name = name
		r.Parent = folder
		return r
	else
		return folder:WaitForChild(name)
	end
end

local Remotes = {
	Ping = ensureRemote("Ping", "RemoteFunction") :: RemoteFunction,
}

return Remotes
