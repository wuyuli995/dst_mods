local characterInfoWidget = require "widgets/character_info_widget"

local defaultDamage = 0
local runspeed = 0
local ciWidget = nil

-- 角色初始化之后进行 CharacterInfoWidget 的初始化
AddPlayerPostInit(function(inst)
    defaultDamage = inst.components.combat.defaultdamage
    runspeed = inst.components.locomotor.runspeed
    
    -- CharacterInfo.damage = inst.components.combat.defaultdamage
    -- CharacterInfo.runspeed = inst.components.locomotor.runspeed
    -- CharacterInfo.temperature = inst.components.temperature.current
end)

-- 获取角色信息
AddClassPostConstruct("widgets/controls", function (self)
    ciWidget = characterInfoWidget(runspeed, defaultDamage)
    self.characterInfoWidget = self:AddChild(ciWidget)

    -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.characterInfoWidget:SetHAnchor(GLOBAL.ANCHOR_RIGHT)

    -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
    self.characterInfoWidget:SetVAnchor(GLOBAL.ANCHOR_TOP)

    -- widget相对原点的偏移量，70，-50表明: 向右70，向下50，第三个参数无意义。
    self.characterInfoWidget:SetPosition(-180, -100, 0)
end)

-- -- 监听装备栏装备情况
AddClassPostConstruct("components/equippable", function(self)
    if ciWidget == nil then
        return
    end

    self.inst:ListenForEvent("equipped", function (inst, data)
        local owner = data.owner
        if not owner then
            return
        end

        if inst.prefab == nil then
            return
        end

        local equippable = inst.components.equippable
        if equippable.equipslot == GLOBAL.EQUIPSLOTS.HANDS then
            ciWidget:HandEquipped(inst)
        end

        if equippable.equipslot == GLOBAL.EQUIPSLOTS.HEAD then
            ciWidget:HeadEquipped(inst)
        end

        if equippable.equipslot == GLOBAL.EQUIPSLOTS.BODY then
            ciWidget:BodyEquipped(inst)
        end
    end)

    self.inst:ListenForEvent("unequipped", function (inst, data)
        local owner = data.owner
        if not owner then
            return
        end

        if inst.prefab == nil then
            return
        end

        local equippable = inst.components.equippable
        if equippable.equipslot == GLOBAL.EQUIPSLOTS.HANDS then
            ciWidget:HandUnEquipped(inst)
        end

        if equippable.equipslot == GLOBAL.EQUIPSLOTS.HEAD then
            ciWidget:HeadUnEquipped(inst)
        end

        if equippable.equipslot == GLOBAL.EQUIPSLOTS.BODY then
            ciWidget:BodyUnEquipped(inst)
        end
    end)
end)

-- 监听角色温度
AddClassPostConstruct("components/temperature", function(self)
    -- 一秒更新一次
    self.inst:DoPeriodicTask(1, function ()
        if ciWidget == nil then
            return
        end

        ciWidget:UpdateTemperature(self.inst.components.temperature:GetCurrent())
    end)
    
end)