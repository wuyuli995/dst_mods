local clock = require "widgets/clock"

local clockWidget = nil

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
        if clockWidget == nil then
            return
        end

        print("cycles -->", cycles)
        clockWidget:UpdateCycles(cycles)
    end)

    self.inst:ListenForEvent("moonphasechanged2", function (src, data)
        print("moonphasechanged2 -->", data.moonphase)
    end)
end)

AddClassPostConstruct("widgets/controls", function (self)
    self.clockWidget = self:AddChild(clockWidget)

    -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.clockWidget:SetHAnchor(GLOBAL.ANCHOR_RIGHT)

    -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
    self.clockWidget:SetVAnchor(GLOBAL.ANCHOR_TOP)

    -- widget相对原点的偏移量，70，-50表明: 向右70，向下50，第三个参数无意义。
    self.clockWidget:SetPosition(-180, -100, 0)
end)
