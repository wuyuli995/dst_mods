-- 显示建筑范围

PrefabFiles = { "building_range" }

-- 部署时显示建筑范围
AddPrefabPostInit("lightning_rod", function(inst)
    local x, _, z = inst.Transform:GetWorldPosition()
    local buildingRange = GLOBAL.SpawnPrefab("building_range")
    buildingRange.Transform:SetPosition(x, 0, z)

    -- if not self.inst.components.deployhelper then
    --     self.inst:AddComponent("deployhelper")
    --     self.inst.components.deployhelper.onenablehelper = OnEnableHelper
    -- end
end)

-- 显示建筑范围
-- AddClassPostConstruct("widgets/hoverer", function(self)
--     local setString = self.text.SetString
--     self.text.SetString = function(text, str)
--         -- 获取鼠标下的世界实体
--         local target = GLOBAL.TheInput:GetWorldEntityUnderMouse()
--         if target then
--             if target.prefab == "lightning_rod" and not target.components.deployhelper then
--                 target:AddComponent("deployhelper")
--                 target.components.deployhelper.onenablehelper = OnEnableHelper
--             end
--         end

--         return setString(text, str)
--     end
-- end)