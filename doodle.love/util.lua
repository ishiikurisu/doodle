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
    return string.gsub(s, "\n$", "")
end

return util
