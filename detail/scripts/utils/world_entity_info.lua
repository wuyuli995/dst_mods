
-- 获取剩余时间
local function getSubTime(time)
    return string.format("%.2f", ((time - GLOBAL.GetTime()) / 48) / 10)
end

function GetWorldEntityInfo(target)
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

    end

    local str = ""
    for key, value in pairs(info) do
        str = str .. "\n" .. key .. value
    end

    return str
end