-- 时钟信息

local Widget = require "widgets/widget"
local Text = require "widgets/text"

local MOON_PHASE_NAMES =
{
    "new",
    "quarter",
    "half",
    "threequarter",
    "full",
}
local MOON_PHASE_CYCLES = {1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2}

local Clock = Class(Widget, function (self)
    Widget._ctor(self, "Clock")
    
    self.season = "autumn"
    self.elapseddaysinseason = 0
    self.worldtemperature = 0
    self.springlength = 20
    self.summerlength = 15
    self.autumnlength = 20
    self.winterlength = 15
    self.cycles = 1

    self:UpdateInfo()
end)

function Clock:UpdateSeasonTick(data)
    self.season = data.season
    self.elapseddaysinseason = data.elapseddaysinseason

    self:UpdateInfo()
end

function Clock:SetSeasonLength(data)
    self.springlength = data.spring
    self.summerlength = data.summer
    self.autumnlength = data.autumn
    self.winterlength = data.winter

    self:UpdateInfo()
end

function Clock:UpdateTemperature(temperature)
    self.worldtemperature = temperature

    self:UpdateInfo()
end

function Clock:UpdateCycles(cycles)
    self.cycles = cycles

    self:UpdateInfo()
end

-- 月相信息
local function getMoonPhase(cycles)
    local c = cycles % #MOON_PHASE_CYCLES
    local moonPhase = ""
    if c == 0 then
        moonPhase = string.format("新月: 今晚\n")
    else
        if c <= 10 then
            -- 计算满月
            local fullMoonDays = 10 - c
            if fullMoonDays > 0 then
                moonPhase = string.format("满月: %d天后\n", fullMoonDays)
            else
                moonPhase = string.format("满月: 今晚\n")
            end
        else
            local newMoodDays = #MOON_PHASE_CYCLES - c
            moonPhase = string.format("新月: %d天后\n", newMoodDays)
        end
    end

    return moonPhase
end

-- 获取面板信息
function Clock:GetInfoText()
    local text = ""

    -- 季节 1/14
    local seasonStr = ""
    local seasonLen = 0
    if self.season == "winter" then
        seasonStr = "冬季"
        seasonLen = self.winterlength
    elseif self.season == "spring" then
        seasonStr = "春季"
        seasonLen = self.springlength
    elseif self.season == "summer" then
        seasonStr = "夏季"
        seasonLen = self.summerlength
    else
        seasonStr = "秋季"
        seasonLen = self.autumnlength
    end
    text = text .. string.format("%s  %d/%d\n", seasonStr, self.elapseddaysinseason+1, seasonLen)

    -- 温度
    text = text .. string.format("温度: %d°C\n", self.worldtemperature)

    -- 月相： 新月(1) -> 峨眉月(3) -> 弦月(3) -> 凸月(3) -> 满月(1) -> 凸月(3) -> 弦月(3) -> 峨眉月(3) -> 新月(1)
    -- 新月：%d天后 今晚
    -- 满月：%d天后 今晚
    text = text .. getMoonPhase(self.cycles)

    -- 下雨计时

    return text
end

-- 更新面板信息
function Clock:UpdateInfo()
    local text = self:GetInfoText()
    
    self:KillAllChildren()
    self.text = self:AddChild(Text(BODYTEXTFONT, 25, text))
    self.text:SetVAlign(ANCHOR_BOTTOM)
    self.text:SetHAlign(ANCHOR_LEFT)
end

return Clock