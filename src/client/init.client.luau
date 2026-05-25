--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Greeting = require(Shared:WaitForChild("Greeting"))

print(Greeting.hello("client"))
