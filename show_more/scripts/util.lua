-- 获取剩余时间
function GetSubTime(time)
    return string.format("%.1f", (time - GLOBAL.GetTime()) / TUNING.TOTAL_DAY_TIME)
end

-- 百分比转换
function ToPercent(percent)
    return string.format("%d%%", percent * 100)
end

-- 获取保质期
function GetPerishremainingTime(perishremainingtime)
    return string.format("%.1f天", (perishremainingtime / TUNING.TOTAL_DAY_TIME))
end

-- 四舍五入到指定小数位
function RoundToNthDecimal(num, n)
    local mult = 10^(n or 0)
    return math.floor(num * mult + 0.5) / mult
end