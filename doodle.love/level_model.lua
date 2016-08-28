local player_model = require "player_model"
local person_model = require "person_model"
local door_model = require "door_model"
local util = require "util"
local level_model = { }

function level_model.new(name)
    local self = { }
    self.raw_data = level_model.load(name)
    self.tabletop = level_model.parse(self, self.raw_data)
    self.dimensions = level_model.find_dimensions(self)
    self.last_moment = 0
    self = level_model.find_entities(self, self.raw_data)

    -- ######################
    -- # UPDATING FUNCTIONS #
    -- ######################
    self.update = function(act, moment)
        local x = self.player.x
        local y = self.player.y
        local dx = 0
        local dy = 0
        local ly = self.dimensions.y
        local lx = self.dimensions.x
        local step = "wall"

        -- # Updating environment
        -- TODO Make people walk without the user action
        for _, person in pairs(self.people) do
            if person.is_update_time(moment) then
                x, y = person.x, person.y
                dx, dy = self.act_to_effect(person.get_direction())
                if self.is_in_bounds(x, y, dx, dy, lx, ly) then
                    step = self.tabletop[y+dy][x+dx]
                    if step == "floor" then
                        self.tabletop[y][x] = "floor"
                        self.tabletop[y+dy][x+dx] = "person"
                        person.walk(dx, dy)
                    end
                end
            end
        end
         
        -- # Turning actions into side effects
        -- ## Tries to walk
        step = "wall"
        if (act == "left") or (act == "right") or (act == "up") or (act == "down") then
            x, y = self.player.x, self.player.y
            dx, dy = self.act_to_effect(act)
            self.player.set_direction(act)
            if self.is_in_bounds(x, y, dx, dy, lx, ly) then
                step = self.tabletop[y+dy][x+dx]
                if step == "floor" then
                    self.tabletop[y][x] = "floor"
                    self.tabletop[y+dy][x+dx] = "player"
                    self.player.walk(dx, dy)
                elseif step == "door" then
                    -- TODO store previous level data
                    -- TODO make player appear out of a door
                    return self.walk_through_door(x+dx, y+dy)
                end
            end
        -- ## Tries to pick something up
        elseif act == "space" or act == " " then
            self.pickup_item()
        end

        -- Update structure
        self.last_moment = moment
        
        return self
    end

    self.act_to_effect = function(act)
        local dx = 0
        local dy = 0

        if act == "up" then
            dy = -1
        elseif act == "down" then
            dy = 1
        elseif act == "left" then
            dx = -1
        elseif act == "right" then
            dx = 1
        end

        return dx, dy
    end

    self.pickup_item = function()
        local dx = 0
        local dy = 0
        local x = self.player.x
        local y = self.player.y
        local item = " "

        dx, dy = self.act_to_effect(self.player.direction)
        if self.is_in_bounds(x, y, dx, dy, self.dimensions.x, self.dimensions.y) then
            item = self.tabletop[y+dy][x+dx]
            if item == "item" then
                self.player.give_item(item)
                self.tabletop[y+dy][x+dx] = "floor"
            end
        end

    end

    self.is_in_bounds = function(x, y, dx, dy, lx, ly)
        local fact = true

        fact = fact and (x + dx > 0)
        fact = fact and (x + dx <= lx)
        fact = fact and (y + dy > 0)
        fact = fact and (y + dy <= ly)

        return fact
    end
    
    self.walk_through_door = function(x, y)
        local level = self
        
        for _, door in pairs(self.doors) do
            if (door.x == x) and (door.y == y) then
                level = level_model.new(door.destiny)
            end
        end 
        
        return level
    end

    -- #####################
    -- # DRAWING FUNCTIONS #
    -- #####################
    self.draw = function()
        local outlet = ""

        for _, line in ipairs(self.tabletop) do
            for _, it in pairs(line) do
                outlet = outlet .. it .. " "
            end
            outlet = outlet .. "\n"
        end

        return outlet
    end

    return self
end

-- #########################
-- # CONSTRUCTOR FUNCTIONS #
-- #########################
function level_model.load(name)
    local path = "assets/" .. name .. ".yml"
    local fh = io.open(path)
    local raw = fh:read("*line")
    local outlet = { }

    -- Reading and parsing every line
    raw = fh:read("*line")
    while raw ~= "..." do
        stuff = util.split(raw, ":")
        table.insert(outlet, { util.chomp(stuff[1]), util.chomp(stuff[2]) })
        raw = fh:read("*line")
    end

    fh:close()
    return outlet
end

function level_model.parse(self, raw)
    local tabletop = { }
    local line = { }
    local dx = 0
    local dy = 0

    -- Get dimensions
    for _, box in pairs(raw) do
        if box[1] == "x" then
            dx = tonumber(box[2])
        elseif box[1] == "y" then
            dy = tonumber(box[2])
        end
    end
    
    -- Creating tabletop with provided dimensions
    for _ = 1, dy do
        line = { }
        for _ = 1, dx do
            table.insert(line, "floor")
        end
        table.insert(tabletop, line)
    end

    -- Place stuff
    for _, box in pairs(raw) do
        if (box[1] ~= "x") and (box[1] ~= "y") then
            -- parse location
            line = util.split(box[2], " ")
            dx = tonumber(line[1])
            dy = tonumber(line[2])
            -- store thing in memory
            tabletop[dy][dx] = box[1]
        end
    end

    return tabletop
end

function level_model.find_dimensions(self)
    local dimensions = { }
    dimensions.y = #self.tabletop
    dimensions.x = #(self.tabletop[1])
    return dimensions
end

--- Discovers where there are people and objects on raw data
function level_model.find_entities(self, raw)
    self.player = { }
    self.people = { }
    self.doors = { }
    
    for _, box in pairs(raw) do
        if box[1] == "player"  then
            self.player = player_model.new(box[2])
        elseif box[1] == "person" then
            table.insert(self.people, person_model.new(box[2]))
        elseif box[1] == "door" then
            table.insert(self.doors, door_model.new(box[2]))
        end
    end
    
    return self
end

return level_model