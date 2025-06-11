-- 角色信息widget

local Widget = require "widgets/widget"
local Text = require "widgets/text"

local CharacterInfo = Class(Widget, function (self)
    Widget._ctor(self, "CharacterInfo")

    -- 体温
    self.temperature = 0

    -- 淘气值
    self.naughtiness = ""

    -- 潮湿度
    self.moisturePercent = 0
    self.isMoisturing = false
    self.isDrying = false

    self:UpdateInfo()
end)

-- 更新角色温度
function CharacterInfo:UpdateTemperature(temperature)
    self.temperature = temperature

    self:UpdateInfo()
end

-- 更新淘气值
function CharacterInfo:UpdateNaughtiness(naughtiness)
    if self.naughtiness == naughtiness then
        return
    end

    self.naughtiness = naughtiness
    self:UpdateInfo()
end

-- 更新潮湿度
function CharacterInfo:UpdateMoisture(moisturePercent, status)
    self.moisturePercent = moisturePercent

    if status > 0 then
        self.isDrying = true
        self.isMoisturing = false
    elseif status < 0 then
        self.isDrying = false
        self.isMoisturing = true
    else
        self.isDrying = false
        self.isMoisturing = false
    end

    self:UpdateInfo()
end

-- 获取面板信息
function CharacterInfo:GetInfoText()
    local text = ""
    -- 体温
    text = text .. string.format("体温: %d°C\n", self.temperature)

    -- 淘气值
    if self.naughtiness ~= "" then
        text = text .. string.format("淘气值: %s\n", self.naughtiness)
    end

    -- 潮湿度
    if self.moisturePercent > 0 then
        local percent = self.moisturePercent * 100
        if self.isMoisturing then
            text = text .. string.format("潮湿度: %d%% ↑\n", percent)
        else
            text = text .. string.format("潮湿度: %d%% ↓\n", percent)
        end
    end

    return text
end

-- 更新面板信息
function CharacterInfo:UpdateInfo()
    local text = self:GetInfoText()
    
    self:KillAllChildren()
    self.text = self:AddChild(Text(BODYTEXTFONT, 20, text))
    self.text:SetVAlign(ANCHOR_BOTTOM)
    self.text:SetHAlign(ANCHOR_LEFT)
end

return CharacterInfo