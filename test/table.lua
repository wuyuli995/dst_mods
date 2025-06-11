function table.invert(t)
    local invt = {}
    for k, v in pairs(t) do
        invt[v] = k
    end
    return invt
end

local MOON_PHASE_NAMES =
{
    "new",
    "quarter",
    "half",
    "threequarter",
    "full",
}

local MOON_PHASES = table.invert(MOON_PHASE_NAMES)
local MOON_PHASE_LENGTHS =
{
    [MOON_PHASES.new] =             1,
    [MOON_PHASES.quarter] =         3,
    [MOON_PHASES.half] =            3,
    [MOON_PHASES.threequarter] =    3,
    [MOON_PHASES.full] =            1,
}
local MOON_PHASE_CYCLES = {}
-- Waxing (1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5)
for i = 1, #MOON_PHASE_NAMES do
    for x = 1, MOON_PHASE_LENGTHS[i] do
        table.insert(MOON_PHASE_CYCLES, i)
    end
end

for key, value in pairs(MOON_PHASE_CYCLES) do
    print(key, value)
end
