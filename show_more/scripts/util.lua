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