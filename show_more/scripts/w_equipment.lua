local equipmentWidget = require "widgets/equipment"

local defaultDamage = 0
local runspeed = 0
local equipWidget = nil

-- 角色初始化之后进行 CharacterInfoWidget 的初始化
AddPlayerPostInit(function(inst)
    defaultDamage = inst.components.combat.defaultdamage
    runspeed = inst.components.locomotor.runspeed
end)

-- 装备栏信息widget
AddClassPostConstruct("widgets/controls", function (self)
    equipWidget = equipmentWidget(runspeed, defaultDamage)
    self.equipmentWidget = self:AddChild(equipWidget)

    -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.equipmentWidget:SetHAnchor(GLOBAL.ANCHOR_RIGHT)

    -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
    self.equipmentWidget:SetVAnchor(GLOBAL.ANCHOR_BOTTOM)

    -- widget相对原点的偏移量，70，-50表明: 向右70，向下50，第三个参数无意义。
    self.equipmentWidget:SetPosition(-130, 35, 0)
end)

-- -- 监听装备栏装备情况
AddComponentPostInit("equippable", function(self)
    if equipWidget == nil then
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
            equipWidget:HandEquipped(inst)
        end

        if equippable.equipslot == GLOBAL.EQUIPSLOTS.HEAD then
            equipWidget:HeadEquipped(inst)
        end

        if equippable.equipslot == GLOBAL.EQUIPSLOTS.BODY then
            equipWidget:BodyEquipped(inst)
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
            equipWidget:HandUnEquipped(inst)
        end

        if equippable.equipslot == GLOBAL.EQUIPSLOTS.HEAD then
            equipWidget:HeadUnEquipped(inst)
        end

        if equippable.equipslot == GLOBAL.EQUIPSLOTS.BODY then
            equipWidget:BodyUnEquipped(inst)
        end
    end)
end)
