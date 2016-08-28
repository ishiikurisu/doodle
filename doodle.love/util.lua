local util = { }

function util.split(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t = {}
    local i = 1

    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end

    return t
end

function util.chomp(inlet)
    local left = 1
    local right = #inlet

    while string.byte(inlet, left) == ' ' do
        print(inlet[left])
        left = left + 1
    end


    while inlet[right] == " " do
        right = right - 1
    end

    return string.sub(inlet, left, right)
end

return util
