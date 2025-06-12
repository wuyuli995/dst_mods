local characterInfo = require "widgets/character_info"

local ciWidget = nil

AddClassPostConstruct("widgets/controls", function (self)
    ciWidget = characterInfo()
    self.characterInfoWidget = self:AddChild(ciWidget)

    -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.characterInfoWidget:SetHAnchor(GLOBAL.ANCHOR_LEFT)

    -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
    self.characterInfoWidget:SetVAnchor(GLOBAL.ANCHOR_BOTTOM)

    -- widget相对原点的偏移量，70，-50表明: 向右70，向下50，第三个参数无意义。
    self.characterInfoWidget:SetPosition(70, 30, 0)
end)

-- 监听角色温度
AddComponentPostInit("temperature", function(self)
    -- 一秒更新一次
    self.inst:DoPeriodicTask(1, function ()
        if ciWidget == nil then
            return
        end

        ciWidget:UpdateTemperature(self.inst.components.temperature:GetCurrent())
    end)
end)

-- 淘气值
AddComponentPostInit("kramped", function(self)
    self.inst:DoPeriodicTask(1, function ()
        if ciWidget == nil then
            return
        end

        local debugStr = self:GetDebugString()
        local naughtiness = string.match(debugStr, "%d+ / %d+")
        if naughtiness then
            ciWidget:UpdateNaughtiness(naughtiness)
        end
    end)

    self.inst:ListenForEvent("ms_playerjoined", function (world, player)
        world:ListenForEvent("killed", function (killer, data)
            if ciWidget == nil then
                return
            end

            local debugStr = self:GetDebugString()
            local naughtiness = string.match(debugStr, "%d+ / %d+")
            if naughtiness then
                ciWidget:UpdateNaughtiness(naughtiness)
            end
        end, player)
    end, self.inst)
end)

-- 潮湿度
AddComponentPostInit("moisture", function (self)
    self.inst:ListenForEvent("moisturedelta", function (player, data)
        if ciWidget == nil then
            return
        end

        if data.old - data.new ~= 0 then
            ciWidget:UpdateMoisture(self:GetMoisturePercent(), data.old - data.new)
        end
    end)
end)
