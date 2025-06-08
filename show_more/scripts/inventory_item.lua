local Inv = GLOBAL.require "widgets/inventorybar"
local ItemTile = GLOBAL.require "widgets/itemtile"
local Text = GLOBAL.require "widgets/text"

local function getInventoryItemInfo(item)
    if not item then
        return ""
    end

    local info = {}

    -- 如果物品可食用
    if item.components.edible then
        -- 三维
        local hunger = item.components.edible:GetHunger(item)
        if hunger > 0 then
            info["饥饿: "] = string.format("+%.2f", hunger)
        elseif hunger < 0 then
            info["饥饿: "] = string.format("%.2f", hunger)
        end

        local sanity = item.components.edible:GetSanity(item)
        if sanity > 0 then
            info["精神: "] = string.format("+%2.f", sanity)
        elseif sanity < 0 then
            info["精神: "] = string.format("%2.f", sanity)
        end

        local health = item.components.edible:GetHealth(item)
        if health > 0 then
            info["生命: "] = string.format("+%2.f", health)
        elseif health < 0 then
            info["生命: "] = string.format("%2.f", health)
        end
    end

    -- 保质期
    if item.components.perishable then
        info["保质期: "] = GetPerishremainingTime(item.components.perishable.perishremainingtime)
    end

    -- 武器
    if item.components.weapon then
        info["伤害: "] = string.format("%.2f", item.components.weapon.damage)
    end

    -- 位面伤害
    if item.components.planardamage then
        info["位面伤害: "] = item.components.planardamage:GetDamage()
    end

    -- 防具
    if item.components.armor then
        info["防御: "] = ToPercent(item.components.armor.absorb_percent)
    end

    -- 位面防御
    if item.components.planardefense then
        info["位面防御: "] = item.components.planardefense:GetDefense()
    end
    
    -- 防水
    if item.components.waterproofer then
        info["防水: "] = ToPercent(item.components.waterproofer:GetEffectiveness())
    end

    -- 保温
    if item.components.insulator then
        info["保温: "] = item.components.insulator:GetInsulation()
    end

    -- 使用次数
    if item.components.finiteuses then
        info["次数: "] = item.components.finiteuses:GetUses()
    end

    -- 温度(暖石)
    if item.components.temperature then
        info["温度: "] = string.format("%2.f°C", item.components.temperature:GetCurrent())
    end

    local str = ""
    for key, value in pairs(info) do
        str = str .. "\n" .. key .. value
    end

    return str
end

-- 重写 InventoryBar 的 UpdateCursorText 方法
local updateCursorText = Inv.UpdateCursorText
function Inv:UpdateCursorText()
    if self.actionstringbody.GetStringAdd and self.actionstringbody.SetStringAdd then
        -- 获取光标下的物品描述
        local item = self:GetCursorItem()
        print(item)
    end

    updateCursorText(self)
end

-- 重写 ItemTile 的 GetDescriptionString 方法
local getDescStr = ItemTile.GetDescriptionString
function ItemTile:GetDescriptionString()
    -- 获取原来的描述字符串
    local descStr = getDescStr(self)
    local str = ""

    -- 如果物品存在并有 inventoryitem 组件
    if self.item and self.item.components and self.item.components.inventoryitem then
        str = getInventoryItemInfo(self.item)
    end

    if string.len(str) > 0 then
        descStr = descStr .. str
    end

    return descStr
end