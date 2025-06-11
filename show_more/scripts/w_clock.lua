local clock = require "widgets/clock"

local clockWidget = nil
local MOON_PHASE_NAMES =
{
    "new",
    "quarter",
    "half",
    "threequarter",
    "full",
}
local MOON_PHASE_CYCLES = {1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2}

AddComponentPostInit("worldstate", function(self)
    clockWidget = clock()
    clockWidget:UpdateTemperature(self.data.temperature)

    self.inst:ListenForEvent("temperaturetick", function (src, temperature)
        if clockWidget == nil then
            return
        end

        clockWidget:UpdateTemperature(temperature)
    end)

    self.inst:ListenForEvent("seasonlengthschanged", function (src, data)
        if clockWidget == nil then
            return
        end

        clockWidget:SetSeasonLength(data)
    end)

    self.inst:ListenForEvent("seasontick", function (src, data)
        if clockWidget == nil then
            return
        end

        clockWidget:UpdateSeasonTick(data)
    end)

    self.inst:ListenForEvent("cycleschanged", function (src, cycles)
        -- (1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5)
        local moonPhaseCycles = MOON_PHASE_CYCLES[cycles+1]
        print("月相 =====>", MOON_PHASE_NAMES[moonPhaseCycles])

        if clockWidget == nil then
            return
        end

        clockWidget:UpdateCycles(cycles+1)
    end)
end)

AddClassPostConstruct("widgets/controls", function (self)
    self.clockWidget = self:AddChild(clockWidget)

    -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.clockWidget:SetHAnchor(GLOBAL.ANCHOR_RIGHT)

    -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
    self.clockWidget:SetVAnchor(GLOBAL.ANCHOR_TOP)

    -- widget相对原点的偏移量，70，-50表明: 向右70，向下50，第三个参数无意义。
    self.clockWidget:SetPosition(-180, -40, 0)
end)
