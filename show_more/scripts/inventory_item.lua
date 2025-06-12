local Inv = GLOBAL.require "widgets/inventorybar"
local ItemTile = GLOBAL.require "widgets/itemtile"
local Text = GLOBAL.require "widgets/text"

local function getInventoryItemInfo(item)
    if not item then
        return ""
    end

    local text = ""

    -- 如果物品可食用
    if item.components.edible then
        -- 三维
        local hunger = item.components.edible:GetHunger(item)
        if hunger > 0 then
            text = text .. string.format("饥饿: +%.1f\n", hunger)
        elseif hunger < 0 then
            text = text .. string.format("饥饿: %.1f\n", hunger)
        end

        local sanity = item.components.edible:GetSanity(item)
        if sanity > 0 then
            text = text .. string.format("精神: +%.1f\n", sanity)
        elseif sanity < 0 then
            text = text .. string.format("精神: %.1f\n", sanity)
        end

        local health = item.components.edible:GetHealth(item)
        if health > 0 then
            text = text .. string.format("生命: +%.1f\n", health)
        elseif health < 0 then
            text = text .. string.format("生命: %.1f\n", health)
        end
    end

    -- 保质期
    if item.components.perishable then
        text = text .. string.format("保质期: %s\n", GetPerishremainingTime(item.components.perishable.perishremainingtime))
    end

    -- 武器
    if item.components.weapon then
        text = text .. string.format("伤害: %.1f\n", item.components.weapon.damage)
    end

    -- 位面伤害
    if item.components.planardamage then
        text = text .. string.format("位面伤害: %d\n", item.components.planardamage:GetDamage())
    end

    -- 防具
    if item.components.armor then
        text = text .. string.format("防御: %s\n", ToPercent(item.components.armor.absorb_percent))
    end

    -- 位面防御
    if item.components.planardefense then
        text = text .. string.format("位面防御: %d\n", item.components.planardefense:GetDefense())
    end
    
    -- 防水
    if item.components.waterproofer then
        text = text .. string.format("防水: %s\n", ToPercent(item.components.waterproofer:GetEffectiveness()))
    end

    -- 保温
    if item.components.insulator then
        text = text .. string.format("保温: %d\n", item.components.insulator:GetInsulation())
    end

    -- 使用次数
    if item.components.finiteuses then
        text = text .. string.format("次数: %d\n", item.components.finiteuses:GetUses())
    end

    -- 温度(暖石)
    if item.components.temperature then
        text = text .. string.format("温度: %1.f°C\n", item.components.temperature:GetCurrent())
    end

    return text
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
        descStr = descStr .. "\n" .. str
    end

    return descStr
end