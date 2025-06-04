function GetInventoryItemInfo(item)
    if not item then
        return ""
    end

    local info = {}
    local components = item.components

    -- 可食用
    if components.edible then
        local hunger = components.edible:GetHunger(item)
        print(hunger)
    end
end