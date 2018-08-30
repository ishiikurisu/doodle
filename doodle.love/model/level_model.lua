local player_model = require "model/player_model"
local person_model = require "model/person_model"
local door_model = require "model/door_model"
local goal_model = require "model/goal_model"
local box_model = require "model/box_model"
local level_model = { }
level_model.__index = level_model

-- ##########################
-- # CONSTRUCTION FUNCTIONS #
-- ##########################
function level_model:new(name)
    local m = { }

    setmetatable(m, level_model)
    m.tag = name
    m.raw_data = level_model.load(name)
    m.tabletop = level_model.parse(m.raw_data)
    m.dimensions = level_model.find_dimensions(m)
    m.last_moment = 0
    m.last_places = { }
    m.game_over = false
    m.player = { }
    m.people = { }
    m.doors = { }
    m.goal = nil
    m.next_level = nil
    m:find_entities()
    return m
end

function level_model.load(name)
    local path = "assets/" .. name .. ".yml"
    local outlet = { }
    local stuff = { }

    -- Reading and parsing every line
    for raw in love.filesystem.lines(path) do
        if raw == "..." then
            break
        elseif raw == "---" then

        else
            stuff = util.split(raw, ":")
            table.insert(outlet, { util.chomp(stuff[1]),
                                   util.chomp(stuff[2]) })
        end
    end

    return outlet
end

function level_model.parse(raw)
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

function level_model.find_dimensions(model)
    local dimensions = { }
    dimensions.y = #model.tabletop
    dimensions.x = #(model.tabletop[1])
    return dimensions
end

--- Discovers where there are people and objects on raw data
function level_model:find_entities()
    local raw = self.raw_data
    self.player = { }
    self.people = { }
    self.doors = { }
    self.goal = nil

    for _, box in pairs(raw) do
        if box[1] == "player"  then
            self.player = player_model:new(box[2])
        elseif box[1] == "person" then
            table.insert(self.people, person_model:new(box[2]))
        elseif box[1] == "door" then
            table.insert(self.doors, door_model:new(box[2]))
        elseif box[1] == "goal" then
            self.goal = goal_model:new(box[2])
            self.next_level = self.goal.next_level
        end
    end

    return self
end

-- ###################
-- # CLASS FUNCTIONS #
-- ###################

-- ## LOAD FUNCTIONS ##
function level_model:transfer(level)
    self.player.items = level.player.items
    return level
end

-- ####################
-- # UPDATE FUNCTIONS #
-- ####################
-- # Updating environment
function level_model:live(moment)
    local x = self.player.x
    local y = self.player.y
    local dx = 0
    local dy = 0
    local ly = self.dimensions.y
    local lx = self.dimensions.x
    local step = "wall"

    -- TODO make last places live too

    for _, person in pairs(self.people) do
        if person:is_update_time(moment) then
            x, y = person.x, person.y
            dx, dy = self:act_to_effect(person:get_direction())
            if self:is_in_bounds(x, y, dx, dy, lx, ly) then
                step = self.tabletop[y+dy][x+dx]
                if step == "floor" then
                    self.tabletop[y][x] = "floor"
                    self.tabletop[y+dy][x+dx] = "person"
                    person:walk(dx, dy)
                end
            end
        end
    end

    self.last_moment = moment
    return self
end

-- Turning actions into side effects
function level_model:update(act, moment)
    local x = self.player.x
    local y = self.player.y
    local dx = 0
    local dy = 0
    local ly = self.dimensions.y
    local lx = self.dimensions.x
    local step = "wall"

    -- Tries to walk
    if self:is_action(act) then
        x, y = self.player.x, self.player.y
        dx, dy = self:act_to_effect(act)
        self.player:set_direction(act)
        if self:is_in_bounds(x, y, dx, dy, lx, ly) then
            step = self.tabletop[y+dy][x+dx]
            if step == "floor" then
                self.tabletop[y][x] = "floor"
                self.tabletop[y+dy][x+dx] = "player"
                self.player:walk(dx, dy)
            elseif step == "door" then
                return self:walk_through_door(x+dx, y+dy)
            elseif step == "goal" then
                self = self:reach_goal()
            elseif step == "box" then
                self:move_box(x, y, dx, dy, lx, ly)
            end
        end
    -- Tries to pick something up
    elseif act == "space" or act == " " then
        self:pickup_item()
    end

    -- Update structure
    self.last_moment = moment
    return self
end

function level_model:is_action(act)
    local fact = false

    if (act == "left") or (act == "right") or (act == "up") or (act == "down") then
        fact = true
    end

    return fact
end

function level_model:act_to_effect(act)
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

function level_model:pickup_item()
    local lx = self.dimensions.x
    local ly = self.dimensions.y
    local dx = 0
    local dy = 0
    local x = self.player.x
    local y = self.player.y
    local item = " "

    dx, dy = self:act_to_effect(self.player.direction)
    if self:is_in_bounds(x, y, dx, dy, lx, ly) then
        item = self.tabletop[y+dy][x+dx]
        if item == "item" then
            self.player:give_item(item)
            self.tabletop[y+dy][x+dx] = "floor"
        end
    end

end

function level_model:is_in_bounds(x, y, dx, dy, lx, ly)
    local fact = true

    fact = fact and (x + dx > 0)
    fact = fact and (x + dx <= lx)
    fact = fact and (y + dy > 0)
    fact = fact and (y + dy <= ly)

    return fact
end

function level_model:walk_through_door(x, y)
    local level = self

    for _, door in pairs(self.doors) do
        if (door.x == x) and (door.y == y) then
            if self.last_places[door.destiny] == nil then
                level = level_model:new(door.destiny)
            else
                level = self.last_places[door.destiny]
            end
            level.last_places[self.tag] = self
            level:transfer(self)
        end
    end

    return level
end

function level_model:reach_goal()
    local in_possession = self.player:count_items()
    local required = self.goal.required_items

    -- TODO Add game over screen as a level object
    if in_possession >= required then
        self.game_over = true
    end

    return self
end

function level_model:move_box(x, y, dx, dy, lx, ly)
    local step = "wall"
    local further_step = "wall"

    -- Is it within boundaries?
    if self.is_in_bounds(x, y, dx, dy, lx, ly) and self.is_in_bounds(x, y, 2*dx, 2*dy, lx, ly) then
        step = self.tabletop[y+dy][x+dx]
        further_step = self.tabletop[y+2*dy][x+2*dx]
        -- Is it possible to walk?
        if self.tabletop[y+2*dy][x+2*dx] == "floor" then
            self.tabletop[y][x] = "floor"
            self.tabletop[y+dy][x+dx] = "player"
            self.tabletop[y+2*dy][x+2*dx] = "box"
            self.player:walk(dx, dy)
        end
    end

    return self
end

-- #####################
-- # DRAWING FUNCTIONS #
-- #####################
function level_model:draw()
    local outlet = ""

    for _, line in pairs(self.tabletop) do
        for _, it in pairs(line) do
            outlet = outlet .. it .. " "
        end
        outlet = outlet .. "\n"
    end

    return outlet
end

function level_model:create_board()
    local outlet = self.tabletop

    -- TODO Ask sprite for each entity
    outlet[self.player.y][self.player.x] = self.player:draw()

    return outlet
end

return level_model
