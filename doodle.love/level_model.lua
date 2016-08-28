    this.raw_data = level_model.load(name)
    this.tabletop = level_model.parse(this.raw_data)
    this.player = { } -- TODO Update player tracking by their position
        -- TODO Update function to act according new file model
    local path = "assets/" .. name .. ".yml"
    local outlet = { }
    raw = fh:read("*line")
    while raw ~= "..." do
        stuff = util.split(raw, ":")
        outlet[stuff[1]] = stuff[2]
    end

    fh:close()
    return outlet
end
function level_model.parse(raw)
    local tabletop = { }
    local dx = tonumber(raw["x"])
    local dy = tonumber(raw["y"])
    local line = { }
    local data = " "

    -- placing floor everywheres
    for y = 1, dy do
        line = { }
        for x = 1, dx do
            table.insert(line, "floor")
        table.insert(tabletop, line)
    end
    raw["x"] = nil
    raw["y"] = nil

    -- placing the rest of stuff
    for it, raw_data in pairs(raw) do
        data = util.split(raw_data, " ")
        dx = tonumber(data[1])
        dy = tonumber(data[2])
        tabletop[dy][dx] = it