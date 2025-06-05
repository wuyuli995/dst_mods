local Inv = GLOBAL.require "widgets/inventorybar"
local ItemTile = GLOBAL.require "widgets/itemtile"
local Text = GLOBAL.require "widgets/text"

local function getInfo(item)
    if not item then
        return ""
    end

    local info = {}

    -- 如果物品可食用
    if item.components.edible then
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
        str = getInfo(self.item)
    end

    if string.len(str) > 0 then
        descStr = descStr .. str
    end

    return descStr
end