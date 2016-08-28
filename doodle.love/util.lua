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
    local it = string.gsub(inlet, "%s+$", "")
    return string.gsub(it, "^%s+", "")
end

return util
