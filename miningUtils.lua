require ".inventoryUtils"
require ".utils"

items_valuable = {"minecraft:coal_ore", "minecraft:deepslate_coal_ore", "minecraft:iron_ore", "minecraft:deepslate_iron_ore", "minecraft:gold_ore", "minecraft:deepslate_gold_ore", "minecraft:diamond_ore", "minecraft:deepslate_diamond_ore", "create:zinc_ore", "minecraft:lapis_ore", "minecraft:deepslate_lapis_ore"}
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

function digShaft (blocks, shaftHight, placeTorch, torchSlot, placeChest, chestSlot, shaft_distance, torch_gap)
    blocks = blocks or 1
    ii = 0

    for i=1, blocks, 1 do
        ii = i
        --turtle.forward()
        -- print("i ", i, " blocks ", blocks)

        if turtle.detect() then
            turtle.dig()
            local success_gravel, block_gravel = turtle.inspect() 
            while block_gravel.name == "minecraft:gravel" do
                turtle.dig()
                success_gravel, block_gravel = turtle.inspect()
            end
        end
        if turtle.detectDown() then
            local success_torch, block_torch = turtle.inspectDown()
            if block_torch ~= "minecraft:torch" then
                turtle.digDown()
            end
        end
        if turtle.detectUp() then
            local successUp, blockUp = turtle.inspectUp()
            while blockUp.name == "minecraft:gravel" do
                turtle.digUp()
                successUp, blockUp = turtle.inspectUp()
            end
            if shaftHight == 3 and blockUp ~= "minecraft:chest" then
                turtle.digUp()
            end
        end

        if ( (shaft_distance % torch_gap) == 0) and placeTorch and i ~= 1 then
            place_Torch(torchSlot)
        end

        turtle.forward()

        dir_check = check_value()
        if dir_check then
            follow_value(dir_check)
        end

        mk = 0
        shaft_distance = shaft_distance - 1
    end
    do return ii, true end
end

function returnStrip (blocks)
    turtle.turnRight()
    turtle.turnRight()

    for i=1, blocks, 1 do
        local success, block = turtle.inspect()
        if success then
            while block_gravel.name == "minecraft:gravel" do
                turtle.dig()
                success_gravel, block_gravel = turtle.inspect()
            end
            turtle.dig()
        end
        turtle.forward()
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

function place_Torch(torchSlot)
    turtle.select(torchSlot)
    local torch = turtle.getItemDetail(torchSlot)
    if not torch then
        print("not torch in torch slot(",torchSlot,")")
        choiceBool("Continue?")
    elseif torch.name ~= "minecraft:torch" then
        print("no torch in torch slot(", torchSlot, ")")
        choiceBool("Continue?")
    end
    turtle.placeDown()
end

function inventoryFull()
    itemCount = 0
    for i=1, 16, 1 do
        item = turtle.getItemDetail(i)
        if item then
            itemCount = itemCount + 1
        end
    end

    if itemCount >= 14 then
        do return true end
    end
    return false
end

function inventoryToChest(chestSlot)
    turtle.select(chestSlot)
    chest = turtle.getItemDetail()
    if chest.name == "minecraft:chest" then
        -- place chest
        successUp, blockUp = turtle.inspectUp()
        if successUp then
            while blockUp.name == "minecraft:gravel" do
                turtle.digUp()
                successUp, blockUp = turtle.inspectUp()
            end
            turtle.digUp()
        turtle.Up()
        turtle.digUp()
        turtle.down()
        end
        turtle.placeUp()
        for i=1, 16, 1 do
            item = turtle.getItemDetail(i)
            if item then
                if item.name ~= "minecraft:chest" and item.name ~= "minecraft:coal" and item.name ~= "minecraft:torch" then
                    turtle.select(i)
                    if not turtle.dropUp() then
                        choiceBool("cant drop inventory")
                    end
                    turtle.dropUp()
                end
            end
        end
    else
        -- waiting for chests
        print("waiting for chests! (chest slot: ", chestSlot, ")")
        while chest ~= "minecraft:chest" do
            turtle.select(chestSlot)
            chest = turtle.getItemDetail()
            sleep(2)
        end
    end
end

function stripMine (depth, width, dropStone, shaftHight, placeTorch, torchSlot, placeChest, chestSlot)
    local depth = tonumber(depth)
    local width = tonumber(width)
    local shaftHight = tonumber(shaftHight)
    local torchSlot = tonumber(torchSlot)
    local shaft_distance = 4
    local torch_distance = 10

    for i=depth, 1, -shaft_distance do
        refuel()

        digShaft(shaft_distance, shaftHight, placeTorch, torchSlot, placeChest, chestSlot, depth, 8)

        turtle.turnLeft()

        local not_moved_blocks, bool_blocks = digShaft(width, shaftHight, placeTorch, torchSlot, placeChest, chestSlot, width, torch_distance )
        returnStrip(width - ( width - not_moved_blocks))

        if dropStone then
            dropStonef()
        end

        refuel()

        local not_moved_blocks, bool_blocks = digShaft(width, shaftHight, placeTorch, torchSlot, placeChest, chestSlot, width, torch_distance )
        returnStrip(width - ( width - not_moved_blocks))
        turtle.turnRight()

        if dropStone then
            dropStonef()
        end

        if placeChest and inventoryFull() then
            inventoryToChest(chestSlot)
        end
    end

    if depth % 4 == 0 then
        returnStrip(depth + 1 )
    else
        returnStrip(depth + 1 + (4-(depth%4)))
    end
end
