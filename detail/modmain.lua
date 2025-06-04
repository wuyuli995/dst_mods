-- local Inv = GLOBAL.require "widgets/inventorybar"

-- -- 获取物品栏物品信息
-- local updateCursorText = Inv.UpdateCursorText
-- function Inv:UpdateCursorText()
--     -- 重写InventoryBar 的 UpdateCursorText 方法
--     if self.actionstringbody.GetStringAdd and self.actionstringbody.SetStringAdd then
--         -- 获取光标下物品的描述
--         print("-->", self:GetCursorItem())
--         GetInventoryItemInfo(self:GetCursorItem())
--     end
    
--     updateCursorText(self)
-- end


-- 鼠标悬浮在物品上
AddClassPostConstruct("widgets/hoverer", function(self)
    local oldSetString = self.text.SetString
    self.text.SetString = function(text, str)
        -- 获取鼠标下的世界实体
        local target = GLOBAL.TheInput:GetWorldEntityUnderMouse()

        if target then
            -- 获取饥荒世界预制物相关信息
            str = str .. GetWorldEntityInfo(target)
        end

        return oldSetString(text, str)
    end
end)
