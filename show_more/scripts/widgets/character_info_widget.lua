local Widget = require "widgets/widget"
local Text = require "widgets/text"

local CharacterInfoWidget = Class(Widget, function (self, runspeed, damage)
    Widget._ctor(self, "CharacterInfoWidget")

    self.baseRunspeed = runspeed
    self.baseDamage = damage
    self.runspeed = runspeed
    self.damage = damage
    self.planardamage = 0

    -- 头部防御
    self.headDefense = 0
    self.headPlanardefense = 0

    -- 身体防御
    self.bodyDefense = 0
    self.bodyPlanardefense = 0

    -- 头部防水
    self.headWaterproofer = 0

    -- 身体防水
    self.bodyWaterproofer = 0

    -- 手部防水
    self.handWaterproofer = 0

    self.temperature = 0
    self.text = nil

    self:UpdateInfo()
end)

-- 手部装备装备
function CharacterInfoWidget:HandEquipped(handEquipment)
    if handEquipment == nil then
        return
    end

    -- 伤害
    if handEquipment.components.weapon then
        self.damage = handEquipment.components.weapon.damage
    end

    -- 位面伤害
    if handEquipment.components.planardamage then
        self.planardamage = handEquipment.components.planardamage:GetDamage()
    end

    -- 移速
    if handEquipment.components.equippable.walkspeedmult then
        self.runspeed = self.runspeed + (self.baseRunspeed * handEquipment.components.equippable.walkspeedmult)
    end

    -- 防水
    if handEquipment.components.waterproofer then
        self.handWaterproofer = handEquipment.components.waterproofer:GetEffectiveness() * 100
    end

    self:UpdateInfo()
end

-- 手部装备卸下
function CharacterInfoWidget:HandUnEquipped(handEquipment)
    if handEquipment == nil then
        return
    end

    -- 伤害
    if handEquipment.components.weapon then
        self.damage = self.baseDamage
    end

    -- 位面伤害
    if handEquipment.components.planardamage then
        self.planardamage = 0
    end

    -- 移速
    if handEquipment.components.equippable.walkspeedmult then
        self.runspeed = self.baseRunSpeed
    end

    -- 防水
    if handEquipment.components.waterproofer then
        self.handWaterproofer = 0
    end

    self:UpdateInfo()
end

-- 头部装备装备
function CharacterInfoWidget:HeadEquipped(headEquipment)
    if headEquipment == nil then
        return
    end

    -- 防御
    if headEquipment.components.armor then
        self.headDefense = headEquipment.components.armor.absorb_percent * 100
    end

    -- 位面防御
    if headEquipment.components.planardefense then
        self.headPlanardefense = headEquipment.components.planardefense:GetDefense()
    end

    -- 防水
    if headEquipment.components.waterproofer then
        self.headWaterproofer = headEquipment.components.waterproofer:GetEffectiveness() * 100
    end

    self:UpdateInfo()
end

-- 头部装备卸下
function CharacterInfoWidget:HeadUnEquipped(headEquipment)
    if headEquipment == nil then
        return
    end
    
    self.headDefense = 0
    self.headPlanardefense = 0
    self.headWaterproofer = 0

    self:UpdateInfo()
end

-- 身体装备装备
function CharacterInfoWidget:BodyEquipped(headEquipment)
    if headEquipment == nil then
        return
    end

    -- 防御
    if headEquipment.components.armor then
        self.bodyDefense = headEquipment.components.armor.absorb_percent * 100
    end

    -- 位面防御
    if headEquipment.components.planardefense then
        self.bodyPlanardefense = headEquipment.components.planardefense:GetDefense()
    end

    -- 防水
    if headEquipment.components.waterproofer then
        self.bodyWaterproofer = headEquipment.components.waterproofer:GetEffectiveness() * 100
    end

    self:UpdateInfo()
end

-- 身体装备卸下
function CharacterInfoWidget:BodyUnEquipped(headEquipment)
    if headEquipment == nil then
        return
    end
    
    self.bodyDefense = 0
    self.bodyPlanardefense = 0
    self.bodyWaterproofer = 0

    self:UpdateInfo()
end

-- 更新角色温度
function CharacterInfoWidget:UpdateTemperature(temperature)
    self.temperature = temperature

    self:UpdateInfo()
end

-- 获取面板信息
function CharacterInfoWidget:GetInfoText()
    local text = ""
    -- 伤害
    local damageStr = string.format("%d", math.floor(self.damage + 0.5))
    if self.planardamage > 0 then
        damageStr = damageStr .. string.format(" + %d", self.planardamage)
    end
    text = text .. string.format("伤害: %s\n", damageStr)

    -- 防御
    local defense = self.bodyDefense
    if self.headDefense > defense then
        defense = self.headDefense
    end
    local defenseStr = string.format("%d%%", defense)

    -- 位面防御
    local planardefense = self.bodyPlanardefense
    if self.headPlanardefense > self.bodyPlanardefense then
        planardefense = self.headPlanardefense
    end

    if planardefense > 0 then
        defenseStr = defenseStr .. string.format(" + %d", planardefense)
    end

    text = text .. string.format("防御: %s\n", defenseStr)

    -- 移速
    text = text .. string.format("移速: %d\n", self.runspeed)

    -- 防水
    local waterproofer = self.handWaterproofer

    if self.headWaterproofer > waterproofer then
        waterproofer = self.headWaterproofer
    end

    if self.bodyWaterproofer > waterproofer then
        waterproofer = self.bodyWaterproofer
    end
    
    text = text .. string.format("防水: %d%%\n", waterproofer)

    -- 体温
    text = text .. string.format("体温: %d°C\n", self.temperature)

    -- 淘气值

    return text
end

-- 更新面板信息
function CharacterInfoWidget:UpdateInfo()
    local text = self:GetInfoText()
    
    self:KillAllChildren()
    self.text = self:AddChild(Text(BODYTEXTFONT, 20, text))
    self.text:SetVAlign(ANCHOR_BOTTOM)
    self.text:SetHAlign(ANCHOR_LEFT)
end

return CharacterInfoWidget