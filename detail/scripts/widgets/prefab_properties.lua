-- Widget 所有widget的祖先类
local Widget = require "widgets/widget"
-- Text类 文本处理
local Text = require "widgets/text"

local PrefabProperties = Class(Widget, function(self, entity)
    Widget._ctor(self, "PrefabProperties")

    -- 添加一个文本变量，接收Text实例
    local properties = {}
    properties["名称"] = entity.prefab

    if entity.components.health then
        properties["生命值"] = string.format("%d/%d", entity.components.health.currenthealth, entity.components.health.maxhealth)
    end

    if entity.components.perishable then
        properties["新鲜度"] = math.floor(entity.components.perishable:GetPercent() * 100) .. "%"
    end

    local props = "属性\n"
    for key, value in pairs(properties) do
        print(key .. ":" .. value)
        props = props .. key .. ":" .. value .. "\n"
    end

    print("props ->", props)

    self.text = self:AddChild(Text(BODYTEXTFONT, 30, props))
end)

return PrefabProperties