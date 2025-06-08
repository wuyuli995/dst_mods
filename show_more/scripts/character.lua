local characterWidget = require "widgets/character_info_widget"

CharacterInfo = {
   runspeed = 0,
   damage = 0,
   planardamage = 0,
   defense = 0,
   planardefense = 0,
   waterproofer = 0,
   insulator = 0,
   temperature = 0
}

-- 获取角色信息
AddClassPostConstruct("widgets/controls", function (self)
    self.characterWidget = self:AddChild(characterWidget())

    -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.characterWidget:SetHAnchor(1)

    -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
    self.characterWidget:SetVAnchor(2)

    -- widget相对原点的偏移量，70，-50表明: 向右70，向下50，第三个参数无意义。
    self.characterWidget:SetPosition(100, 100, 0)
end)

AddPlayerPostInit(function(inst)
    CharacterInfo.damage = inst.components.combat.defaultdamage
    CharacterInfo.runspeed = inst.components.locomotor.runspeed
    CharacterInfo.temperature = inst.components.temperature.current
end)

-- -- 监听装备栏装备情况
AddClassPostConstruct("components/equippable", function(self)
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
            characterWidget:UpdateHandEquipmentInfo(inst)
        end

        -- if inst.prefab ~= nil and (inst.components.weapon or inst.components.armor) then
        --     print("equipped ->", inst.prefab)

        --     local handEquipment = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
        --     if handEquipment then
        --         characterInfo:UpdateHandEquipmentInfo(handEquipment)
        --     end
        -- end
    end)

    self.inst:ListenForEvent("unequipped", function (inst, data)
        if inst.prefab and (inst.components.weapon or inst.components.armor) then
            print("unequipped ->", inst.prefab)
        end
    end)
end)
