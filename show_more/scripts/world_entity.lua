-- 获取剩余时间
local function getSubTime(time)
    return string.format("%.2f", ((time - GLOBAL.GetTime()) / 48) / 10)
end

-- 百分比转换
local function toPercentStr(percent)
    return string.format("%d%%", percent * 100)
end

local function getInfo(target)
    local info = {}
    if target.components then
        -- 血量
        if target.components.health then
            info["血量: "] = string.format("%s/%s", target.components.health.currenthealth, target.components.health.maxhealth)
        end

        -- 伤害 如果目标实体有战斗组件，并且默认伤害大于0
        if target.components.combat and target.components.combat.defaultdamage > 0 then
            info["伤害: "] = target.components.combat.defaultdamage
        end

        -- 检查目标实体是否可以生长，并且有目标时间（树）
        if target.components.growable and target.components.growable.targettime then
            -- GLOBAL.GetTime() 获取饥荒世界当前的时间
            info["阶段: "] = string.format("%d / %d",target.components.growable:GetStage(), #target.components.growable.stages)
            info["下一阶段: "] = getSubTime(target.components.growable.targettime) .. "天"
        end

        -- 检查目标实体是否可以被采摘，并且有目标时间（树枝、草、浆果、咖啡树）
        if target.components.pickable and target.components.pickable.targettime then
            info["成熟: "] = getSubTime(target.components.pickable.targettime) .. "天"
        end

        -- 检查目标实体是否有晾肉架组件，并且正在晾肉，获取晾肉时间的方法
        if target.components.dryer and target.components.dryer:IsDrying() then
            info["剩余: "] = string.format("%.2f", target.components.dryer:GetTimeToDry() / TUNING.TOTAL_DAY_TIME) .. "天"
        end

        -- 武器
        if target.components.weapon then
            info["伤害: "] = string.format("%.2f", target.components.weapon.damage)
        end

        -- 位面伤害
        if target.components.planardamage then
            info["位面伤害: "] = target.components.planardamage:GetDamage()
        end

        -- 防具
        if target.components.armor then
            info["防御: "] = toPercentStr(target.components.armor.absorb_percent)
            info["耐久: "] = toPercentStr(target.components.armor:GetPercent())
        end

        -- 位面防御
        if target.components.planardefense then
            info["位面防御: "] = target.components.planardefense:GetDefense()
        end

        -- 使用次数
        if target.components.finiteuses then
            info["次数: "] = target.components.finiteuses:GetUses()
        end

        -- 燃料耐久
        if target.components.fueled then
            info["耐久: "] = toPercentStr(target.components.fueled:GetPercent())
        end

        -- 防水
        -- if target.components.waterproofer then
        --     info["防水: "] = toPercentStr(target.components.waterproofer:GetEffectiveness())
        -- end

        -- 保温
        -- if target.components.insulator then
        --     info["保温: "] = target.components.insulator:GetInsulation()
        -- end

        -- 新鲜度
        if not target.components.health and target.components.perishable then
            info["新鲜度: "] = toPercentStr(target.components.perishable:GetPercent())
        end

        -- 农作物压力值
        if target.components.farmplantstress then
            local stressPoints = target.components.farmplantstress.stress_points
            info["压力值: "] = stressPoints
        end

        -- if target.components.inventory and target.components.equippable then
        --     -- 手部装备
        --     local handEquipment = target.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
        --     print("hand -->", handEquipment)
        --     if handEquipment then
        --         info["伤害: "] = handEquipment.components.weapon.damage
        --         info["耐久: "] = toPercentStr(handEquipment.components.finiteuses:GetPercent())

        --         -- 攻击方式
        --         if handEquipment.components.weapon:CanRangedAttack() then
        --             info["攻击方式: "] = "远程"
        --         else
        --             info["攻击方式: "] = "近战"
        --         end
        --     end

        --     -- 头部装备
        --     local headEquipment = target.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HEAD)
        --     print("head -->", headEquipment)
        --     if headEquipment then
        --         -- 防御
        --         info["防御: "] = toPercentStr(headEquipment.components.armor.absorb_percent)
        --         info["耐久: "] = toPercentStr(headEquipment.components.armor:GetPercent())
        --     end

        --     -- 修复
        --     if target.components.repairable then
        --         info["修复: "] = target.components.repairable.repairmaterial
        --     end
        -- end

    end

    local str = ""
    for key, value in pairs(info) do
        str = str .. "\n" .. key .. value
    end

    return str
end

-- 鼠标悬浮在物品上
AddClassPostConstruct("widgets/hoverer", function(self)
    local setString = self.text.SetString
    self.text.SetString = function(text, str)
        -- 获取鼠标下的世界实体
        local target = GLOBAL.TheInput:GetWorldEntityUnderMouse()

        if target then
            -- 获取饥荒世界预制物相关信息
            str = str .. getInfo(target)
        end

        return setString(text, str)
    end
end)