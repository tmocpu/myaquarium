--!strict

local Format = {}

local SUFFIXES = {
	"",
	"K",
	"M",
	"B",
	"T",
	"Qa",
	"Qi",
	"Sx",
	"Sp",
	"Oc",
	"No",
	"Dc",
}

function Format.abbreviate(n: number): string
	if n < 1000 then
		return tostring(math.floor(n))
	end
	local index = math.min(math.floor(math.log10(n) / 3), #SUFFIXES - 1)
	local scaled = n / (1000 ^ index)
	local suffix = SUFFIXES[index + 1]
	if scaled >= 100 then
		return string.format("%d%s", math.floor(scaled), suffix)
	elseif scaled >= 10 then
		return string.format("%.1f%s", scaled, suffix)
	else
		return string.format("%.2f%s", scaled, suffix)
	end
end

function Format.commas(n: number): string
	local formatted = tostring(math.floor(n))
	local k
	repeat
		formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
	until k == 0
	return formatted
end

return Format
