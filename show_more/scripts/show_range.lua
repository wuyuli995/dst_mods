-- 显示建筑范围
PrefabFiles = { "building_range" }

local function showRange(inst)
    local x, _, z = inst.Transform:GetWorldPosition()
    if inst.building_range == nil then
        inst.building_range = GLOBAL.SpawnPrefab("building_range")
    end

    inst.building_range.Transform:SetPosition(x, 0, z)
end

local function hideRange(inst)
    if inst.building_range and inst.building_range.Remove then
        inst.building_range:Remove()
        inst.building_range = nil
    end
end

-- TODO 部署时显示建筑范围
-- TODO 点击显示/关闭建筑范围

AddPrefabPostInit("lightning_rod", function(inst)
    -- 在避雷针建好之后，给避雷针设置显示范围
    inst:DoTaskInTime(.5, function()
        showRange(inst)
        -- local x, _, z = inst.Transform:GetWorldPosition()
        -- inst.building_range = GLOBAL.SpawnPrefab("building_range")
        -- inst.building_range.Transform:SetPosition(x, 0, z)

        -- 监听建筑物品是否被移除，若移除了范围圈圈也跟着移除
        inst:ListenForEvent("onremove", hideRange)
    end)
end)

-- 点击显示/关闭建筑范围
AddClassPostConstruct("widgets/hoverer", function(self)
    local setString = self.text.SetString
    self.text.SetString = function(text, str)
        -- 获取鼠标下的世界实体
        local target = GLOBAL.TheInput:GetWorldEntityUnderMouse()

        if target then
            GLOBAL.TheInput:AddKeyHandler(function(key, down)
                -- 监听键盘事件
                if down and key == GLOBAL.KEY_R then
                    print("key --> R")
                    showRange(target)
                end
            end)
        end

        return setString(text, str)
    end
end)
