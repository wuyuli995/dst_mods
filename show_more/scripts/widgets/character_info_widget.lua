local Widget = require "widgets/widget"
local Text = require "widgets/text"

-- 角色信息：伤害、防御、防水、体温、移速、淘气值
local function initCharacterInfo()
    local player = ThePlayer
    local info = {
        runspeed = player.components.locomotor.runspeed,
        damage = player.components.combat.defaultdamage,
        planardamage = 0,
        defense = 0,
        planardefense = 0,
        waterproofer = 0,
        insulator = 0
    }

    -- 装备栏
    if player.components.inventory then
        -- 手部装备
        local handEquipment = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        print("handEquipment ->", handEquipment)
        if handEquipment then
            -- 伤害
            if handEquipment.components.weapon then
                info.damage = info.damage + handEquipment.components.weapon.damage
            end

            -- 位面伤害
            if handEquipment.components.planardamage then
                info.planardamage = handEquipment.components.planardamage:GetDamage()
            end

            -- 移速
            if handEquipment.components.equippable.walkspeedmult then
                info.runspeed = info.runspeed + (info.runspeed * handEquipment.components.equippable.walkspeedmult)
            end
        end

        -- 头部装备
        local headEquipment = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        print("headEquipment ->", headEquipment)
        if headEquipment then
            -- 防御
            if headEquipment.components.armor and headEquipment.components.armor:GetPercent() > defense then
                info.defense = headEquipment.components.armor:GetPercent()
            end

            -- 位面防御
            if headEquipment.components.planardefense and headEquipment.components.planardefense:GetDefense() > planardefense then
                info.planardefense = headEquipment.components.planardefense:GetDefense()
            end

            -- 防水
            if headEquipment.components.waterproofer and headEquipment.components.waterproofer:GetEffectiveness() > waterproofer then
                info.waterproofer = headEquipment.components.waterproofer:GetEffectiveness()
            end

            -- 保温
            if headEquipment.components.insulator and headEquipment.components.insulator:GetInsulation() > insulator then
                info.insulator = headEquipment.components.insulator:GetInsulation()
            end
        end

        -- 身体装备
        local bodyEquipment = player.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
        print("bodyEquipment ->", bodyEquipment)
        if bodyEquipment then
            -- 防御
            if bodyEquipment.components.armor and bodyEquipment.components.armor:GetPercent() > defense then
                info.defense = bodyEquipment.components.armor:GetPercent()
            end

            -- 位面防御
            if bodyEquipment.components.planardefense and bodyEquipment.components.planardefense:GetDefense() > planardefense then
                info.planardefense = bodyEquipment.components.planardefense:GetDefense()
            end

            -- 防水
            if bodyEquipment.components.waterproofer and bodyEquipment.components.waterproofer:GetEffectiveness() > waterproofer then
                info.waterproofer = bodyEquipment.components.waterproofer:GetEffectiveness()
            end

            -- 保温
            if bodyEquipment.components.insulator and bodyEquipment.components.insulator:GetInsulation() > insulator then
                info.insulator = bodyEquipment.components.insulator:GetInsulation()
            end
        end
    end

    return info
end

local CharacterInfoWidget = Class(Widget, function (self)
    Widget._ctor(self, "CharacterInfo")

    self:UpdateText()
end)

-- 更新手部装备信息
function CharacterInfoWidget:UpdateHandEquipmentInfo(handEquipment)
    -- 伤害
    if handEquipment.components.weapon then
        CharacterInfo.damage = CharacterInfo.damage + handEquipment.components.weapon.damage
    end

    -- 位面伤害
    if handEquipment.components.planardamage then
        CharacterInfo.planardamage = handEquipment.components.planardamage:GetDamage()
    end

    -- 移速
    if handEquipment.components.equippable.walkspeedmult then
        CharacterInfo.runspeed = CharacterInfo.runspeed + (CharacterInfo.runspeed * handEquipment.components.equippable.walkspeedmult)
    end

    self:UpdateText()
end

-- 更新头部装备信息

-- 更新身体装备信息

-- 更新角色温度
function CharacterInfoWidget:UpdateTemperature(temperature)
    
end

-- 更新面板
function CharacterInfoWidget:UpdateText()
    local text = ""
    -- 体温

    -- 伤害
    local damageStr = string.format("%.2f", self.damage)
    if self.planardamage > 0 then
        damageStr = damageStr .. string.format("+ %d", self.planardamage)
    end
    text = text .. string.format("伤害: %s\n", damageStr)

    -- 防御
    local defenseStr = string.format("%.2f", self.defense)
    if self.planardefense > 0 then
        defenseStr = defenseStr .. string.format("+ %d", self.planardefense)
    end
    text = text .. string.format("防御: %s\n", defenseStr)

    -- 移速
    text = text .. string.format("移速: %d\n", self.runspeed)

    -- 防水
    text = text .. string.format("防水: %d\n", self.waterproofer)

    -- 保温
    text = text .. string.format("保温: %d\n", self.insulator)

    self.text = self:AddChild(Text(BODYTEXTFONT, 30, text))
end

return CharacterInfoWidget