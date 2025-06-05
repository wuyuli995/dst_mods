util = {}

-- 获取剩余时间
function util.GetSubTime(time)
    return string.format("%.2f", ((time - G.GetTime()) / 48) / 10)
end

-- 百分比转换
function util.ToPercent(percent)
    return string.format("%d%%", percent * 100)
end

return util