-- 四舍五入到指定小数位
function RoundToNthDecimal(num, n)
    local mult = 10^(n or 0)
    return math.floor(num * mult + 0.5) / mult
end

local x = RoundToNthDecimal(0.006, 2)
print(x)