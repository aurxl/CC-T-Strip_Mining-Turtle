require ".utils"
require ".miningUtils"
require ".inventoryUtils"
require ".config"

print('starting', os.getComputerLabel(), 'for stripmining\n\nFace Turtle to north!\n')

--[[ try get current gps location
if not getGPS() then
    print("unable connecting to GPS Server!")
    if choiceBool("give coordinates manually?") then
        y = choiceNumber("y coordinte", 0)
        -- y level
        yLevel = choiceNumber("mining Y level", y)
        downY = y - yLevel 
    else 
        -- y level
        yLevel = choiceNumber("mining level will be current minus given")
        downY = yLevel
        yLevel = "current minus " .. yLevel
    end
else
    y = getGPS()[1]
    -- y level
    yLevel = choiceNumber("mining Y level", y)
    downY = y - yLevel 
end
]]

--[[ depricated features and config is now in file
-- how many blocks the stripmine tunnel should be
depth = choiceNumber("mining depth", 20)

-- how many blocks the sub tunnels should be 
width = choiceNumber("mining width", 5)

-- wich direction to face north/east/south/west
direction = choice("direction(n/e/s/w)", {"n","e","s","w"})

-- will the mining shaft be 2 Blocks high?
shaftHight = choiceBool("shaft will be 2 Bloks high")

-- wether stones should be droped
dropStone = choiceBool("drop Stone?")
]]

print("\nsettings:", 
    "\n  mining depth:", miningDepth ,
    "\n  mining width:", miningWidth,
    "\n  drop Stone:  ", dropStone,
    "\n  shaft hight: ", shaftHight,
    "\n  place torch: ", placeTorch,
    "\n  torch slot:  ", torchSlot,
    "\n  place chest: ", placeChest,
    "\n  chest slot:  ", chestSlot
    )

textutils.slowWrite("continue?", 10)

if not choiceBool("") then
    do return end
end

---------------------------------------------------
--[[
    Ende des Prologs 
]]

print("\n------\nTurtle will face to given direction and move 2 Blocks forward.\nAfter that the turtle starts going to y Level and starts mining\n------")

refuel()
if dropStone then
    dropStonef()
end

-- fuelLevelSTR = tostring(turtle.getFuelLevel())
-- if choiceBool(tostring(turtle.getFuelLevel()))

--[[ depricated
setup(direction, downY)
]]

stripMine(miningDepth, miningWidth, dropStone, shaftHight, placeTorch, torchSlot, placeChest, chestSlot)
dropToChest()
print("done!")
