--!strict

local Greeting = {}

function Greeting.hello(who: string): string
	return `hello from {who}`
end

return Greeting
