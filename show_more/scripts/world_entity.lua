local function getWorldEntityInfo(target)
    local text = ""
    if target.components then
        -- 伤害 如果目标实体有战斗组件，并且默认伤害大于0
        if target.components.combat and target.components.combat.defaultdamage > 0 then
            text = text .. string.format("伤害: %d\n", target.components.combat.defaultdamage)
        end

        -- 血量
        if target.components.health then
            text = text .. string.format("血量: %d / %d\n", target.components.health.currenthealth, target.components.health.maxhealth)
        end

        -- 检查目标实体是否可以生长，并且有目标时间（树）
        if target.components.growable then
            text = text .. string.format("阶段: %d / %d\n", target.components.growable:GetStage(), #target.components.growable.stages)

            if target.components.growable.targettime then
                text = text .. string.format("下一阶段: %d天\n", GetSubTime(target.components.growable.targettime))
            end
        end

        -- 检查目标实体是否可以被采摘，并且有目标时间（树枝、草、浆果、咖啡树）
        if target.components.pickable and target.components.pickable.targettime then
            text = text .. string.format("成熟: %d天\n", GetSubTime(target.components.pickable.targettime))
        end

        -- 检查目标实体是否有晾肉架组件，并且正在晾肉，获取晾肉时间的方法
        if target.components.dryer and target.components.dryer:IsDrying() then
            text = text .. string.format("剩余: %.1f天\n", target.components.dryer:GetTimeToDry() / TUNING.TOTAL_DAY_TIME)
        end

        -- 武器
        if target.components.weapon then
            text = text .. string.format("伤害: %.1f\n", target.components.weapon.damage)
        end

        -- 位面伤害
        if target.components.planardamage and target.components.planardamage:GetDamage() > 0 then
            text = text .. string.format("位面伤害: %d\n", target.components.planardamage:GetDamage())
        end

        -- 防具
        if target.components.armor then
            text = text .. string.format("防御: %s\n", ToPercent(target.components.armor.absorb_percent))
            text = text .. string.format("耐久: %s\n", ToPercent(target.components.armor:GetPercent()))
        end

        -- 位面防御
        if target.components.planardefense and target.components.planardefense:GetDefense() > 0 then
            text = text .. string.format("位面防御: %d\n", target.components.planardefense:GetDefense())
        end

        -- 使用次数
        if target.components.finiteuses then
            text = text .. string.format("次数: %d\n", target.components.finiteuses:GetUses())
        end

        -- 燃料耐久
        if target.components.fueled then
            text = text .. string.format("耐久: %s\n", ToPercent(target.components.fueled:GetPercent()))
        end

        -- 保质期
        if not target.components.health and target.components.perishable then
            text = text .. string.format("保质期: %s\n", GetPerishremainingTime(target.components.perishable.perishremainingtime))
        end

        -- 农作物压力值
        if target.components.farmplantstress then
            local stressPoints = target.components.farmplantstress.stress_points
            text = text .. string.format("压力值: %d\n", stressPoints)
        end

        -- 温度(暖石)
        if target.components.temperature then
            text = text .. string.format("温度: %1.f°C\n", target.components.temperature:GetCurrent())
        end

        -- 烹饪时间
        if target.components.stewer and target.components.stewer:IsCooking() then
            text = text .. string.format("正在烹饪: %s\n", GLOBAL.STRINGS.NAMES[string.upper(target.components.stewer.product)])
            text = text .. string.format("烹饪时间: %d秒\n", target.components.stewer:GetTimeToCook())
        end

        -- 训牛信息(绑定牛铃后或者喂食之后显示)
        if target.components.domesticatable then
            local obedience = RoundToNthDecimal(target.components.domesticatable:GetObedience() * 100, 2)
            local domestication = RoundToNthDecimal(target.components.domesticatable:GetDomestication() * 100, 2)
            if obedience > 0 or (target.components.follower and target.components.follower:GetLeader()) then
                text = text .. string.format("饥饿: %d/%d\n", target.components.hunger.current, target.components.hunger.max)
                text = text .. string.format("顺从: %s%%\n", string.format("%.2f", obedience))
                text = text .. string.format("驯化: %s%%\n", string.format("%.2f", domestication))

                -- 训势
                for key, value in pairs(target.components.domesticatable.tendencies) do
                    if key == GLOBAL.TENDENCY.ORNERY then
                        text = text .. string.format("战牛: %.2f%%\n", value)
                    elseif key == GLOBAL.TENDENCY.RIDER then
                        text = text .. string.format("行牛: %.2f%%\n", value)
                    elseif key == GLOBAL.TENDENCY.PUDGY then
                        text = text .. string.format("肥牛: %.2f%%\n", value)
                    end
                end
            end

            if target.components.domesticatable.domesticated then
                -- 如果已经驯化，则显示是什么类型
            end
        end

    end

    return text
end

-- 鼠标悬浮在物品上
AddClassPostConstruct("widgets/hoverer", function(self)
    local setString = self.text.SetString
    self.text.SetString = function(text, str)
        -- 获取鼠标下的世界实体
        local target = GLOBAL.TheInput:GetWorldEntityUnderMouse()

        if target then
            -- 获取饥荒世界预制物相关信息
            str = str .. "\n" .. getWorldEntityInfo(target)
        end

        return setString(text, str)
    end
end)