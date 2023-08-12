require ".inventoryUtils"
require ".utils"

items_valuable = {"minecraft:coal_ore", "minecraft:deepslate_coal_ore", "minecraft:iron_ore", "minecraft:deepslate_iron_ore", "minecraft:gold_ore", "minecraft:deepslate_gold_ore", "minecraft:diamond_ore", "minecraft:deepslate_diamond_ore", "create:zinc_ore"}
path = {}
mk = 0

function refuel ()
    if turtle.getFuelLevel() <= 80 then
        for i=1, 16, 1 do
            item = turtle.getItemDetail(i)
            if item then
                if item.name == "minecraft:coal" or item.name == "modern_industrialization:lignite_coal" then
                    turtle.select(i)
                    turtle.refuel()
                end
            end
        end
    end
end

function setup (direction, down)
    -- face direction
    if direction == "w" then
        turtle.turnLeft()
    elseif direction == "e" then
        turtle.turnRight()
    elseif direction == "s" then
        turtle.turnRight()
        turtle.turnRight()
    end

    -- move one
    turtle.forward()
end

function mv_back ()
    print(path[#path])
    if path[#path] == "front" then
        turtle.back()
        table.remove(path, #path)
        if path[#path] == "right" then
            print(path[#path])
            turtle.turnLeft()
            table.remove(path, #path)
        elseif path[#path] == "left" then
            print(path[#path])
            turtle.turnRight()
            table.remove(path, #path)
        end
    elseif path[#path] == "up" then
        turtle.down()
        table.remove(path, #path)
    elseif path[#path] == "down" then
        turtle.up()
        table.remove(path, #path)
    end
end

function follow_value (dir)
    mk = mk + 1
    if dir == "down" or dir == "up" then
        if dir == "down" then
            turtle.digDown()
            turtle.down()
            table.insert(path, "down")
        elseif dir == "up" then
            turtle.digUp()
            turtle.up()
            table.insert(path, "up")
        end
    else
        if dir == "left" then
            table.insert(path, "left")
        elseif dir == "right" then
            table.insert(path, "right")
        end
        turtle.dig()
        turtle.forward()
        table.insert(path, "front")
    end

    while mk >= 0 do 
        check = check_value()
        if not check then
            mv_back()
            mk = mk - 1
            do return end
        else
            follow_value(check)
        end
    end
end

function check_value ()

    success_front, block_front = turtle.inspect()
    if has_value(items_valuable, block_front.name) then
        do return "front" end
    end

    turtle.turnLeft()
    success_left, block_left = turtle.inspect()
    if has_value(items_valuable, block_left.name) then 
        do return "left"  end 
    end

    turtle.turnRight()
    turtle.turnRight()
    success_right, block_right = turtle.inspect()
    if has_value(items_valuable, block_right.name) then
        do return "right" end
    end
    turtle.turnLeft()
    
    success_down, block_down = turtle.inspectDown()
    if has_value(items_valuable, block_down.name) then
        do return "down" end 
    end

    success_up, block_up = turtle.inspectUp()
    if has_value(items_valuable, block_up.name) then 
        do return "up" end 
    end

    return false
end

function digShaft (blocks, shaftHight)
    blocks = blocks or 1
    ii = 0

    for i=1, blocks, 1 do
        ii = i
        -- print("i ", i, " blocks ", blocks)
        local success_gravel, block_gravel = turtle.inspect() 
        if block_gravel.name == "minecraft:gravel" then
            -- print(ii)
            do return ii, false end
        else
            if shaftHight then
                if turtle.detect() then                
                    turtle.dig()
                    turtle.digDown()
                end
            else
                if turtle.detect() then
                    turtle.dig()
                end
            end
            turtle.forward()

            dir_check = check_value()
            if dir_check then
                follow_value(dir_check)
            end

            mk = 0
        end
    end
    do return ii, true end
end

function returnStrip (blocks)
    turtle.turnRight()
    turtle.turnRight()

    for i=1, blocks, 1 do
        turtle.forward()
        refuel()
    end
end

function dropToChest ()
    local success, block = turtle.inspectDown()
    if success then
        if block.name == "minecraft:chest" then
            for i=1, 16, 1 do
                turtle.select(i)
                turtle.dropDown()
            end
        end
    end
end

function help_dig (width, shaftHight, type)
    val, bool = digShaft(width, shaftHight)
    if type == "bool" then
        return bool
    else
        return val 
    end
end

function stripMine (depth, width, dropStone, shaftHight)
    local depth = tonumber(depth)
    local width = tonumber(width)
    local shaft_distance = 4

    for i=depth, 1, -shaft_distance do
        refuel()

        for ii=1, shaft_distance, 1 do
            -- print("ii ", ii)
            while not help_dig(1, shaft_distance, "bool") do
                -- turtle.dig()
                print("gravel?")
            end
        end
        turtle.turnLeft()

        local not_moved_blocks, bool_blocks = digShaft(width, shaftHight)
        returnStrip(width - ( width - not_moved_blocks))

        local not_moved_blocks, bool_blocks = digShaft(width, shaftHight)
        returnStrip(width - ( width - not_moved_blocks))
        turtle.turnRight()

        if dropStone then
            dropStonef()
        end
    end

    if depth % 4 == 0 then
        returnStrip(depth + 1 )
    else
        returnStrip(depth + 1 + (4-(depth%4)))
    end
end
