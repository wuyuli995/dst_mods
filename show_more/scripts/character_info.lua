local Widget = GLOBAL.require "widgets/widget"
local Text = GLOBAL.require "widgets/text"

-- 角色信息：伤害、防御、防水、体温、移速、淘气值
local getCharacterInfo = function ()
    local player = GLOBAL.GetPlayer()
    local runspeed = player.components.locomotor.runspeed
    local damage = player.components.combat.defaultdamage
    local planardamage = 0
    local defense = 0
    local planardefense = 0
    local waterproofer = 0
    local insulator = 0

    -- 装备栏
    if player.components.inventory then
        -- 手部装备
        local handEquipment = player.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
        if handEquipment then
            -- 伤害
            if handEquipment.components.weapon then
                damage = damage + handEquipment.components.weapon.damage
            end

            -- 位面伤害
            if handEquipment.components.planardamage then
                planardamage = handEquipment.components.planardamage:GetDamage()
            end

            -- 移速
            if handEquipment.components.equippable.walkspeedmult then
                runspeed = runspeed + (runspeed * handEquipment.components.equippable.walkspeedmult)
            end
        end

        -- 头部装备
        local headEquipment = player.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HEAD)
        if headEquipment then
            -- 防御
            if headEquipment.components.armor and headEquipment.components.armor:GetPercent() > defense then
                defense = headEquipment.components.armor:GetPercent()
            end

            -- 位面防御
            if headEquipment.components.planardefense and headEquipment.components.planardefense:GetDefense() > planardefense then
                planardefense = headEquipment.components.planardefense:GetDefense()
            end

            -- 防水
            if headEquipment.components.waterproofer and headEquipment.components.waterproofer:GetEffectiveness() > waterproofer then
                waterproofer = headEquipment.components.waterproofer:GetEffectiveness()
            end

            -- 保温
            if headEquipment.components.insulator and headEquipment.components.insulator:GetInsulation() > insulator then
                insulator = headEquipment.components.insulator:GetInsulation()
            end
        end

        -- 身体装备
        local bodyEquipment = player.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BODY)
        if bodyEquipment then
            -- 防御
            if bodyEquipment.components.armor and bodyEquipment.components.armor:GetPercent() > defense then
                defense = bodyEquipment.components.armor:GetPercent()
            end

            -- 位面防御
            if bodyEquipment.components.planardefense and bodyEquipment.components.planardefense:GetDefense() > planardefense then
                planardefense = bodyEquipment.components.planardefense:GetDefense()
            end

            -- 防水
            if bodyEquipment.components.waterproofer and bodyEquipment.components.waterproofer:GetEffectiveness() > waterproofer then
                waterproofer = bodyEquipment.components.waterproofer:GetEffectiveness()
            end

            -- 保温
            if bodyEquipment.components.insulator and bodyEquipment.components.insulator:GetInsulation() > insulator then
                insulator = bodyEquipment.components.insulator:GetInsulation()
            end
        end
    end

    local info = {}
    info["移速: "] = runspeed
    info["伤害: "] = string.format("%.2f + %d", damage, planardamage)
    info["防御: "] = string.format("%.2f + %d", defense, planardefense)
    info["防水: "] = string.format("%d%%", waterproofer)
    info["保温: "] = string.format("%d%%", insulator)

    local str = ""
    for key, value in pairs(info) do
        str = str .. "\n" .. key .. value
    end

    return str
end

local CharacterInfo = Class(Widget, function (self)
    Widget._ctor(self, "CharacterInfo")

    self.text = self:AddChild(Text(GLOBAL.BODYTEXTFONT, 30, getCharacterInfo()))
end)

AddClassPostConstruct("widgets/controls", function (self)
    self.characterInfo = self:AddChild(CharacterInfo())

    -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.characterInfo:SetHAnchor(2)

    -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
    self.characterInfo:SetVAnchor(2)

    -- widget相对原点的偏移量，70，-50表明: 向右70，向下50，第三个参数无意义。
    self.characterInfo:SetPosition(-70, 200, 0)
end)